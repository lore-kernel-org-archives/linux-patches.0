Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9CD1A841F;
	Wed, 19 Feb 2025 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955493; cv=none; b=q36q9IbsyGNHpdDurXQAJiZps6XLxJvM0DYprafEFcrELBD64/MUwlnQYSkZHJ9J76H1wil2CWgRd+wGsTeQJVovJ17Y/gJfEqZv9bazhZHPNTcQRXKS2QMhImm/NY7hbm6uOzAdG7kYEvDxbFcAJpFJbJl85w6ceMMDLDQnGjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955493; c=relaxed/simple;
	bh=/brVrkQdGmJls25UB6CcMf154mbSA+M7rvV6G/sdWmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnJNWBB9ArfMUlMUpsjsmDExL9zGkVM8/ptse62Pyi9vZfbjkH0G9AgfXK4AQjt21PlppKrOLDJPcfZz8u0q8D8vpQlATg8Jjud49FWIZaciDRDXzuHDmGf5T/trCJQK6w/ERyiXIBQGC0k2u3dWbeHtEbLPIiuJ8wafVB4s5W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaFSrFTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaFSrFTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E8BC4CED1;
	Wed, 19 Feb 2025 08:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955492;
	bh=/brVrkQdGmJls25UB6CcMf154mbSA+M7rvV6G/sdWmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaFSrFTeui89XpCroQ91ORL9SW37NRPm868g8vYWlUKza8g5Zds/ZzRyFU3iRd76M
	 ENqLokFzbDMD2+mDUHloT3Ix7bWDdH7ncAS1IF+meYng3v80vIfD2Jx5Hq3fU5cfbE
	 Sa+8o5QY41FXzqbViaCE4viFAKmWXFT79q1g1k3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/152] block: cleanup and fix batch completion adding conditions
Date: Wed, 19 Feb 2025 09:27:16 +0100
Message-ID: <20250219082550.951391825@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 1f47ed294a2bd577d5ae43e6e28e1c9a3be4a833 ]

The conditions for whether or not a request is allowed adding to a
completion batch are a bit hard to read, and they also have a few
issues. One is that ioerror may indeed be a random value on passthrough,
and it's being checked unconditionally of whether or not the given
request is a passthrough request or not.

Rewrite the conditions to be separate for easier reading, and only check
ioerror for non-passthrough requests. This fixes an issue with bio
unmapping on passthrough, where it fails getting added to a batch. This
both leads to suboptimal performance, and may trigger a potential
schedule-under-atomic condition for polled passthrough IO.

Fixes: f794f3351f26 ("block: add support for blk_mq_end_request_batch()")
Link: https://lore.kernel.org/r/20575f0a-656e-4bb3-9d82-dec6c7e3a35c@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blk-mq.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 958ed7e89b301..1d482c2aabbdf 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -849,12 +849,22 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 				       void (*complete)(struct io_comp_batch *))
 {
 	/*
-	 * blk_mq_end_request_batch() can't end request allocated from
-	 * sched tags
+	 * Check various conditions that exclude batch processing:
+	 * 1) No batch container
+	 * 2) Has scheduler data attached
+	 * 3) Not a passthrough request and end_io set
+	 * 4) Not a passthrough request and an ioerror
 	 */
-	if (!iob || (req->rq_flags & RQF_SCHED_TAGS) || ioerror ||
-			(req->end_io && !blk_rq_is_passthrough(req)))
+	if (!iob)
 		return false;
+	if (req->rq_flags & RQF_SCHED_TAGS)
+		return false;
+	if (!blk_rq_is_passthrough(req)) {
+		if (req->end_io)
+			return false;
+		if (ioerror < 0)
+			return false;
+	}
 
 	if (!iob->complete)
 		iob->complete = complete;
-- 
2.39.5



