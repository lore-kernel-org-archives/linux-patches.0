Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F496EB72;
	Mon,  8 Apr 2024 13:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583672; cv=none; b=G6nTsDyD2nDMn7rE7+BtZqy0uOHOSmBCAE5V99NghK/rAEZtVwNi1gjbjtszpmS0WgNS0VFV7yYCdX9SmvxxWur+eBCvqeiEle2QPtsmD6qqwUrF/cUYNDvaqBK8FFP4dvbmlzSatW4h/bmL3/psLwKh9zRFwUUj31Z/uHIzyXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583672; c=relaxed/simple;
	bh=pcu65RC9iHNzrg8wBRadJso/2GvDtQRmPYjJppy5eZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJwpyJU1bw9OKBxB3pDcUogawzg4a3bOlz8HfmboL841wp+XFba7eTcoMdoj94bLaGmQ3Rpqe3uX73ME6wO7lpORryqn/KUEchCAmKNUPoKoYPRTw67qoBKJVHlIDtTET469PMGpLJFeWm7jFrENmoNHcxzTLDDP/JOPqUu3+54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKHbKgUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKHbKgUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB80C433C7;
	Mon,  8 Apr 2024 13:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583672;
	bh=pcu65RC9iHNzrg8wBRadJso/2GvDtQRmPYjJppy5eZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKHbKgUhES2a8bBiJhxaVY2IrEksVvsRyJKxPxBwk4YiDyOQYje2Ou8DhkU2aLBRH
	 Q7O9vryHblD7EB7J32vgvwsvATUAXVQU2IYDqQHeCOZDWDGCHeBOXt3esjqxsMPzig
	 aqtdcaqCbZla465BNsNf1SiQew9T1VuOeU3+dpnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.8 207/273] io_uring/kbuf: get rid of bl->is_ready
Date: Mon,  8 Apr 2024 14:58:02 +0200
Message-ID: <20240408125315.776192625@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -61,7 +61,6 @@ static int io_buffer_add_list(struct io_
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
-	smp_store_release(&bl->is_ready, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -730,13 +729,6 @@ void *io_pbuf_get_address(struct io_ring
 
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


