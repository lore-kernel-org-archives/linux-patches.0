Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41292745E;
	Fri, 21 Nov 2025 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732302; cv=none; b=Hr0nH/Cbq1XqLbSrLkQL+qnontVGToIaF1YsfqxPjoUD+bTv3H4OdF4q5+BS8YtuLJF+Ost9r+ObjilrhHu6Vlj/lB/R5tm9K9/YjDV8mecBLA4mfFAES9HHcYbPNHXcoPFiN9ehxXYQ4mavioCv8ki6KtwxNJMdq4vKTtAtnIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732302; c=relaxed/simple;
	bh=LnMKVntT5OvZVdIuA0Tbzffaw2JxpGv8MEquHevzHX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrkZSIjbgMkAQchK4/MEXLM/hsMvkzkI683rI1Pe82IrhjySa0CwdkYGNBswyDjJOfBdo5PgdyFP1+Gvtu3Dcehd5YW0RoH2+fnic8RsOfPgr33CesGzXSH/u6tbAcmIKr9Zwk8XQUfikcd/3VRRmK0HutgTp4v5ALfyLuilwx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5B0CVtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5B0CVtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A49C4CEF1;
	Fri, 21 Nov 2025 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732301;
	bh=LnMKVntT5OvZVdIuA0Tbzffaw2JxpGv8MEquHevzHX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5B0CVtvNiO4S1p0tDjjiO8EPAZtmaI0XybieTtyw3kK0AD4iXaQNSaj2ZA/5U1fr
	 vVRfBItK8gqPxsYRAlBDNGKf0zW1sntHtd3xQ1EUWQu3kR5dEKh4FoPzHB+v0kqJw7
	 Zb+XH0yoAe6zdcYSROivcDBcxEkShQzeyOXj/UCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/529] hwmon: (k10temp) Add thermal support for AMD Family 1Ah-based models
Date: Fri, 21 Nov 2025 14:06:13 +0100
Message-ID: <20251121130233.657525594@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c906731c6c2d3..759855412e50d 100644
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
@@ -545,7 +552,9 @@ static const struct pci_device_id k10temp_id_table[] = {
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



