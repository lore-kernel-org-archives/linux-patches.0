Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049386;
	b=ARnBPt8x54YoQ6jiKDijz2oHna4Nzxc5qyYzQ0F/8y6z6nACAGmuR8U7/WqGEHa4jofo
	 MLb7EJn4r0adWrxVjXR1pRs+ovmz2zO/u0mtntp4cUjaDRrWPxLvPHVSWw6mkAGzv6BQr
	 ZlOpsbegyOkHubqrqS2i89V5XBbG7tzXrDPL3BpAguFUVsG7kzZIJVuKSmlQZYazUnq5E
	 qLT5yUfiGMensBsXqkFQ/HQIJ6pat5eG2PNyvf1byl+yO9kU9lPItnA+SKlg7LoBYIlX5
	 ip2x0+frUgVEKP0SEUQoPeIeDJsF9Awegu/KV0BdufP512qgPCNv7zZ0DDqxCbdyLDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9hbkyKKzNVGjVK7z3db0TusULkXoIsMXAhdPRkuJhIs=;
	b=CunwG6YGGL0pldZa1um4DC/ijDHKl8ZoaWi/wJ1meK5QiLaxC0stGSUkP+ZNfyN2TF+T
	 5Soz1clsyxRe7311KMIaTFvoboFY2Hqy3XVyVMv7k7/1hRAE85GZ7BhYOSLt5vb0wGFHj
	 5GEmHUuiUqi5NAg7PU1Axnc21ulFJ6SRzPYYSqi0/vOSpxnurZVZTcTHyJ/qczPaXpCnI
	 FmxBt7k/iRK/UntNu3tbLUytuPjp/vm85gg7VlaTq5jUXVY/ODg+F2z0Ypsh4rSeYKP33
	 v2Jt9zx+E5UjKn0wMOAasRo/zenPJ/6ArmOlH+aCS1dASFjpJvdnmmbPmYKdT64E1tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="war/R9ED";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDD9606A31C;
	Thu, 19 Nov 2026 00:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=war/R9ED
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56551F000C4;
	Thu, 19 Nov 2026 00:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049386;
	bh=9hbkyKKzNVGjVK7z3db0TusULkXoIsMXAhdPRkuJhIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=war/R9EDD4W7oVYy+PIVExsSnGVmf5dhGMsOJ4hX9WsVLFCMv+pvl2kR6FsRc6js8
	 CtzhwxCUyOy5JbDrXwSjJw9GD7I28nD6XV2qYp++SL1JBVH87l/KkKamLs7ES2xo7Y
	 HgZNH3Z6BuA2UnsBXWW+JnJVkjKsEnIA3C6j60Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2334/2857] xen/blkback: Prevent missed completion when draining I/O
Date: Wed, 18 Nov 2026 15:56:08 +0100
Message-ID: <20261118150325.572952475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a5cf7f1e871c7..09e7ac660b8ab 100644
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



