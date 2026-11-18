Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019287;
	b=irjUV5aP7H+Mad3w+7ooX6csgSeF8oF7EhLv/sIjmp9UOHgytwOolomRjHm0EoBVmXQT
	 lRfrKmFMUoHM6+7Zek767hy5el3kPieiwn0pubQoEZ3Hxc8/2dXjB6WmMrMgvesv2bsyg
	 RuQsP7591xwRLYqsPq87EJS1SKKWj7yJCAUWGDhWTxLLPum9uucr07ePAkVkCB+oW4NJ3
	 9KT/pdszWiqRLZrGAeWhvc4HwrB3Rk4moo6vN4NnSoC3m55+6PsDFLa3rKjB6YrHiCTbC
	 vPn8KehAjK7M63zQSnvHGwVuuhT5jTaRo/dxvpTDVgcCHRUPwyISJZhAcAiCtericXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0l3yCvU0L2djXpPWOzSuDrLSIfykI1k41J0LjqvRxpw=;
	b=BFMAVEaFEWlOqKy/06Tc6pUisKkWek/hfoXML7aLnFjAEhXTC1WwLwR/26AUlyKaJQop
	 hnzNn1OZkdyycq6i2HqTvQxJQR4issDFPT0M1XjLXjicq3Zd+vtIEUphSPU3kBfH0uEQO
	 MMEPUaOpVR4R0bwMBkIr8s7YypMe8MRNAMTmxKimZpxUXAKFC0n7wXV5c1NY3Yd9gEKV9
	 BEydS368HWiN2O5Tp232IQBflhCJLggGoeYsreqYv3Nh68PXSYtbgjF2ZZZZFB+GgpJeO
	 efR1Qi59BNg9oE/bYd+nRYIBW+RYiZs6QamWVajtG98fEp5wD2LwdZU2pwsby4gTn/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kef44APM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D228060A260D;
	Wed, 18 Nov 2026 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kef44APM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342AF1F000C5;
	Wed, 18 Nov 2026 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019287;
	bh=0l3yCvU0L2djXpPWOzSuDrLSIfykI1k41J0LjqvRxpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kef44APMvR4OUo1eOzN60VSzMHWX3ijo2gtqbFKSCYb8DqVvqL/VQAbEy1eQBZfr+
	 KrF+vECNXE2FmXPB/hwYy/WSbVIjx1PrV0EFK6UfoxNY9t0dPIbOAPPnIebd3A73HE
	 ClUsYePs6Pz75MBAwGPxpsUU3yXJ6ajTh44Q2cUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1543/2651] xen/blkback: Prevent missed completion when draining I/O
Date: Wed, 18 Nov 2026 15:46:23 +0100
Message-ID: <20261118150343.518652245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7871099bc0d44..88526e349ce1b 100644
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



