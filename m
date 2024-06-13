Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F841448FD;
	Thu, 13 Jun 2024 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279874; cv=none; b=fzabHXoJqwuktWyW1OMHj+fOFnyrQo+YtflWnGuL7AJKUeUiEdicwq8JiruuYXuqSF3YsDv88Fr5LKQyzbUFZxQE8t6JA7LBq2jErayNg+YraYfJ0O4EpSWQiZ8PEnjp/sy/TpJ0bILr+otccea4KRNf9y/EtlXkaetS9Qq+f2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279874; c=relaxed/simple;
	bh=EvtUnuMJ3zgs+euXkkn2R2X4HachYV5X0Oo2J1Eqj+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKjkh6I+8fb4m4BIkhmw8pPGhtkqJ20IMxVQRJ9PFXnxRk9Nru6AxRIQMynXTyi8HFUKkTZSTaDbU9j7SM5s9neW0NUxMkprUSR32rooaTb8wO0m8I0vRatfMQdMluPu5itc0reJCOLV4Q1rsAWJBc2+ir/c19gTJj69dVMKmP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iL1/ApSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iL1/ApSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B139C2BBFC;
	Thu, 13 Jun 2024 11:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279873;
	bh=EvtUnuMJ3zgs+euXkkn2R2X4HachYV5X0Oo2J1Eqj+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iL1/ApSiCakgqa0Abm6w9cFVoNSfRuq2Jef7jbdWc+G0Rdf9/tDdKgWoZzRDu4fr4
	 mDMpn0w4ZMG4c1PlZd5vxNAPZ9oIt/jJcWMx8xVKO7qbVrOYGMy4xBzDbXJFneidjI
	 A/6OXQkXIHnzjMpIMZf0lqsEQc2FACV7WdfraK4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/202] ipv6: sr: fix incorrect unregister order
Date: Thu, 13 Jun 2024 13:32:44 +0200
Message-ID: <20240613113230.325838237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7d8fbbc363ec0..98ee76b33b622 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -496,6 +496,6 @@ void seg6_exit(void)
 	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
-	unregister_pernet_subsys(&ip6_segments_ops);
 	genl_unregister_family(&seg6_genl_family);
+	unregister_pernet_subsys(&ip6_segments_ops);
 }
-- 
2.43.0



