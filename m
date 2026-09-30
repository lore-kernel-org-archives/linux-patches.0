Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022873BA246;
	Wed, 30 Sep 2026 19:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795475; cv=none; b=MbckXv10rzlc7fKqLkDx1VtSqH3kiGQD7ECR3pyD8zg8ECxFqnGmfodgNgb2YUeLslaKTZj24P+2oaUMRN2NUzgV53QLDVmnuq8lnShc8jiAuX2/eml5UM8vqXeQ6yuBNdvPw/fnQu/QiiyKIrN4LgYPAGzZPyoBPOOXcbcKzg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795475; c=relaxed/simple;
	bh=bntSvdGoUxXlsNLEtuSi1a7T7Z1/RGnNkKXAqOzpRTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7sYVMfYctEJ8/Yz3rXhrNAAqQb+D5voRTAHAHLOBH88kr+1YBK2YUnRw7AYf9gkcVlu6tCxyamkU5WlmmGiFLcmD0KvZYA3i8r1L3lHmAqzPOASd8hEze1uWId523O+iFYzQys1yhk3bWy27WWJIFSEHUTD2rihWkmEmBY/Rss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcYUQL6M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcYUQL6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED2F1F000FF;
	Wed, 30 Sep 2026 19:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795473;
	bh=sDQQwdfdrYdtsJN8st/244lDcUGkhNqR1Wx26WQs2js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcYUQL6M2i2CCCFgbZCLBs24s4ppToId+UaBFP5qU352PSAhLF8UwPp91AlptZTVG
	 I59Oq9pUMJlyFAUDgjBXEUKi97Eq/CJVINn17xEv+9DsVPULTn/jXRz5rDHj9+Bwsa
	 MqPn0lRBiEHZjAjaIcHj2tDdytxdvJq8Ishn6kJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0575/1193] ppp_synctty: ensure a writeable skb header
Date: Wed, 30 Sep 2026 17:20:59 +0200
Message-ID: <20260930152447.014974764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 02e1c5bd1892b..e18339dd84dd2 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -526,17 +526,9 @@ ppp_sync_txmunge(struct syncppp *ap, struct sk_buff *skb)
 
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



