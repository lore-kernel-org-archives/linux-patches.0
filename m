Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA47B222590;
	Mon, 22 Sep 2025 19:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570092; cv=none; b=nnoNILm9QBlS3JEX+AK9wZj/DwZw8wPljKpG2v659MWcUqPtoK3/yCl7JPoyPbD/RuMa2MjQXOQPwgHXV81b4qGDXCBrihrNMeoAvMN61aBdqL47EJvt3rK110y9npIRa06GDTkTU8MUjckR+CBGq6JYD4Fj4F0XDL9qq0mAsx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570092; c=relaxed/simple;
	bh=4gLB5VwwXmOGnszYXRw6xzcCdJlz2fAELS6tCrkShh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khkXpD80n7FOOGMXWbMwBbcwSMNZrN5xSg2Ge8hxQG8zUKMQ60dyy9cdsJAdq81DfsKO7QePiMApJFEknPEMlp/qT2svAJ+oZkPL0G3iqwbGVC+pu/ZSUzhV3orvBM8JtxAp+TRNec9NwOGQkyGpSXEj46X+f6nSh18W+MW6QRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHaMxOKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHaMxOKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3396BC4CEF0;
	Mon, 22 Sep 2025 19:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570091;
	bh=4gLB5VwwXmOGnszYXRw6xzcCdJlz2fAELS6tCrkShh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHaMxOKr34DFNYrCxMh+/HVDu+o/hk1nmP+yT2pryYNejyTk0g0lElVTmfsgeKtpY
	 Nt2O6PNQCpU/krWlqtc8MpItHPxSMRF+BVSF5evfKymW4/md4EgaPLPCgxXy5PLBZW
	 WxUCgqwfcq0DeTzWUtP57QqTNtOIRHcqj1s11sks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 006/149] nvme: fix PI insert on write
Date: Mon, 22 Sep 2025 21:28:26 +0200
Message-ID: <20250922192413.051878889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7ac3c2889bc060c3f67cf44df0dbb093a835c176 ]

I recently ran into an issue where the PI generated using the block layer
integrity code differs from that from a kernel using the PRACT fallback
when the block layer integrity code is disabled, and I tracked this down
to us using PRACT incorrectly.

The NVM Command Set Specification (section 5.33 in 1.2, similar in older
versions) specifies the PRACT insert behavior as:

  Inserted protection information consists of the computed CRC for the
  protection information format (refer to section 5.3.1) in the Guard
  field, the LBAT field value in the Application Tag field, the LBST
  field value in the Storage Tag field, if defined, and the computed
  reference tag in the Logical Block Reference Tag.

Where the computed reference tag is defined as following for type 1 and
type 2 using the text below that is duplicated in the respective bullet
points:

  the value of the computed reference tag for the first logical block of
  the command is the value contained in the Initial Logical Block
  Reference Tag (ILBRT) or Expected Initial Logical Block Reference Tag
  (EILBRT) field in the command, and the computed reference tag is
  incremented for each subsequent logical block.

So we need to set ILBRT field, but we currently don't.  Interestingly
this works fine on my older type 1 formatted SSD, but Qemu trips up on
this.  We already set ILBRT for Write Same since commit aeb7bb061be5
("nvme: set the PRACT bit when using Write Zeroes with T10 PI").

To ease this, move the PI type check into nvme_set_ref_tag.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 895fb163d48e6..5395623d2ba6a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -903,6 +903,15 @@ static void nvme_set_ref_tag(struct nvme_ns *ns, struct nvme_command *cmnd,
 	u32 upper, lower;
 	u64 ref48;
 
+	/* only type1 and type 2 PI formats have a reftag */
+	switch (ns->head->pi_type) {
+	case NVME_NS_DPS_PI_TYPE1:
+	case NVME_NS_DPS_PI_TYPE2:
+		break;
+	default:
+		return;
+	}
+
 	/* both rw and write zeroes share the same reftag format */
 	switch (ns->head->guard_type) {
 	case NVME_NVM_NS_16B_GUARD:
@@ -942,13 +951,7 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 
 	if (nvme_ns_has_pi(ns->head)) {
 		cmnd->write_zeroes.control |= cpu_to_le16(NVME_RW_PRINFO_PRACT);
-
-		switch (ns->head->pi_type) {
-		case NVME_NS_DPS_PI_TYPE1:
-		case NVME_NS_DPS_PI_TYPE2:
-			nvme_set_ref_tag(ns, cmnd, req);
-			break;
-		}
+		nvme_set_ref_tag(ns, cmnd, req);
 	}
 
 	return BLK_STS_OK;
@@ -1039,6 +1042,7 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 			if (WARN_ON_ONCE(!nvme_ns_has_pi(ns->head)))
 				return BLK_STS_NOTSUPP;
 			control |= NVME_RW_PRINFO_PRACT;
+			nvme_set_ref_tag(ns, cmnd, req);
 		}
 
 		if (bio_integrity_flagged(req->bio, BIP_CHECK_GUARD))
-- 
2.51.0



