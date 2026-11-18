Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056082;
	b=EZ606zNB+lCKrZcUZVVWTtQ2hxYhGnMnlUx37d8MwbMh3QwX3Krenm7D+8JLTplNlL3U
	 rwVzqZ49BXrfLupVb6WCnmXcihJGf42iHaOGLUbW46d4dgAPWxM4Xe7tqpamCb2prBxD1
	 xSyszdrbsCISRf3FysjdeaZvp+KY1Etr40c3TfSGgipl/SujDqnhFaE74Z3MqhLp+sXiS
	 /muE6qbqOQkqcoYpem+9ntV/eDTFTzAsYnFkPh/bcIzOlpQmXwqAldcPa26NCQjZ1eBKs
	 y8Pg5nElporB4W9xXFYecnQbEqoDi2yAS/h3/ZA4S008DA93vdKCCFSX7A9o8eveTRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k1DAM3P5pg/9c4LpABCVx9dogqenICG2MnkoUy9dBf4=;
	b=Q4VYnQqG3WGNOzGRkwj2oZpKITT+3KDdTHHQdKou1XHmeGALYSNrdoezBRtieKZEfnVI
	 k4iID3Q0es/Y5XuHI4ySkmzw8f1p/pZlSI4d9tboA17VN78jFg9ytymBipcrFDot/1bm7
	 ubcobCAyOUKqh1hx1ck6PZ1yVMBYNGatE/c8Q/p/bz+IvqjYPZzFEiZZeKIf4zjuT2nDW
	 KfA0azetzZOri1O93kJYFx7h+1qnhkF+WoqOzmev8+JWRyg6cSuKmhQznr560P2pystV1
	 MF4N96Dd0vjMnjvacsJtQLTi0snGftAcbqkXcqqF1l/mjzeg9TwPOhDerb7VKIWequQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSMJeIBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913E7606A31C;
	Thu, 19 Nov 2026 02:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSMJeIBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E203E1F000C4;
	Thu, 19 Nov 2026 02:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056082;
	bh=k1DAM3P5pg/9c4LpABCVx9dogqenICG2MnkoUy9dBf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSMJeIBaulpVrz7k+7YTl0UGIyOcR+WBOmut2asj8LlP3RmjtHv+zn6z12DLyuPF6
	 JKywpXJ6a2K6HtkMBVZvhplC+rdnM4+XLO1FhDrMajxXFn9Js92rr2HqmanLBYjCxV
	 Qk/LYb8RxzQ2R0AdIS//eyzGZVWo9eRbwfZhF/Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1820/2214] xen/blkback: Prevent missed completion when draining I/O
Date: Wed, 18 Nov 2026 15:58:16 +0100
Message-ID: <20261118150124.268013888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 9b4df0baa2aa03d22310e59846ca628f7afd4115 ]

xen_blk_drain_io() sets drain before checking inflight.
xen_blkbk_unmap_and_respond_callback() decrements inflight with
atomic_dec_and_test() before checking drain.

The pre-wait condition check was added to avoid missing a completion, but
atomic_set() is unordered. With one I/O in flight, the drain path can set
drain to 1 and read inflight as 1 before the completion decrement. The
completion path then decrements inflight to 0 but can still read drain as
0. It skips complete(), so the drain path waits until the timeout despite
no I/O remaining.

Add a full barrier between setting drain and reading inflight.
atomic_dec_and_test() already provides full ordering on the completion
side.

Fixes: 6927d92091df ("xen/blkback: Fix two races in the handling of barrier requests.")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260730084000.3305702-1-hanguidong02@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkback/blkback.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 14e452896d04c..976896abb0da6 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1021,6 +1021,13 @@ static void xen_blk_drain_io(struct xen_blkif_ring *ring)
 	struct xen_blkif *blkif = ring->blkif;
 
 	atomic_set(&blkif->drain, 1);
+	/*
+	 * Publish drain before checking inflight. Otherwise,
+	 * xen_blkbk_unmap_and_respond_callback() can decrement inflight with
+	 * atomic_dec_and_test() and still see drain == 0 after this path saw
+	 * inflight > 0, missing the completion.
+	 */
+	smp_mb();
 	do {
 		if (atomic_read(&ring->inflight) == 0)
 			break;
-- 
2.53.0



