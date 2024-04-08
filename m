Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E677E0F3;
	Mon,  8 Apr 2024 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583579; cv=none; b=Tm+0VnFN0MzMGmNuwPyDbajz54POGi8Lo3Tmh+EdUUyy7Y09Iv6OzKSn2hiddz+iR3Jmbs4l3SjzxR2sz+svLj1mI7cOzrFxBx8G077Kfppi4dowmdmdKIJh5pcw4asHKcEde743ZQyugHpywr/kOsf4wWJ1z/Lynh0MmJSIY4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583579; c=relaxed/simple;
	bh=cfeGW69u5B2sxVNRYIsmPz8ZhKZ8g+hD3fqozSUFOHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzfhn37EXis9GGm8QG3i3F6ZQiA1+q9+9e8vXanKsfveoVl3HgSiyLjUh8AXbhoPEFWM/eLpBXKgkIezJSHuSOvsC+J0xW/bEA0+JQHlVWOnGDKDoO+yACQX8+lJyUWaaRa0vKFebrhcxMF2i8/FtG12TN6EaqmrCDJPtCxXsII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcygb/2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcygb/2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44C8C433F1;
	Mon,  8 Apr 2024 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583579;
	bh=cfeGW69u5B2sxVNRYIsmPz8ZhKZ8g+hD3fqozSUFOHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcygb/2Kzs+UDPARyYHFHn41kpQ/cRDBNUBfVBnKO1+tpDuY821X8LRGwxil5ZQ67
	 O2B6QiInrsOP8Ls+9BPZTXaU2YOY99Akq3wIRutmA6Bfjr5lXw0GvpZKWST+VkVCwQ
	 KQUKVKULrR1rut+9u0eBIqaB+TpSgbmqWPCx4gyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 210/252] io_uring/kbuf: get rid of bl->is_ready
Date: Mon,  8 Apr 2024 14:58:29 +0200
Message-ID: <20240408125313.170906862@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 3b80cff5a4d117c53d38ce805823084eaeffbde6 upstream.

Now that xarray is being exclusively used for the buffer_list lookup,
this check is no longer needed. Get rid of it and the is_ready member.

Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    8 --------
 io_uring/kbuf.h |    2 --
 2 files changed, 10 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -59,7 +59,6 @@ static int io_buffer_add_list(struct io_
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
-	smp_store_release(&bl->is_ready, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -691,13 +690,6 @@ void *io_pbuf_get_address(struct io_ring
 
 	if (!bl || !bl->is_mmap)
 		return NULL;
-	/*
-	 * Ensure the list is fully setup. Only strictly needed for RCU lookup
-	 * via mmap, and in that case only for the array indexed groups. For
-	 * the xarray lookups, it's either visible and ready, or not at all.
-	 */
-	if (!smp_load_acquire(&bl->is_ready))
-		return NULL;
 
 	return bl->buf_ring;
 }
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -29,8 +29,6 @@ struct io_buffer_list {
 	__u8 is_mapped;
 	/* ring mapped provided buffers, but mmap'ed by application */
 	__u8 is_mmap;
-	/* bl is visible from an RCU point of view for lookup */
-	__u8 is_ready;
 };
 
 struct io_buffer {


