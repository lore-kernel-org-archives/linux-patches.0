Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086C34369A;
	Wed, 25 Feb 2026 01:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982887; cv=none; b=KJKyx6e4lVHv06MnIeqpch2jo6wYx7HschxJ+NAbY2pc+Ti+Hpr3ILTowpJQHFAJOpeLAbVbnIO/dcf1BGNIYznoQV/3+bDUcguRdbaXHijxzH0h+CVCsw3aFKxZlv5e8/XP5CvvRsMX0GNhKccMfBjzfM3l3i6xGbzDs96p6qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982887; c=relaxed/simple;
	bh=/k3ow8KVRtNJehrK55nV+YqBiEgK5ChaspB2Rz8XPyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETOdpvxzn4DaNnr3KejaYtkRNsGnvLVH+oFQtdabTjfGOgf+oFC7Cnr7tkW9ouEpkXfsrjjTXr4JyWOQvvwXEXLSBgrjN9/W+meYM1Py8vqbKrKKqWiz7K/aYzh2UHkyOzxoetzPOCjV/5vh0aTDmD26G2vpvl0FzqwI76bAbL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpAo/+Rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpAo/+Rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B337C116D0;
	Wed, 25 Feb 2026 01:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982886;
	bh=/k3ow8KVRtNJehrK55nV+YqBiEgK5ChaspB2Rz8XPyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpAo/+Rfn8QQvZnhaVSVyAR4OZdxfsdV5yASJe2TTNQ1Pz81jdC7SB9j5xQX3eXM+
	 Ql5f7Sopt1qZ5xIuKY4Pvj3GnQNaIi6OOAkPK+w5C+3gybNpUoKAJhVJxAjXhj0nkz
	 8tmlmshrVKkZFU4JBMq2FKb9hh0SQ76m9zH4Td18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 017/781] gfs2: Rename gfs2_log_submit_{bio -> write}
Date: Tue, 24 Feb 2026 17:12:06 -0800
Message-ID: <20260225012400.123337041@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 59d81037d32ff1e415dcaa359c238c9ca730932d ]

Rename gfs2_log_submit_bio() to gfs2_log_submit_write(): this function
isn't used for submitting log reads.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 4a94f052e098 ("gfs2: Initialize bio->bi_opf early")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c  | 4 ++--
 fs/gfs2/lops.c | 6 +++---
 fs/gfs2/lops.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 8312cd2cdae47..2a3b9d10eba78 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -889,7 +889,7 @@ void gfs2_write_log_header(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd,
 	lh->lh_crc = cpu_to_be32(crc);
 
 	gfs2_log_write(sdp, jd, page, sb->s_blocksize, 0, dblock);
-	gfs2_log_submit_bio(&jd->jd_log_bio, REQ_OP_WRITE | op_flags);
+	gfs2_log_submit_write(&jd->jd_log_bio, REQ_OP_WRITE | op_flags);
 }
 
 /**
@@ -1096,7 +1096,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 	if (gfs2_withdrawn(sdp))
 		goto out_withdraw;
 	if (sdp->sd_jdesc)
-		gfs2_log_submit_bio(&sdp->sd_jdesc->jd_log_bio, REQ_OP_WRITE);
+		gfs2_log_submit_write(&sdp->sd_jdesc->jd_log_bio, REQ_OP_WRITE);
 	if (gfs2_withdrawn(sdp))
 		goto out_withdraw;
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index d27a0b1080a97..aa9e9fe25c2f7 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -229,7 +229,7 @@ static void gfs2_end_log_write(struct bio *bio)
 }
 
 /**
- * gfs2_log_submit_bio - Submit any pending log bio
+ * gfs2_log_submit_write - Submit a pending log write bio
  * @biop: Address of the bio pointer
  * @opf: REQ_OP | op_flags
  *
@@ -237,7 +237,7 @@ static void gfs2_end_log_write(struct bio *bio)
  * there is no pending bio, then this is a no-op.
  */
 
-void gfs2_log_submit_bio(struct bio **biop, blk_opf_t opf)
+void gfs2_log_submit_write(struct bio **biop, blk_opf_t opf)
 {
 	struct bio *bio = *biop;
 	if (bio) {
@@ -303,7 +303,7 @@ static struct bio *gfs2_log_get_bio(struct gfs2_sbd *sdp, u64 blkno,
 		nblk >>= sdp->sd_fsb2bb_shift;
 		if (blkno == nblk && !flush)
 			return bio;
-		gfs2_log_submit_bio(biop, op);
+		gfs2_log_submit_write(biop, op);
 	}
 
 	*biop = gfs2_log_alloc_bio(sdp, blkno, end_io);
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index be740bf336664..010a4696406bb 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -17,7 +17,7 @@ u64 gfs2_log_bmap(struct gfs2_jdesc *jd, unsigned int lbn);
 void gfs2_log_write(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd,
 		    struct page *page, unsigned size, unsigned offset,
 		    u64 blkno);
-void gfs2_log_submit_bio(struct bio **biop, blk_opf_t opf);
+void gfs2_log_submit_write(struct bio **biop, blk_opf_t opf);
 void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh);
 int gfs2_find_jhead(struct gfs2_jdesc *jd,
 		    struct gfs2_log_header_host *head);
-- 
2.51.0



