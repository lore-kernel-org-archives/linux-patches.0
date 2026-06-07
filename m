Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D621DE8AE;
	Sun,  7 Jun 2026 10:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826992; cv=none; b=c3c874bCOlH26AxmLwLVWKKkizNmAAfGChHc9rE1DbVF51TP6GtgQC4aHfw0zKOoNXnv8MKlmERaAnS8uXqnrKOmp+S5j/MkCN6EFQgJwhNgLV/gG43BAReVCAItTl6T0ml1ZP8II1oB1TIiGPSNSWgyi7UFD1zBcDGKB5hz3bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826992; c=relaxed/simple;
	bh=us+NBbaijlxxVU7imwvoOWb0r5KUKv4fFb7Gu9yVQm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGx6e5rC+10ZTDdDNpgLTyBGe6+00oDm9h8e08D1KT8LbsR0eAS36XeA0sgmVSRC0Ozj1WXWGFMirQS5vAtBtycbTL/n3bm7S+jUWRwEfiNBrDcVbSHburUslnDY2phw34wtRpp8RibBJ5UhJUvmBCw9GfvKMtmntv5fw0O4pvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSh8Tsqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSh8Tsqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDF21F00893;
	Sun,  7 Jun 2026 10:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826991;
	bh=R6r+xFO4j2PEZ9u8FohbxdkIr4j3iFZmMv8ryha0YEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSh8Tsqv4WnLIdqgBWoEHUXtZkaCh/on0B/NQLbYAhjpihLhjqFUaNjAOnt6JO6F1
	 VfQc1PPZ3C6O7MPPtbwssNUcikMYttS2SAHSW0o9I+B+ihVjIG0BDSXwGlMOl5ZLHr
	 bnw6GJu083qPYE9fRiEwye98gCrqmXpGd26vbjSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 025/332] net: netlink: fix sending unassigned nsid after assigned one
Date: Sun,  7 Jun 2026 11:56:34 +0200
Message-ID: <20260607095729.001534242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 4d609d5cf40653..441c9852b25714 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1482,6 +1482,7 @@ static void do_one_broadcast(struct sock *sk,
 		p->skb2 = NULL;
 		goto out;
 	}
+	NETLINK_CB(p->skb2).nsid_is_set = false;
 	NETLINK_CB(p->skb2).nsid = peernet2id(sock_net(sk), p->net);
 	if (NETLINK_CB(p->skb2).nsid != NETNSA_NSID_NOT_ASSIGNED)
 		NETLINK_CB(p->skb2).nsid_is_set = true;
-- 
2.53.0



