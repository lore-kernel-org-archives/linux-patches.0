Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCF338A2A4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300982; cv=none; b=R0Whd1PU71EWGl/oxNzBvInKceQ8YHGdos4okHAuWQUZhWSQR0nCC1+fsK1tZbQ28vHSNZxlzkHpbegSEGiZ5tdIfJqfFZAJ2lmGecrh8o4FVU8c3DizunstXSiuZRsmIMMAlMUC27r6MFKf+2rIxvTE9uhFelOIYvYYBYsCfYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300982; c=relaxed/simple;
	bh=OIc3QhrvqAbcmusi4JachL3maf+enze1ECfwr8eFCg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8/X2ky2bkX55zUqPkV7kzfh7bV7AvBBLqmG/dZmQ56yp5PzzFbpzxaPro1ti7iiESdglL1nf0dfsT0Pmten9GeuX5mLabEP9Ebay98MN9FSgTXb6/sELD8JG1z+/w9q2JezkugCRzvaJa1TtJiNhWUbgJP6i59QitZazmtmQBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1e9Z6ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1e9Z6ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351B4C19423;
	Sat, 28 Feb 2026 17:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300982;
	bh=OIc3QhrvqAbcmusi4JachL3maf+enze1ECfwr8eFCg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1e9Z6ZBGrvWWU3JAukrPn31Sr08MwBTz2QW0JQCWH4SZbs+MIKTGyepWdX7PcKuL
	 8niOm8V8iq2im5bBO1d+ddvARYfiSAJsNChhfojsCPYjOUZQss48uurIMrumu8t8Dr
	 bBRU1Ad0CpquzXP4NxCoBCVlMRYsDHctPjQ3FWsP4PmSTgN9XbDY4XaesLVt4GHjMM
	 zpcPN5U+YZSbdksZOICTQaaDWy0zVxhxtVIe6E3mx7gQwbfQCKNSRuhBlqfKVJv4+n
	 eAVr+sE08mAGZ8Yo2eAzzX8kYSYvN6R/1nlTS+gtJVDGxdzFSepO7sXg/3kcTirxB5
	 xDOppL9XV8exw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/752] accel/amdxdna: Fix tail-pointer polling in mailbox_get_msg()
Date: Sat, 28 Feb 2026 12:37:03 -0500
Message-ID: <20260228174750.1542406-112-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit cd77d5a4aaf8c5c1d819f47cf814bf7d4920b0a2 ]

In mailbox_get_msg(), mailbox_reg_read_non_zero() is called to poll for a
non-zero tail pointer. This assumed that a zero value indicates an error.
However, certain corner cases legitimately produce a zero tail pointer.
To handle these cases, remove mailbox_reg_read_non_zero(). The zero tail
pointer will be treated as a valid rewind event.

Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251204181603.793824-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_mailbox.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_mailbox.c b/drivers/accel/amdxdna/amdxdna_mailbox.c
index a80c77a478bff..2bacb89cd80c9 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -112,22 +112,6 @@ static u32 mailbox_reg_read(struct mailbox_channel *mb_chann, u32 mbox_reg)
 	return readl(ringbuf_addr);
 }
 
-static int mailbox_reg_read_non_zero(struct mailbox_channel *mb_chann, u32 mbox_reg, u32 *val)
-{
-	struct xdna_mailbox_res *mb_res = &mb_chann->mb->res;
-	void __iomem *ringbuf_addr = mb_res->mbox_base + mbox_reg;
-	int ret, value;
-
-	/* Poll till value is not zero */
-	ret = readx_poll_timeout(readl, ringbuf_addr, value,
-				 value, 1 /* us */, 100);
-	if (ret < 0)
-		return ret;
-
-	*val = value;
-	return 0;
-}
-
 static inline void
 mailbox_set_headptr(struct mailbox_channel *mb_chann, u32 headptr_val)
 {
@@ -288,8 +272,7 @@ static int mailbox_get_msg(struct mailbox_channel *mb_chann)
 	u32 start_addr;
 	int ret;
 
-	if (mailbox_reg_read_non_zero(mb_chann, mb_chann->res[CHAN_RES_I2X].mb_tail_ptr_reg, &tail))
-		return -EINVAL;
+	tail = mailbox_get_tailptr(mb_chann, CHAN_RES_I2X);
 	head = mb_chann->i2x_head;
 	ringbuf_size = mailbox_get_ringbuf_size(mb_chann, CHAN_RES_I2X);
 	start_addr = mb_chann->res[CHAN_RES_I2X].rb_start_addr;
-- 
2.51.0

