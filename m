Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089964F4051;
	Wed, 30 Sep 2026 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791569; cv=none; b=q0GyjsDnM4+Ki41XSTbUiJO1M3w+U3fuwtSRodMh6vbHEl04JD8jiGEoOOMrm1o4laVCnXVMv/cKsXcSD6UPlyGZ+qrTK0AssP32xVIS+zYcx9VFjuxtKdYPeH73cLWRPYxaIHgOywFPJBrzWMyRBK5/qZvl4dgAdtUUzloo0uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791569; c=relaxed/simple;
	bh=8f/ttPbqYv92JzLym/CJY+ab058/LwCNNRCsL5PLTwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGJNetNWBZZgrb07GdbTdRpxrYabF8Ss7agpHOoNCxYGlRjR4kUz83ci+YMn7Yeg/wsqzhhQM5pKg5fsn7nbw9HtlbWk2DXwwpf2H3p5dpI5KAZMGtDAIzQdcSURp/0hT+WHfFEoUiFeZ3gsvd1UGejhqCZrfLIm/FBa88TbhG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJxQyPPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJxQyPPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E291F000FF;
	Wed, 30 Sep 2026 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791567;
	bh=yZod8MEOxWqfZOGhbRBTY/jdRDFB8esIn+jr2QYAAuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJxQyPPQo3k23VyRshvECVIDpBKzb9WedwHZ7CZmVcqTzH8HPc47D6W5LVaug8xYq
	 C/ssvJW4B0XcQ/P622M4dSPFw5b8BiN7kcOhau1vbBFMVq+jiPWTlFUEjeLWTlYL+x
	 Ou658+0wMr4y/ihtLwmWDCm36aRxyV2RxNRXDeOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 347/752] ppp_synctty: ensure a writeable skb header
Date: Wed, 30 Sep 2026 17:23:37 +0200
Message-ID: <20260930152405.799108974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 8aaeb56aff2a557a88f83ae866da2c91ad247e59 ]

ppp_sync_txmunge() checks headroom before prepending the address and
control bytes, but does not ensure that the skb header is writable.
A received skb can reach this function through PPP channel bridging
without passing through ppp_start_xmit(), which calls skb_cow_head().

For example, a PPPoE frame may share its buffer with a clone queued to
an AF_PACKET socket. If it is bridged to a synchronous tty channel, the
address/control bytes can overwrite data still visible to that socket.

Use skb_cow_head() to ensure both sufficient headroom and a writable
header.

Fixes: 4cf476ced45d ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260908072135.877364-1-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_synctty.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 480cafcaa964a..876fc17f107f1 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -536,17 +536,9 @@ ppp_sync_txmunge(struct syncppp *ap, struct sk_buff *skb)
 
 	/* prepend address/control fields if necessary */
 	if ((ap->flags & SC_COMP_AC) == 0 || islcp) {
-		if (skb_headroom(skb) < 2) {
-			struct sk_buff *npkt = dev_alloc_skb(skb->len + 2);
-			if (npkt == NULL) {
-				kfree_skb(skb);
-				return NULL;
-			}
-			skb_reserve(npkt,2);
-			skb_copy_from_linear_data(skb,
-				      skb_put(npkt, skb->len), skb->len);
-			consume_skb(skb);
-			skb = npkt;
+		if (skb_cow_head(skb, 2)) {
+			kfree_skb(skb);
+			return NULL;
 		}
 		skb_push(skb,2);
 		skb->data[0] = PPP_ALLSTATIONS;
-- 
2.53.0



