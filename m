Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E003D890D;
	Wed, 30 Sep 2026 16:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785365; cv=none; b=EF0fJ3tsEANPjBiA5UxOlZlalgm24l6azZGkqjn1/ZfF13lVQ52hnFuFETcEr+JfbfNlj2rXm8SOFKJOVXTU/LWgPs++3iWuUIIOq2YqjA5WWl1cMFqnk92E8VoMHbTQZFjTPIl895+YRf9Sdaz0FAJY8ylauRJ7+JofucssRzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785365; c=relaxed/simple;
	bh=cJL+TuGVJI1nYFGpOrZbWSL9bbbrQy25Q4r+XQiijnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+dLmh0wraqXnHemwGanpP7c1Pn1E4TyaWnM+Apiuob54wB+jiI2q4HrYtkWg0aQF3PQfUrpIMiKAF0YKyjuzoHKv8rkAYOGkVPDXK31chmdUCGjyQ1yNaZbhmvxVZWL4tgchXq45vsWxzHJfLkybp/+cjG8k6hkalYLza9xVn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnX7WDRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnX7WDRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5EE1F00899;
	Wed, 30 Sep 2026 16:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785353;
	bh=pL/c9yEH4vRdp3EeGK56hrgubPxezxAT3gaInVSLdCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnX7WDRvKinHOul0BZIIUD0ZAOzpuSZpXk390/AZhNt6col9PyTFwZaOb53irYeVo
	 ZIrz82yBv32etVvSOm5eDrepEGSXbkLHyE2cfDlwC4z+Gm7rGwtisvhGfUEKjMao29
	 eTXSn7AgTmbFIgADfp26/UKGKOrPrAr68+tMpzKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 478/982] ppp_synctty: ensure a writeable skb header
Date: Wed, 30 Sep 2026 17:20:14 +0200
Message-ID: <20260930152427.048509615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fb533c43deeea..1ee9143b5f9c7 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -535,17 +535,9 @@ ppp_sync_txmunge(struct syncppp *ap, struct sk_buff *skb)
 
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



