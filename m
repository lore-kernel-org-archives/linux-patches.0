Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC3257AD1;
	Tue, 11 Nov 2025 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822717; cv=none; b=ANLczsfd9AVQHL8UHaS+r5LnRxH70VSiiNZatLN74T8OwbBe69I9xhLnjq5SAHAjA2gfRDu5jepaPkyYg02GVzZ9uotDqiUot4EBPPBZE1yqiWOm3YzR0wB0oALeGxo5nGgyNUi1w6n7dzQSOZu7JGEcGFX3irnQfiOWkh+eQLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822717; c=relaxed/simple;
	bh=uZDVG00fe+s2RQUNIJt3AoCM9cJKA5KmDXaKlWVHntA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y81wsOVxiWmL8cI+gimIiwbxJ8Z5O4ZXiGMswfQ/wbiPfJUHkTlEStYiKHvK71NpPuVw/3OISyS765pEAFmF5TBUypmDlhCOiqJyBBBYOYGOViHhLeR2ldTjU1eeI4Sfl6WmJIVLrQ98zzK2CqCjyuVxk4HUfJSh04/j/FRPer8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAiq5YZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAiq5YZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9CCC113D0;
	Tue, 11 Nov 2025 00:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822717;
	bh=uZDVG00fe+s2RQUNIJt3AoCM9cJKA5KmDXaKlWVHntA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAiq5YZPWZTnqwIZ2HUlkLv9JamVJfZfzQZJ6Y1hCFJjHnkKzwOXwwMMJmQNYHIz8
	 F1lgIeNV/HhUuapFT9PNjmqMXt3Qcql4GtoODzhTRjA8LRy7t6PuEEAewrABiIDSI3
	 ptnWU5+tVmFYpKtftYsuYM3ymoO5AzTexmDcZOBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 154/849] hwmon: (k10temp) Add thermal support for AMD Family 1Ah-based models
Date: Tue, 11 Nov 2025 09:35:24 +0900
Message-ID: <20251111004540.147993914@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avadhut Naik <avadhut.naik@amd.com>

[ Upstream commit f116af2eb51ed9df24911537fda32a033f1c58da ]

Add thermal info support for newer AMD Family 1Ah-based models.

Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Link: https://lore.kernel.org/r/20250729001644.257645-1-avadhut.naik@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/k10temp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index babf2413d666f..2f90a2e9ad496 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -84,6 +84,13 @@ static DEFINE_MUTEX(nb_smu_ind_mutex);
  */
 #define AMD_I3255_STR				"3255"
 
+/*
+ * PCI Device IDs for AMD's Family 1Ah-based SOCs.
+ * Defining locally as IDs are not shared.
+ */
+#define PCI_DEVICE_ID_AMD_1AH_M50H_DF_F3	0x12cb
+#define PCI_DEVICE_ID_AMD_1AH_M90H_DF_F3	0x127b
+
 struct k10temp_data {
 	struct pci_dev *pdev;
 	void (*read_htcreg)(struct pci_dev *pdev, u32 *regval);
@@ -556,7 +563,9 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_19H_M78H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M00H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M50H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M90H_DF_F3) },
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}
 };
-- 
2.51.0



