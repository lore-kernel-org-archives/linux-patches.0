Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3502F1EABC3;
	Tue, 15 Oct 2024 11:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992486; cv=none; b=XQExs5peh+SZqEEhfmOp/Mtf5po0KJcMdEUb+Oyj9LrElNcsBqX0P9oYNCwJ1nZBkRRQrWdDjlbrgSMUTrlTIeCE8rBEi4vDnO2JfSBS6KH20vrFq/srBj7jOd7yybbWLIJb3LyxoK0XKidRc4zxDblqLavvVErQnQKCEr740AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992486; c=relaxed/simple;
	bh=NQZjipq9waB/FQoJCJTumu80oH+djOV8/LNBUdEQKL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHomsFuGJzRdjkkEe98QKU4vByeQMalLtgygijzjiJNwfJXdIKhUb6kahGlD5GxujcGjQ9l8S1myJ5lGjOufyl7DorfnU+CJ6t/ztjX+srx5An6J9chflMzg5s0Io2ZfmyO7y38BLR+lm40s52CPs5OzyBrROUUh2IU4gxsA0YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yh4jHEIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh4jHEIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987C7C4CED3;
	Tue, 15 Oct 2024 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992486;
	bh=NQZjipq9waB/FQoJCJTumu80oH+djOV8/LNBUdEQKL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yh4jHEIC3PPZqmJPAUxHgTbO17roHQKtF4FTuuf5iOPOwew8jxxAab+IoeHE/JAot
	 R9uEpI7zX7eN3crY7jjdcuzYvDh+d2w9wLmX164ghKvXEjxsIDxCKmxRu28vr9Tw1D
	 bTiBKEZnkd7TW7Td7HiJLyQzBRrJBLt8rpn7uyiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/691] bareudp: Pull inner IP header on xmit.
Date: Tue, 15 Oct 2024 13:21:17 +0200
Message-ID: <20241015112445.475908551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit c471236b2359e6b27388475dd04fff0a5e2bf922 ]

Both bareudp_xmit_skb() and bareudp6_xmit_skb() read their skb's inner
IP header to get its ECN value (with ip_tunnel_ecn_encap()). Therefore
we need to ensure that the inner IP header is part of the skb's linear
data.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/267328222f0a11519c6de04c640a4f87a38ea9ed.1726046181.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 3fcd3b84a066e..bec8a2c8656c0 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -312,6 +312,9 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be32 saddr;
 	int err;
 
+	if (!skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
+		return -EINVAL;
+
 	if (!sock)
 		return -ESHUTDOWN;
 
@@ -375,6 +378,9 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
+		return -EINVAL;
+
 	if (!sock)
 		return -ESHUTDOWN;
 
-- 
2.43.0



