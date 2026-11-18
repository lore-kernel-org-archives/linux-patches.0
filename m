Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026000;
	b=fy4cPgGDcrmhJdqiMSpBov83+wGULGSJUT07zIQfXEDL96pgOiDr2Vu8WiEBfgNnox5c
	 n8cTH0RzXfH4riumZ14nWgq8fonKYC83nqn6BdLyzBujWD5hHmqaNSILbYMWMPPxXb2wN
	 qvg5ShTw27l2yWyz8bV0PErLA8Nh6AmOvULfUx9FVFtOiOsGdF7vg8Hb0rAg2eCOV9yQv
	 J9u/im5GmW/XNpaxjkatrntOqxnHwjXOpWglbGGhkyST+o31L4BzWigkzPonDoEquFgQq
	 QBD4vaNF84S9y6n/m8ybbOQwOBk+CkSlUJcWiYjCeJ6FjOG1wnrTFVyDJpWWtlKOkxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xhu2KUeh8+1bWyGxRA44PerT2SWjGVKMhg4aWVITX3g=;
	b=YV5ItpDvho4f+Fk9kFtnEAuhKEDaSv2iqtpWBnaG+TbbdBrcGIQaPuzMeJHrWJ5uedQk
	 bV1bAm+CuNz0Gr7CfEvhs34OoPsTg1Gt89Ipk7lYomOyKl/yEO6WHZAuXb21/eY6bOAI3
	 arEPYZpHAWDEtd9fYymgRtIpZY9Awe4Rv/zkLnjMwqgEpy6JH9PXYyqShEDk2zqRWjxuR
	 IBr3/DGzkTntA44spsni1FAfLIKxjYZJwZyPlOVyw8koqxnt416hksP/WYMbDX9B42Bvv
	 9u8WSLM0Wr+L5tSC3AJ14toD5ET67PQi3vbcoafyqFCnQ05GYraC5gLI6NcswMOcNRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXxBFRln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B526606A31C;
	Wed, 18 Nov 2026 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PXxBFRln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD321F000C4;
	Wed, 18 Nov 2026 18:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026000;
	bh=xhu2KUeh8+1bWyGxRA44PerT2SWjGVKMhg4aWVITX3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXxBFRlnPANQ64ZuY2hu4uBG/UbXRgdScb0UutH5gwXlIw5c+f0NRmHkz1nSkJLdE
	 Y4cPQs5qiQQ28Os48nSSIVbgT1oP2wA0vrY1CD4OL1Jna0lirwhMJnOwthaO7zF1Fu
	 f5NHUOScpvi7eTSJZz21s9fOcsF4zbfucInmTRhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1278/2151] xen/blkback: Prevent missed completion when draining I/O
Date: Wed, 18 Nov 2026 15:50:13 +0100
Message-ID: <20261118150208.677562777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a7c2b04ab943d..f9391b2d47347 100644
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



