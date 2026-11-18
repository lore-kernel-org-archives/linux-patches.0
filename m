Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041134;
	b=taWmxPUCSlY0IMraMSczfcEzvTd7O+AFBtICGuKkZUo1AmooV2X0kyx/6S/3lPYDIqbx
	 JXRUT3BbW9B1Ogimvk2+9VhzJbmZprZj2cDZQ0vE1kfnoy6gcReVQVFMVTgzVsU6JWXWg
	 mQg3cxWwCFH6Or4UJ1nn5MHrXvE225yXs7gtmipBSUcWkU7irkYqUL2aPlIulzhdkRu48
	 GG3AYLIUcE+bg1lOTUDZs9l0DSI4PkUV6tRwkthDLNXDhn5FAGLf1QVUvOl/9sgewY6mR
	 T8y7/98tlmGsyunO4LRTiA39SFr614S5sSJOyhCQBWXRK9beBufeaK4S5XCeSCpcLOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=V4VVB+qgcbFlsts+m64flxlpwttw3DdbmX9DYvXdtWM=;
	b=IwJqMvzvwSvy5L593U6e1kzmI21CsTElWbrn0hdjWoy0VtFCg023niKzMWRF3Fozqqlt
	 P+fJN8HV1B+//o7m4tif9bpjGIJgz4E8cnWpUKDPdYytNqHAKpTQOHrrAhqLJhnEdgyYP
	 Vq3wEPOUbKi5Pr7aUR1w0d9Yb/ExrCZyPCYMFc0dSnLaeJ3rKyh3rtT9LzRPGLjRLRv8i
	 Kv5ibglvdKm51upb49DzWyQrMEQM02ulJPLeTF1EMSxD0+rXZIMeqRY1cVEksG8iTvKtT
	 1BItEkZRpxtCvCtME87sGeGw35JMKO0LclmQUc1mG5JItuxsMoDmnRkTb6mG/WFhXPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Afd8Hg9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F1E606A32A;
	Wed, 18 Nov 2026 22:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Afd8Hg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52BB1F000C4;
	Wed, 18 Nov 2026 22:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041134;
	bh=V4VVB+qgcbFlsts+m64flxlpwttw3DdbmX9DYvXdtWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Afd8Hg9X+6I2/lAw5vZyNICvRpx7FRXwBIiargAI6icyTXd9tJGKMIIv1n0WCG/z
	 cNbYz/sdLoGZGhUTzu+1m+Nklhys9Rv8Dzlipc8OiHu5dJIoQTExF3d+I0CP6yVO8i
	 xBSSYAuwkAXPRCCMKsUfzaGgKcinvcS8+SBY4DOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2704/3318] xen/blkback: Prevent missed completion when draining I/O
Date: Wed, 18 Nov 2026 15:55:26 +0100
Message-ID: <20261118150442.024434376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c362f4ad80ab0..b8e75fb432ad0 100644
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



