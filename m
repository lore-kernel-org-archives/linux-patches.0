Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC3337A83C;
	Thu, 20 Aug 2026 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243885; cv=none; b=QOTrJhTUraM72rRqavpJxfnb4sj3qkOh5D5jrlFAicmRDs6wRUOz8Emv0lLuTF6C4VDz32/iy/T+uYxIzit/GFTv4D7B2wcxcvlt7CM55fNfVy2rq2B9IJnvPbRIDlk9i5vFLra0hJpZYd8WY7ReDVrbG5KZN+pWz+QUVnzCUak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243885; c=relaxed/simple;
	bh=TSiD3hb8c0LXSGFupOngT4EA+0Ba3xhP84YkegsENi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpBDeQtD/uoFzvyj6DNylBVqoMFbG5T9RAVVq+6iqTCQ+eTcfoQlSE17mm6MgusPfkYYzmHSTxWcZb56s9KMmb0LwdeTfNLBGpa4mLZGjYPyCMNxE7QihG50JMkenOEyOSImxpNWwANC2U0WAFXk914a9SY0A0w7YdMYi0O4rhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DuQ4Fpu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DuQ4Fpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12011F000E9;
	Thu, 20 Aug 2026 16:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243883;
	bh=cUjn3bfNTYRC7K7xZa7f/2eCMKte+mVKwcveLUWBwJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DuQ4FpuTe61Ieve8XBun/M5G3ZRwv3neubiolDmmjuGmz08xAAZdlNPxkEqWyeAF
	 gUQ6FJIV/gD5OZe89Zk7+VPT6OgR908gUjUh7PZaf7LD9b078NC6S135igWjWPMRdH
	 Llrfj2Ys7sIdPtAx553kC2wVKP6Y7XeyWmhlqgs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/272] openvswitch: use skb_ip_totlen in conntrack
Date: Thu, 20 Aug 2026 16:57:14 +0200
Message-ID: <20260820145239.123589479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit ec84c955a0d06cef31664bae328d94be7a3e2f03 ]

IPv4 GSO packets may get processed in ovs_skb_network_trim(),
and we need to use skb_ip_totlen() to get iph totlen.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8a7ed561671a ("net/sched: act_ct: fix sk_buff leak when the header checks reject a packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1275,7 +1275,7 @@ static int ovs_skb_network_trim(struct s
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		break;
 	case htons(ETH_P_IPV6):
 		len = sizeof(struct ipv6hdr)


