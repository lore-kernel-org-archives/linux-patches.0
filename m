Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453D6328610;
	Tue, 16 Jun 2026 17:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629457; cv=none; b=huwsgLzPpM8Dq/xsltr4TFKXZSBTBcdtiNZACdWAbhzleQoghoB18uUdBXDW4sRjGEfq3+BWINpxuUyaQEKfAk9JcVl+XJ7mVti4ic1W+Tu8k/hJO6LAiyJuRgLzMaICCJtVdXdZxxaI3/1C8l3ZW/KqK6mr+GwVIBhv1hJnJ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629457; c=relaxed/simple;
	bh=aBcrkcrI50LjRJ9hDBNzW7s2q/xeA8d3bOvXNJbkzvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/D0583q0V8MTRtiLZUnGF04ffmcipFCH54lF0Kg0n5wvaRjbiBmUN34TK3lLX0xxd0rbmzamUpx9KnmBqwlz179Rj2sFV3vgecyzAUHMlfNWObHOS7nYJ9GKlgeHxL73nwVaW7MzJBzsOCx2fbCuW77dPGJ6dbBvXLKBAKCUG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mj3arHWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mj3arHWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DF61F000E9;
	Tue, 16 Jun 2026 17:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629456;
	bh=8W5MS2Dx2DPQvUUa1Y24OY1k4krIs/RlIece/AYY8xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mj3arHWr75VFMf7MytjQiiMIRokv4lmCKvefI+amTyqC7GyOKs3szBXeT65H6MV0o
	 QdfdOlc7F56UDii08WkB6gXh/BqMIJIrJihRbhjt577MP13E4JgsZU5sgLmhiSrrvP
	 icYZ+QcvofqiNg5z9zT5KFZuSoJRAX+0Xk0gTc5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/452] tap: free page on error paths in tap_get_user_xdp()
Date: Tue, 16 Jun 2026 20:28:02 +0530
Message-ID: <20260616145131.035960839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 3bcf7aec6a9d16438f2cec29f5d7c8d5b8edf9b2 ]

tap_get_user_xdp() rejects a frame shorter than ETH_HLEN with -EINVAL,
and returns -ENOMEM when build_skb() fails. Both paths jump to the err
label without freeing the page that vhost_net_build_xdp() allocated for
the frame. tap_sendmsg() discards the per-buffer return value and always
returns 0, so vhost_tx_batch() takes the success path and never frees
the page; each rejected frame in a batch leaks one page-frag chunk.

Free the page on both error paths, before the skb is built. This is the
tap counterpart of the same leak in tun_xdp_one().

Fixes: 0efac27791ee ("tap: accept an array of XDP buffs through sendmsg()")
Fixes: ed7f2afdd0e0 ("tap: add missing verification for short frame")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260521163230.1478627-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit 3bcf7aec6a9d16438f2cec29f5d7c8d5b8edf9b2)
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 2c4f9d19827f38..5f01c875e49ee4 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1178,6 +1178,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	int err, depth;
 
 	if (unlikely(xdp->data_end - xdp->data < ETH_HLEN)) {
+		put_page(virt_to_head_page(xdp->data));
 		err = -EINVAL;
 		goto err;
 	}
@@ -1187,6 +1188,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
+		put_page(virt_to_head_page(xdp->data));
 		err = -ENOMEM;
 		goto err;
 	}
-- 
2.53.0



