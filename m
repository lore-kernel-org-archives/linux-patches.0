Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B27267B07;
	Tue, 11 Nov 2025 01:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822834; cv=none; b=XaevnhDjKAi6Z8qOyDyxX9ovDn+bwn0OC0nROT3P2iyrC96yLEWfRU3kr39rUmdO/03O2J3FPuTgbsj3z/3iOMgbr9Q1zhG5fPc7JVxLhW41w8reZsP6Sc9ZHynkJdNLsbY1Nj8UvRpXoctxGz0okiECsR2oGT8oqin51/EY/Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822834; c=relaxed/simple;
	bh=3n8WJyd06KpaKCzcTxj2iZFWuMth0nujntvJzbLOT+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvUXDXGCAzersI5r6b92WucPW/YTbaQuN4jWiEREC35E4pjVtIhnexQL7k2ZWYiYMgk+5utXnGJ9iPeLW5v6PTRHwWki+Y6C6tsA2wULlx1am7JiasUrzbPUlKyhP/3156FWDTNQ7xFv7pHIL4hqNHlHK8G+FDTGelSky5Fxs9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDpUDy1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDpUDy1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAFBC19424;
	Tue, 11 Nov 2025 01:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822834;
	bh=3n8WJyd06KpaKCzcTxj2iZFWuMth0nujntvJzbLOT+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDpUDy1CWGVm/Th5JgomTDHRYhvYqbgQfNyKiw911HjSwKmb993zhViLZgOJdHmm4
	 ap9F014w+mrVE7ZcizvFY2aboZIp77MjW+tzSnnvEalpC4Ggg/lKB3mP/9G7kn42C6
	 VQK0kpSKIp+/f9FRrhbqdHP+1OUgwIKRok6RZ7Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/565] hwmon: (k10temp) Add thermal support for AMD Family 1Ah-based models
Date: Tue, 11 Nov 2025 09:39:33 +0900
Message-ID: <20251111004529.588284170@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7dc19c5d62ac3..c457ba4706197 100644
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
@@ -542,7 +549,9 @@ static const struct pci_device_id k10temp_id_table[] = {
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



