Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD331E823;
	Sat, 12 Sep 2026 19:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241722; cv=none; b=hdAhYGWyeRpT8JUM6BsL5c9NNoCWrgVUsqHi/1gcPLJVNlarlWt0AGmHkNTEE0abZfS4MzwCrXeJ1IJQys00J6bWco13+C36DrMNOHm6xs6VKHsu+fOIAsSMVYyrrNwmtm4QC2ycraLg8cVAL6Q31yTBOvnHuW4fyaFHYOr9aUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241722; c=relaxed/simple;
	bh=PcHzyygwPv1/eH3Nybb9f8iZH13yPB13F5kUU28Z7eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVbGvDIOt3mn7ORc1sSGl+4W7d7dSvlpznt1Y8ubPFmHu5oGEy/d9n/x+FvO8J2+8x2K9sTk+0esIxXMeColYuGsPm5bgGCFh3G8EGs2N459BeXD4kGEjZpITRyCLUYOcV3wD9EK3vfJRzugrcLtfzkwQAKKgdfeNYPTdA4mW0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNtFIYTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNtFIYTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091CB1F000FF;
	Sat, 12 Sep 2026 19:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241720;
	bh=kOobrLjXynoSxFm7TiIgI2YF4p+TKcDCRqs4ZiyyM2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNtFIYTy0vORLvrjnya+0TIYScndbaiD4kGyB1xXCjt/3YfafiG8zs/wK/IwS47sX
	 S+b8LBTb/ARdMxKn/dFW8ZNmCaIFomnmSB8pBl4QZU8KG+RIiRxpu1gCrevW6kI4aD
	 ifp2QFaDJUCMmrxqpEevORkFs0d837Iw7gMN53yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Norbert Szetei <norbert@doyensec.com>,
	Jongmin Jang <payload.jang@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/798] net: skbuff: dont touch shared zerocopy state in skb_tx_error()
Date: Sat, 12 Sep 2026 08:57:00 +0200
Message-ID: <20260912065521.460584882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit f66bdb1cc0fcd227a062378f8be0b5873aa5600a ]

skb_tx_error() completes the zerocopy uarg and clears
SKBFL_ALL_ZEROCOPY, and skb_zcopy_downgrade_managed() clears
SKBFL_MANAGED_FRAG_REFS. Both live in skb_shinfo(), which every clone
shares, while the caller only owns the reference it is about to drop.
Through a clone it tells the producer its pages are free and drops
SKBFL_SHARED_FRAG for an skb that is still in flight.

Open vSwitch reaches this with a non-last OVS_ACTION_ATTR_RECIRC:
clone_execute() sends a skb_clone() into ovs_dp_process_packet() while
do_execute_actions() keeps forwarding the original, and skb_clone()
does not privatise the frags here -- skb_orphan_frags() returns early
on SKBFL_DONT_ORPHAN. A flow miss on the clone then strips the marker
from the packet still being forwarded, and a later local ESP delivery
decrypts in place over frags it does not own privately.

Skip it for a cloned skb. Nothing is lost: skb_release_data() clears
the zerocopy state once the last reference to the shared data goes.

Fixes: 25121173f7b1 ("skb: api to report errors for zero copy skbs")
Cc: stable@vger.kernel.org
Suggested-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Tested-by: Jongmin Jang <payload.jang@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/CFAB292A-674B-4C14-BB2C-BB8830AD5659@doyensec.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ There was no 'if' on 5.x as there is no skb_zcopy_downgrade_managed(). ]
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 793b58979e5ca..9d7ebb9216773 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -825,10 +825,14 @@ EXPORT_SYMBOL(skb_dump);
  *
  *	Report xmit error if a device callback is tracking this skb.
  *	skb must be freed afterwards.
+ *
+ *	Does nothing for a cloned skb: the zerocopy state lives in
+ *	skb_shinfo(), which the clones share.
  */
 void skb_tx_error(struct sk_buff *skb)
 {
-	skb_zcopy_clear(skb, true);
+	if (skb && !skb_cloned(skb))
+		skb_zcopy_clear(skb, true);
 }
 EXPORT_SYMBOL(skb_tx_error);
 
-- 
2.53.0



