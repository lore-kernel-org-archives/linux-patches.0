Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093101A9F83;
	Sat, 12 Sep 2026 11:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212883; cv=none; b=G782Nx9dhm3o0sZdYZkYrn7JfMaYgitF5ENSqJlOV7KlRPPccCy7Qc5A39UqWg1NXwbLLdzh76edQGTcuU0KgOmkuZ+dT48XFOOulz1al6yIcNvu0rPyyRuMR2JJNeLlwhXphmfeyhCQVr/Zq+4yYHO9IAXlTmGtebyVs6pT+CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212883; c=relaxed/simple;
	bh=SZMavDb/Dk6J0TlAY6hyZs+QUiVlb2Ey0TCrOMbQLR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Odmqgne1ayWMezlzoI6hafGRg8kxCnsMUiJV2fS+aAk7Y3qqh6Mv2zdY7HKqn83pLVeDri/6fFqtfXqx93nSSgNHPudngwKqNAufn+QIHtxBJd3Zbf4RVNftAhEfqO6I6rIeZwqyxZmAWPb3nfDCjA81mbmDPcMSxlh9E8SlJK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRrS8ihZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRrS8ihZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2EB1F00893;
	Sat, 12 Sep 2026 11:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212881;
	bh=yATWPh5yjFjOCBEDGxs+Ube8fBfykRsKLhLtJ/xKtYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRrS8ihZJ1DhkrI3NJ0FPi7Z3ukElMyQ89e6nFyOB/vmsjoUihPQJyjxpAWC/Y10+
	 k1aMin8jku2op8h3/G3UV76XYzjn04gmV3m2ew4lZA+/zj7CNSIc2Rmvs8HGPCQqzY
	 ZGFDpQzEzx5Eqd86GKHEVkO7uIFmDFuXq4qCr1qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Norbert Szetei <norbert@doyensec.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0001/1376] net: skbuff: dont skb_tx_error() the source skb in skb_zerocopy()
Date: Sat, 12 Sep 2026 08:40:27 +0200
Message-ID: <20260912065607.576800157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 8ece906150128d5ec2462aabcc978c568433eca4 ]

skb_zerocopy() copies frags from @from into @to. On an
skb_orphan_frags() failure it calls skb_tx_error(@from), a destructive
operation on the source skb the copy helper does not own. That completes
@from's zerocopy uarg and clears SKBFL_ALL_ZEROCOPY, including the
SKBFL_SHARED_FRAG page-ownership marker.

Both callers already report the failure on their own drop path.
nfnetlink_queue does it at nla_put_failure, and Open vSwitch does it in
the flow-miss drop arm of ovs_dp_process_packet(), so nothing is lost by
dropping it here.

On Open vSwitch's OVS_ACTION_ATTR_USERSPACE path the skb is not freed on
this error: do_execute_actions() ignores output_userspace()'s return
value and, unless the upcall was the last action, keeps forwarding the
same skb through the flow's remaining actions. The uarg is completed
while that skb is still in flight, telling the producer its buffers are
free, and SKBFL_SHARED_FRAG is cleared on an skb the rest of the stack
still handles. That flag is what makes esp_input() call skb_cow_data()
instead of decrypting in place, so a later local ESP delivery can
decrypt over frags the skb does not own privately.

Leave error reporting to the callers.

Fixes: 36d5fe6a0007 ("core, nfqueue, openvswitch: Orphan frags in skb_zerocopy and handle errors")
Cc: stable@vger.kernel.org
Suggested-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/6E3A780D-FB87-421F-9964-B1D457D7D106@doyensec.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ 7.2 and earlier do not have the put_page() call on the error path ]
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a3d329b2ccfd0..ca861bd6db148 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3847,10 +3847,9 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 
 	skb_len_add(to, len + plen);
 
-	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC))) {
-		skb_tx_error(from);
+	if (unlikely(skb_orphan_frags(from, GFP_ATOMIC)))
 		return -ENOMEM;
-	}
+
 	skb_zerocopy_clone(to, from, GFP_ATOMIC);
 
 	for (i = 0; i < skb_shinfo(from)->nr_frags; i++) {
-- 
2.53.0



