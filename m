Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F3381AA7;
	Thu, 13 Jun 2024 12:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282015; cv=none; b=QTHF3lu3Xk82Ko3XOTHEiu6eFxknBUT/aoGKqR6rt9Xv3nlwqD+RK6bjIX1pLwjo/jVjYIwpB9BAwUtMM7hDMPPquqUmS49T9KDlrXxFdzW5eM4s6mKAuPkj9IeQxZPzgsMmSKrOvgxYfNQBdruYLlgMskaL8ml9eOKOpp45zE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282015; c=relaxed/simple;
	bh=J4w8U/r21s+LgZapNTd9vBY6ARcrZLSJwBxyCb181L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK44HBqGHHGwxAZPH1idCfU41p9jbj2xOhXbEReg5MgMSDbzyBNNvGh02H+56vb+yn7uqmW1tDJyhsFc0L2/aTAFBiv0IjmVjHqcEEM0bmwf+o1lE8+64/82tF8qVNnCT+j+4VRwO7TRK5sk3qtF6uMJW4f5wpYTPBID/9MOe/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/uP2xsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/uP2xsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F3BC2BBFC;
	Thu, 13 Jun 2024 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282015;
	bh=J4w8U/r21s+LgZapNTd9vBY6ARcrZLSJwBxyCb181L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/uP2xsMWqXhcn1/N2toiLu3FTa18+Qyc2cmMzYh/pRIc+Mjk38kRG7b8BU41svlO
	 W4SyGCIYDjxk49sF80msdaqU2Img0s/js5rGg/pZWtWoACIRcMYHHSPwRrl5FJy0WG
	 /2zTgTrW/tgh22hX6TtI6BU7lDlOwIEqh2jOk/dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/402] ipv6: sr: fix incorrect unregister order
Date: Thu, 13 Jun 2024 13:31:13 +0200
Message-ID: <20240613113306.656628623@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 6e370a771d2985107e82d0f6174381c1acb49c20 ]

Commit 5559cea2d5aa ("ipv6: sr: fix possible use-after-free and
null-ptr-deref") changed the register order in seg6_init(). But the
unregister order in seg6_exit() is not updated.

Fixes: 5559cea2d5aa ("ipv6: sr: fix possible use-after-free and null-ptr-deref")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-3-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index d626e0767a069..846c3abbcfb41 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -562,6 +562,6 @@ void seg6_exit(void)
 	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
-	unregister_pernet_subsys(&ip6_segments_ops);
 	genl_unregister_family(&seg6_genl_family);
+	unregister_pernet_subsys(&ip6_segments_ops);
 }
-- 
2.43.0



