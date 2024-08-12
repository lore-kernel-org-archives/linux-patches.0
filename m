Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366972C1A5;
	Mon, 12 Aug 2024 16:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480391; cv=none; b=F8zOKw36aUz0UOib2uGlLxbPSJ0eN0lohb7mv6vQgGAC5XIpokPtajOg+BzUY5Ym800LG/hSUzZQ3rnoi5P1e6bM+PBfovFQ8CSR9VjZ1pfdkWxUQK5IZ2XnUEDrUauvYVNyVAkXMfNsXeJ7D7fNk+ZxF+S8g0mYNSKbidRop5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480391; c=relaxed/simple;
	bh=4QxAmehziIIVN8Mb90Nk1iGS9J3cjyAfDjQMZITzbC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH38yHspyRihui8/7rVgaRiTzJeptJ2GwHa08tg0AW34ZPxptAfsVOpe/wYlzoBFJfG0vD0M1tIv/E2588hzNg5emaPY7Lsl3J37grRvpH9QyrjAoY+ImBLS27ol7QCYgkY5hRgChc8o96Yn5kXzbQAVZANzrYyKALcIPc65f5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7Afb82H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7Afb82H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9821BC32782;
	Mon, 12 Aug 2024 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480391;
	bh=4QxAmehziIIVN8Mb90Nk1iGS9J3cjyAfDjQMZITzbC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7Afb82HX1G6HDljxkKbUycPTw94Js/+5kGbI+VtZGr8vTAZqycxMMwfsCG4WB/mI
	 B3Wtr7REnO0u6EbTqehJVRkxggaCqFkoBUit0H5OF7D6ZA9kKG2nsOqIWNpjpKGts3
	 vyVXpNwFU9V4/j/olBga+/t9YC+/ayF4M1C7a+H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 180/263] io_uring/net: ensure expanded bundle send gets marked for cleanup
Date: Mon, 12 Aug 2024 18:03:01 +0200
Message-ID: <20240812160153.439300916@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 70ed519ed59da3a92c3acedeb84a30e5a66051ce upstream.

If the iovec inside the kmsg isn't already allocated AND one gets
expanded beyond the fixed size, then the request may not already have
been marked for cleanup. Ensure that it is.

Cc: stable@vger.kernel.org
Fixes: a05d1f625c7a ("io_uring/net: support bundles for send")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -613,6 +613,7 @@ retry_bundle:
 		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
 			kmsg->free_iov_nr = ret;
 			kmsg->free_iov = arg.iovs;
+			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 	}
 


