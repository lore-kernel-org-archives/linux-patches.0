Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06236478E42;
	Tue, 16 Jun 2026 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628046; cv=none; b=NcrmJJlVxe8cuZBpycf3hb4iXQinCQs06QRtVOuVG38txVOF5BbiLDtbSQJRiTfDZ0pCjPRIhlGihCa1Bs37HbX5Nm1fvCLFc/Qd7JROY2NoOMQHV2MjDkgHDZq1n2cRR0j2RJx1X1hxBhqVafVA0Agpq+CWwLv2YVwajtBeTNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628046; c=relaxed/simple;
	bh=HPtCm2RoXxMzIGDjIw4Wf5oDEVP9HNkbnL2n1RG43IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fe2m/HWgQGldZ1zgVV8kr+wGhgneoCMAP9jqIVKG6RPq32tM2jn9wej/mLr0p/TRxxSwSDbYWjnp2drN2Zci2UTq/7Bcp93eb1nT5hiLy76apH9e1luN9CpEa/IU9RcSWynrJt8IpNLSvji+WHZnOgZOiFq6y4QhS4Wm8+cTqR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDjJWBLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDjJWBLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B5A1F000E9;
	Tue, 16 Jun 2026 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628044;
	bh=pUj2cR1ZT6kd7sYlj4Qmp7+74HAWt2dgYjDJcnOcvLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDjJWBLcegCYObpvtozDy1D85T/z46KFwMVBMI2h8obVgUBdUFHYoASzhiI1EE5bU
	 +wm8Usfnuf8T1nS+kvLwo4+J7M9IY0ibvtCI85+G8x9M1pCGSTJ5OcL7NCGwV+DO1U
	 NibuaqRzcc8uUSgamPY3zRBBbMhdZ6x1Dgex1OIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/452] net: netlink: fix sending unassigned nsid after assigned one
Date: Tue, 16 Jun 2026 20:24:08 +0530
Message-ID: <20260616145118.932497691@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 70f8592ee90585272018a725054b6eb2ab7e99ca ]

If the current skb is not shared, it is re-used directly for all the
sockets subscribed to the notification.  If we have remote all-nsid
socket receiving a message first, then the 'nsid_is_set' will be
set to 'true'.  If the nsid is NOT_ASSIGNED for the next socket in
the list, the 'nsid_is_set' will remain 'true' and the negative value
is be delivered to the user space.  All subsequent nsid values will be
delivered as well, since there is no code path that sets the flag
back to 'false'.

Fix that by always dropping the flag to 'false' first.

Fixes: 7212462fa6fd ("netlink: don't send unknown nsid")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://patch.msgid.link/20260520172317.175168-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a5ffda87daf63b..f8d9a04d5d8b11 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1484,6 +1484,7 @@ static void do_one_broadcast(struct sock *sk,
 		p->skb2 = NULL;
 		goto out;
 	}
+	NETLINK_CB(p->skb2).nsid_is_set = false;
 	NETLINK_CB(p->skb2).nsid = peernet2id(sock_net(sk), p->net);
 	if (NETLINK_CB(p->skb2).nsid != NETNSA_NSID_NOT_ASSIGNED)
 		NETLINK_CB(p->skb2).nsid_is_set = true;
-- 
2.53.0



