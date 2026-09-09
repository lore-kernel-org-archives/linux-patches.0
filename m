Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189FB566C78;
	Wed,  9 Sep 2026 14:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963338; cv=none; b=fwIfjb1QCaPsveGn07h8woF/dKLJCGZkGarhFENOes68k9OSkPHYWx/WRrumJQoy0ZE8GzOmuWTBUidbNW46QA/97/zKGOKeZFTpJZefIpchNo2Zui90btDoS6zT2R9TIr8Z+4IH5SxpXnMltIL4Kn/uE4f8/QcQAXQNuRo4uO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963338; c=relaxed/simple;
	bh=iaGsgwFdAkMhf93CHWdiP2RvJbrwCoklRdPrXyBtpq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSQod128Pl4ajQX6fxtubazpvWFO+AnoZ8npL55OhM7j3CuqCjjE6Q3Vtgk+Rj7xteisHjR3g3SbRB6EXB885xqkA27fErrM9ao+GRMj7PFsm+cwx6P0Um4Dv36XPJ6HLkuKkqfis7RgVcmB56NWAxb/SdS401SDVFzJceXPY+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJCzjiKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJCzjiKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B361F00A3A;
	Wed,  9 Sep 2026 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963336;
	bh=E6Uu+5g59Ebxw+Ac964ZyWsYImdseMnCpXBaXuxxrWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJCzjiKjvB+FFn1RDMafJG37HQpkkTTGXgb+pDzhAmLZ3N2EpjxpF0GIFs29yTnFv
	 ce3pVVJ+acEqW+wjGmRDXoewwl3unrS4iZYkCMSKu2rWj5WEHOjaGOl3HRWH+1riNv
	 vhiXYp8+mL8T+QCLUj1Q+gAH0NtQhC/GxAJ8U054=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Magiera <me@magik.net>,
	Mira Limbeck <m.limbeck@proxmox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Lamprecht <t.lamprecht@proxmox.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 045/583] scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame
Date: Wed,  9 Sep 2026 15:35:30 +0200
Message-ID: <20260909134239.483665629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Thomas Lamprecht <t.lamprecht@proxmox.com>

commit af8c27375733fb6a6df9fa484cda77cc3dd0cb80 upstream.

megasas_make_prp_nvme() builds a command's PRP list in cmd->sg_frame, a
DMA pool buffer of instance->max_chain_frame_sz bytes, spending one
entry per NVMe page of the transfer plus one per page of the buffer for
the chain pointer. The loop runs until the transfer is described and
never checks the buffer bound.

max_hw_sectors comes straight from the MDTS the firmware reports for the
drive. On drives with a large MDTS the only thing keeping the list
inside the buffer was the block layer default of 1280 KiB, which needs
320 entries, which fit into a 4 KiB frame as that holds 512. But since
commit 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP") that
default is 4 MiB, and such a transfer needs 1025 entries, so the list
runs a full page past the end of the frame:

  sd 1:0:1:0: [sdb] tag#630 page boundary ptr_sgl: 0x00000000ba62d13f
  BUG: unable to handle page fault for address: ff663bcb81e7c000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  RIP: 0010:megasas_build_and_issue_cmd_fusion+0xeaa/0x1870 [megaraid_sas]

If the page after the frame happens to be mapped, the overrun does not
fault but silently corrupts the neighbouring pool entry, which is
another in-flight command's PRP list.

Cap max_hw_sectors at what the chain frame can describe, less one page
for transfers that do not start on a page boundary and so need one entry
more. This is the megaraid_sas counterpart of commit 04631f55afc5
("scsi: mpt3sas: Limit NVMe request size to 2 MiB"), but derives the
limit from max_chain_frame_sz rather than hardcoding it.

Cc: stable@vger.kernel.org
Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
Reported-by: Lukasz Magiera <me@magik.net>
Closes: https://lore.kernel.org/all/GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net/
Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
Closes: https://lore.kernel.org/all/d171cc76-bf25-48ce-b482-d344669dfc24@proxmox.com/
Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/all/yq17bmzd5jr.fsf@ca-mkp.ca.oracle.com/
Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Closes: https://lore.kernel.org/linux-scsi/20260827182106.535D61F000E9@smtp.kernel.org
Link: https://patch.msgid.link/20260827175743.734593-1-t.lamprecht@proxmox.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f0152b043e18..b95f187297ae 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1973,12 +1973,23 @@ megasas_set_nvme_device_properties(struct scsi_device *sdev,
 {
 	struct megasas_instance *instance;
 	u32 mr_nvme_pg_size;
+	u64 max_prp_io;
 
 	instance = (struct megasas_instance *)sdev->host->hostdata;
 	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
 				MR_DEFAULT_NVME_PAGE_SIZE);
 
-	lim->max_hw_sectors = max_io_size / 512;
+	/*
+	 * megasas_make_prp_nvme() builds the PRP list in cmd->sg_frame without
+	 * bounding it against that buffer, and spends one entry per page of
+	 * it on the chain pointer. Cap the transfer at what the buffer holds,
+	 * less one page for lists that start off a page boundary.
+	 */
+	max_prp_io = (u64)((instance->max_chain_frame_sz / sizeof(u64)) -
+			   (instance->max_chain_frame_sz / mr_nvme_pg_size) - 1) *
+		     mr_nvme_pg_size;
+
+	lim->max_hw_sectors = min_t(u64, max_io_size, max_prp_io) >> SECTOR_SHIFT;
 	lim->virt_boundary_mask = mr_nvme_pg_size - 1;
 }
 
-- 
2.55.0



