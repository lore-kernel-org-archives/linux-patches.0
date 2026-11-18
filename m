Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031326;
	b=JoFD3xjbBbGs+p4eDxh/QWyFbAvcBDzUyL9GsrKwpjkZ0qH7c2Y0wh2PcnivgZ8l3xJq
	 x+vbnpiD7Gq4YV8GhFMhK/DTHbqOQqApgLn+FXj/vVQL1YXV4KsKfKC9SdxYzXJe4Ac0t
	 0Rj1hQj/4xaMNnyloUxCa5wa1W1Q6EBFZmQZSdQ+Jxrj9y+6pTXw2nwMiFI5bcfKPhG+m
	 LqnmFlVP3uFXhzg/G3MHYEClM2BJkI0jnxjr152UcULO6NeuiVOLpUXnSTXnDayDcZmke
	 5pZn+u7Or4UqCTQeh77zCPaH5En7HeVSPk4GP30clgD+u1uimcR2eUCCrT+luq1plWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dpr7CPor27IUdeO+CT2vRL/HwcedsrXoCQBZjDyb1sY=;
	b=A07mr9tr5NMWhz4s/rSDI2OhHqV5Pb0gNhq4coc6/y/aR29HzXplCZaYSLei5CCZ/Y7I
	 plG1RpXWWLTK/qPNY84tsNgyhWfyBwqna1bImBR+XyOmaQh7JJz80Et7p2DzuzWDPtxRm
	 G4PUo/7OmIq0fXx4h+SZFsnlsF8d4GlsaxHaGwGRC8kB3LOmhFjKJAOFIyy8dLsIINzIb
	 UnW23i4h8SCgebgpI2CKrP/EZ4j2AeeYyGE+Ad47+wEvHhZl9yrKiSl7ryVNhEdiOVqVK
	 pLQG4+LrgK6FJFfOEOVum5bHjl40zggBf8iXWEa3YVQJ0S89v21DyYpwB7cBMWuwTxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNgOLw5C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9E1606A32A;
	Wed, 18 Nov 2026 19:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNgOLw5C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1991F000C5;
	Wed, 18 Nov 2026 19:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031326;
	bh=dpr7CPor27IUdeO+CT2vRL/HwcedsrXoCQBZjDyb1sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNgOLw5CUXXcqswyurGjfQAc4ObIpDMWPHVBYwlVJ601DqHF1ROUWTmxHRG5h+KZL
	 Fz2A6IK4zXZt2q1FIo+0Eh3s86zcUP7ie1BoZcnPgy6pMfNpkbNoVwvPEacLyTLCC+
	 SMsLiiTUd2yCpmRgTis/AuMhNV7MjEfNJf3I8PqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1012/1756] xen/blkback: Prevent missed completion when draining I/O
Date: Wed, 18 Nov 2026 15:52:19 +0100
Message-ID: <20261118150050.425486707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 838064593f62b..248cc5fcbed5e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1022,6 +1022,13 @@ static void xen_blk_drain_io(struct xen_blkif_ring *ring)
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



