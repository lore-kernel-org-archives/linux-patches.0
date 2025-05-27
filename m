Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770E227F16D;
	Tue, 27 May 2025 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367595; cv=none; b=llF5aae2I/BviW+R7SNOg9bgsPTAUt6JCl4lYaEkCo22j5hPQcCnRsioAZKPdKp0A9SJ31w6JY6TWzvVCGpHuBCjAyT9mBdbTAHs9El7uFXNEWt2dTSmzHnnKi0BWLc4md2MtVebIxbztQWfYuD3a8vFGQChsJclr3Or3Is4mMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367595; c=relaxed/simple;
	bh=VquKD/vkQj4TpSevMA8XHQf8V+GPaNdA4wRew/LVp2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBQZ/pr0ivyrIE0Sjmkx2LBEPPeAPF9A3EonVN4H8GSlVzu6MamoH4tffJaCn2DYi0Bgd9FDuvrfYaLoiZjKyzK5wjZXgsF+KxgGW28xKlSPPkF3TagzDhMwAd/TprPks44kkMHMYuyrUCyuYePzdgNwo9zdGbJJUikpRmcbFDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJqS7GiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJqS7GiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADEAC4CEE9;
	Tue, 27 May 2025 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367594;
	bh=VquKD/vkQj4TpSevMA8XHQf8V+GPaNdA4wRew/LVp2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJqS7GiTMnJFk5MdS9Sz0MfVUC4Fh+oUauPfjDWfrMIxAPj+/iPlXMUXV4qGnm3Be
	 MTpUoV8GdiHZtDawvPUAgAsJV1P/vFhkEYQ4mwNvcSmEc5hBIn+imGoQDzCQSM0JFL
	 P/OmFSdJFtYEgt8P5JGSNzETw+xfK9t/xX+Uo+hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 437/783] io_uring: use IO_REQ_LINK_FLAGS more
Date: Tue, 27 May 2025 18:23:54 +0200
Message-ID: <20250527162530.926130924@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 0e8934724f78602635d6e11c97ef48caa693cb65 ]

Replace the 2 instances of REQ_F_LINK | REQ_F_HARDLINK with
the more commonly used IO_REQ_LINK_FLAGS.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://lore.kernel.org/r/20250211202002.3316324-1-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f1c09e2b53022..56f10cce8f009 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -110,11 +110,13 @@
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
+#define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
+
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
 				REQ_F_ASYNC_DATA)
 
-#define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
+#define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | IO_REQ_LINK_FLAGS | \
 				 REQ_F_REISSUE | IO_REQ_CLEAN_FLAGS)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
@@ -131,7 +133,6 @@ struct io_defer_entry {
 
 /* requests with any of those set should undergo io_disarm_next() */
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
-#define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
 
 /*
  * No waiters. It's larger than any valid value of the tw counter
@@ -1150,7 +1151,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 	 * We don't know how many reuqests is there in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
 	 */
-	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
+	if (req->flags & IO_REQ_LINK_FLAGS)
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
 	guard(rcu)();
-- 
2.39.5



