Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9022236FC;
	Tue,  8 Apr 2025 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116174; cv=none; b=ppcjZ2Hx+29+7UvLWytC5WY24BmSPKcAwdyNd9cKA2YumGwLlJVSMcmxJqVrtv5e6sFgSFzPoZAdaZsa32uD22ab8eWZ+9pYSVLG45iMdqM2kdgcvSLZOxZGIjpiAipE5Lw1VJh1PacNd92UpHqHHt9mcNkLFZ/IOOduGwDh1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116174; c=relaxed/simple;
	bh=xO7UrZu+ULa78evZpHu/MFRPccfMHavfBHDIyPdr+1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRKIaw63dw4ENkgPfYArdh6RMrBM5oFgimMZzchdx5AOqJz5IKr9OflCrKhE4lSXLwh4Vl/X7ChLb6j8Y8t1uXzLsINdTVnHYydLPc6Lc49ubR3J6oLx0wBvF2p0t8HCNTaJFnq/ZpOamYcTKPiLH+IMzn5vvfXkUrrdbt+WehA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwQCvKmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwQCvKmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C92C4CEE5;
	Tue,  8 Apr 2025 12:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116174;
	bh=xO7UrZu+ULa78evZpHu/MFRPccfMHavfBHDIyPdr+1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwQCvKmJNaroavTDPSn/SklHtSyp6KgUOWRicDYmitMFI8QOubj9/euIBfu2d6D4S
	 ZIalVUabn40dge8Jq0mFozq5BV4OWaxkgqBnmkzXILFWUwjeqj4YcV/hijclf53Vvw
	 dPkO6/xJr3dKeKaYWkHq75t3DVw6EdVw8OdlgHAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/423] ASoC: amd: acp: Fix for enabling DMIC on acp platforms via _DSD entry
Date: Tue,  8 Apr 2025 12:46:07 +0200
Message-ID: <20250408104846.707251789@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index be01b178172e8..e4af2640feeb1 100644
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
 	case ACP3X_DEV:
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
 EXPORT_SYMBOL_NS_GPL(check_acp_config, SND_SOC_ACP_COMMON);
-- 
2.39.5



