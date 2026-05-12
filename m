Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66C83EDE4A;
	Tue, 12 May 2026 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608685; cv=none; b=nr72IVyyuwHWJijcSKFnFsjn1dMEK/G5nOndnb2B2c3hiiDAx9NJ6dILnzskUW77xsFz1qsWxEK24zDDIyEkpEik97+RWzPCwQAp6PX0ugjiMAqNSxXrsMS/PoEQKjKr6moE8/dRdSl1aZhjKvLlILZ4LLfmt1PlBi3BRYlYEH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608685; c=relaxed/simple;
	bh=a+3hrl9ErQc3GDe2svqnlSMGuCqW6TYrldfEO+7l7FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAtJ4Ho8xHfqhxCjKT0gaLX6r08m7z+t/iPQpRsC4lpKOEUIOnAex1AezkXx6DDbSHnCYjyWoJGj2MwfKb7JrFmOGr9ctYMll12CQl7kXdO9m4RAI7As7XCU7WATXJJCL0Vq4v6qOHAnCOK6OgLjDSuoRvPaitQCySLumrNS+Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ywe6V7Eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ywe6V7Eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D07AC2BCB0;
	Tue, 12 May 2026 17:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608685;
	bh=a+3hrl9ErQc3GDe2svqnlSMGuCqW6TYrldfEO+7l7FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ywe6V7EqgBG2OWhfNL6aYg1ivX68Dgk3ielfpG61+wq35F4bfcGgLDua3gdCcy8CD
	 gBPctQBazr50pe6pDGodZ7k8GtF5ZC7GrSoBmYMkxE3PzP2gNmR+bnFBRbRGEyaISZ
	 USZ/LuXdSe7iKxv/L0qA/KBHM+hf1+mFPCpnw5+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mira Limbeck <m.limbeck@proxmox.com>,
	Keith Busch <kbusch@kernel.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 176/270] scsi: mpt3sas: Limit NVMe request size to 2 MiB
Date: Tue, 12 May 2026 19:39:37 +0200
Message-ID: <20260512173942.153449414@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

commit 04631f55afc543d5431a2bdee7f6cc0f2c0debe7 upstream.

The HBA firmware reports NVMe MDTS values based on the underlying drive
capability. However, because the driver allocates a fixed 4K buffer for
the PRP list, accommodating at most 512 entries, the driver supports a
maximum I/O transfer size of 2 MiB.

Limit max_hw_sectors to the smaller of the reported MDTS and the 2 MiB
driver limit to prevent issuing oversized I/O that may lead to a kernel
oops.

Cc: stable@vger.kernel.org
Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Tested-by: Mira Limbeck <m.limbeck@proxmox.com>
Link: https://patch.msgid.link/20260414110811.85156-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2681,8 +2681,20 @@ scsih_sdev_configure(struct scsi_device
 				pcie_device->enclosure_level,
 				pcie_device->connector_name);
 
+		/*
+		 * The HBA firmware passes the NVMe drive's MDTS
+		 * (Maximum Data Transfer Size) up to the driver. However,
+		 * the driver hardcodes a 4K buffer size for the PRP list,
+		 * accommodating at most 512 entries. This strictly limits
+		 * the maximum supported NVMe I/O transfer to 2 MiB.
+		 *
+		 * Cap max_hw_sectors to the smaller of the drive's reported
+		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
+		 */
+		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
 		if (pcie_device->nvme_mdts)
-			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
+			lim->max_hw_sectors = min(lim->max_hw_sectors,
+					pcie_device->nvme_mdts >> SECTOR_SHIFT);
 
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);


