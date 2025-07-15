Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82EB2E267F;
	Tue, 15 Jul 2025 13:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587073; cv=none; b=YkM7O8skp/RMzbgH+3YlSNKkYu4KmP3wkU8CHjF57SCB+wo5wdR2ohHvXrxMWfbmg5VIWJtl+7IrbDHc255KYGpYUqGaTkzgojRQMECeGcjVYm39olZETSy2O046gmixu9zMCuRDoIZm+KRWM+WfiSi7+Fs9k91tl/+qtvx4tpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587073; c=relaxed/simple;
	bh=0YLE+FFOstYQXbmTaAcvUYmGY1KQa0pWhKticBr2Zrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IokVxQZH2hkfAzrBTeZ8aTvqjSJJa24LWTmaXpxsAuFM9P1c4KyOe/ESM+xeBoWhBL3XN7y6zWJ8qupJpQLMbrNUuuX2+5lswZQDJhg5C0stHJ2z1tz+Tb27zrQqwH7Be4gsdQnBYQmwnPjB1SMeUfbbCAFB4R0vB2JbWDgHqeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU6ApTWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU6ApTWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEEBC4CEE3;
	Tue, 15 Jul 2025 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587073;
	bh=0YLE+FFOstYQXbmTaAcvUYmGY1KQa0pWhKticBr2Zrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU6ApTWDBA8HroCN1tldZt87GVCZITFPdHweDsK2h5Txu1lK/yTcuaIZ9TF9nHS14
	 86T5GZbgcyMWNlBAe2fn48ZXuohYfxxXadtZ5Yu/T+k5s/NAtxQd+L34UJZGp788xh
	 aMv3CyrNv0YwfHiD/ly1wC4kWIExMOXSFgut158s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 125/192] netlink: Fix rmem check in netlink_broadcast_deliver().
Date: Tue, 15 Jul 2025 15:13:40 +0200
Message-ID: <20250715130819.913773800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

commit a3c4a125ec725cefb40047eb05ff9eafd57830b4 upstream.

We need to allow queuing at least one skb even when skb is
larger than sk->sk_rcvbuf.

The cited commit made a mistake while converting a condition
in netlink_broadcast_deliver().

Let's correct the rmem check for the allow-one-skb rule.

Fixes: ae8f160e7eb24 ("netlink: Fix wraparounds of sk->sk_rmem_alloc.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250711053208.2965945-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1395,7 +1395,7 @@ static int netlink_broadcast_deliver(str
 	rmem = atomic_add_return(skb->truesize, &sk->sk_rmem_alloc);
 	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
 
-	if ((rmem != skb->truesize || rmem <= rcvbuf) &&
+	if ((rmem == skb->truesize || rmem <= rcvbuf) &&
 	    !test_bit(NETLINK_S_CONGESTED, &nlk->state)) {
 		netlink_skb_set_owner_r(skb, sk);
 		__netlink_sendskb(sk, skb);


