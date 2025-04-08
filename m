Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B1B26AA86;
	Tue,  8 Apr 2025 12:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114288; cv=none; b=FpD3k5EpSEbGb8a3vxRlmM93Oqt0cw7j+RtgAcYWWzDiSR/12B3Xqn50nWGqjYxrgi4mIorUhFJprZjLLuWrnsO4UJDgrW1ZB5YzOh4gaPh2M8DH4RvkM5glwsyF7ZDrai/N0xwKiAbluq466TU7LE12yT7kEvsnHDTceR6xrTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114288; c=relaxed/simple;
	bh=4X6K6RlgP7o2G+Dvalxj7yrsD3SVSRQY5fONSqr8U88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbiE/LSlP5TOAIf7DnhVy6C8SZcuu3k72zJ1jOJ9yEklU2TQSuN6LtaPZR9SJqvf25JMFQDUwakr9dDpWLEHA8iI+CNgsVtR9SihNiYWq7qgMTGh+pcNtxfXyL+QI06fDrHx6Q1hQqSRc4QsHED8M+eK4jtwQMaZzBnQtLROBdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0gNy0nb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0gNy0nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72421C4CEE5;
	Tue,  8 Apr 2025 12:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114287;
	bh=4X6K6RlgP7o2G+Dvalxj7yrsD3SVSRQY5fONSqr8U88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0gNy0nbcTa/LELXS56jICU/UDd+eYT8yzyIbkMfg3yXHW7xf7G7vzWxeB3K6wJ+e
	 ToHngGnSvwmVerfGNEnsrMF6rD6sr1NSqoZ+da+OorNrj/MKCrvo4fqz8W8RBH7Mr6
	 D6Vom+NCB7SRcIXSrFFVHlIY0ukjBmix1nDiFiQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 052/499] ASoC: amd: acp: Fix for enabling DMIC on acp platforms via _DSD entry
Date: Tue,  8 Apr 2025 12:44:24 +0200
Message-ID: <20250408104852.537647727@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 02e1cf7a352a3ba5f768849f2b4fcaaaa19f89e3 ]

Add condition check to register ACP PDM sound card by reading
_WOV acpi entry.

Fixes: 09068d624c49 ("ASoC: amd: acp: fix for acp platform device creation failure")

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://patch.msgid.link/20250310183201.11979-15-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-legacy-common.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-legacy-common.c b/sound/soc/amd/acp/acp-legacy-common.c
index 7acc7ed2e8cc9..b9f085c560c2d 100644
--- a/sound/soc/amd/acp/acp-legacy-common.c
+++ b/sound/soc/amd/acp/acp-legacy-common.c
@@ -13,6 +13,7 @@
  */
 
 #include "amd.h"
+#include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/export.h>
 
@@ -445,7 +446,9 @@ void check_acp_config(struct pci_dev *pci, struct acp_chip_info *chip)
 {
 	struct acpi_device *pdm_dev;
 	const union acpi_object *obj;
-	u32 pdm_addr;
+	acpi_handle handle;
+	acpi_integer dmic_status;
+	u32 pdm_addr, ret;
 
 	switch (chip->acp_rev) {
 	case ACP_RN_PCI_ID:
@@ -477,6 +480,11 @@ void check_acp_config(struct pci_dev *pci, struct acp_chip_info *chip)
 						   obj->integer.value == pdm_addr)
 				chip->is_pdm_dev = true;
 		}
+
+		handle = ACPI_HANDLE(&pci->dev);
+		ret = acpi_evaluate_integer(handle, "_WOV", NULL, &dmic_status);
+		if (!ACPI_FAILURE(ret))
+			chip->is_pdm_dev = dmic_status;
 	}
 }
 EXPORT_SYMBOL_NS_GPL(check_acp_config, "SND_SOC_ACP_COMMON");
-- 
2.39.5



