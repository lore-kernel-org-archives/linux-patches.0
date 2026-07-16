Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E65400982;
	Thu, 16 Jul 2026 14:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211552; cv=none; b=dfFuN/xrqLilsLLk/QjseqZP/EZaWsUDp4/NUBwvqzhXWosIS3TIO8V3KvOHWroEj9AnRlRwHw6rIfjbbg1iR/saeusQD4tJiVwBnlTsIynSq5OpATFOEMDHmG/0a61bMFJTEyKguZ587wC/Se2Wdx5+dvdvzmPU+CYy+yK8m7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211552; c=relaxed/simple;
	bh=6HPNZQrE2RB6YUPStfRqmJm1JIAbaJpFsvPr7+UIf/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsY3sAsaHLTvpZLTLs7f1+EWn/0zYrmCZ26D40W4+e+kpl4PrNGxTfQyGCCHwgusBioxVwY3pcikNXgDFQiQsoIsBqHFLvhi27iEpqwFlCfH8VufRYiFGbaA+3u2Ako5WBYY6EF8GR50KBlcezmsulQFkqkxzXq+eq2O+GHoTXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leM8Qk8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leM8Qk8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0F21F000E9;
	Thu, 16 Jul 2026 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211551;
	bh=I7OhbHKRZi0ZuPIF/nSN1RIHKFH1i/3dP78OekZwGy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leM8Qk8oHBj1xCnXwAVsLZZBOQwts6ZyYhcejQn649d95h/7xnx56w1c851bs02ha
	 HWBFiI6CvAph26Bmx1Ok4QO4HBgZ4M2JaOqR7odH7f9eFA83TSt2WMtJwH7iAJZVxG
	 Max6GOee4s/v0wf5dDkrESlcdEzG7cgJUrGyXkW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Berkant Koc <me@berkoc.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	stable@kernel.org
Subject: [PATCH 6.18 472/480] fuse-uring: Avoid use-after-free in fuse_uring_async_stop_queues
Date: Thu, 16 Jul 2026 15:33:39 +0200
Message-ID: <20260716133055.030560343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Bernd Schubert <bernd@bsbernd.com>

commit d351da75066955144515cb2f9aa959f24a04287a upstream.

fuse_uring_async_stop_queues() might run when the last reference
on ring->queue_refs was already dropped.

In order to avoid an early destruction a reference on struct fuse_conn
is now taken before starting fuse_uring_async_stop_queues() and that
reference is only released when that delayed work queue terminates.

Fixes: 4a9bfb9b6850 ("fuse: {io-uring} Handle teardown of ring entries")
Cc: stable@kernel.org # 6.14
Reported-by: Berkant Koc <me@berkoc.com>
Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -462,6 +462,7 @@ static void fuse_uring_async_stop_queues
 				      FUSE_URING_TEARDOWN_INTERVAL);
 	} else {
 		wake_up_all(&ring->stop_waitq);
+		fuse_conn_put(ring->chan->conn);
 	}
 }
 
@@ -482,6 +483,7 @@ void fuse_uring_stop_queues(struct fuse_
 	}
 
 	if (atomic_read(&ring->queue_refs) > 0) {
+		fuse_conn_get(ring->chan->conn);
 		ring->teardown_time = jiffies;
 		INIT_DELAYED_WORK(&ring->async_teardown_work,
 				  fuse_uring_async_stop_queues);


