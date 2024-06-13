Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39CC3209;
	Thu, 13 Jun 2024 12:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280945; cv=none; b=SQiaEPJEdcH79PSWW0NrQ60qJ4TKIP1vF5v1oLCsuN01Bkc0oPtXM0yHxjJjyU2mDw46InL9RMtdHgHPeb799w8IyvMpj+JZMuy42nNrydzhXQavI4ZX5CCn+Ajn8gy8tPPUdGysT7K//TBf987Ye1vgJASTFpnp86ikF3P/LAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280945; c=relaxed/simple;
	bh=QEAXNIjtqWp8S62MeK833T6Y4DKQC0yIL5bT7vz3UDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adoVI+wASHEwm+ZanvXlXdlzCsYys6mjhoj9AZpIYyneI33lHVtgH7kSc0ie5UiPKPNr2IUufWIx7jLUCAqJh2QSsHVJLUttf5IHMGOVd23/bxqkHz2sMuRq6feJBP6iYS3HA98i++gCsCZBNfe4qAclmC27PyxXIPPB+xP97zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpVNrZb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpVNrZb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70893C2BBFC;
	Thu, 13 Jun 2024 12:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280944;
	bh=QEAXNIjtqWp8S62MeK833T6Y4DKQC0yIL5bT7vz3UDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpVNrZb8MFdb/qVjUL/YbdcuQheqTNGkMLScu7iiPe2JK0xjdp3tUhBzltArLLLeN
	 lEO/RjqcpOrGcqTINzKPXxNBsnGhbanZz2Sv6XZhFen5qstji4mmW4cRked6HVP9Lh
	 nZtjb15LyWQNJDHpsZd04PuxTEh6lKNmVsRV7hzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/317] ipv6: sr: fix incorrect unregister order
Date: Thu, 13 Jun 2024 13:31:45 +0200
Message-ID: <20240613113250.913962100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1a7bd85746b3a..722bbf4055b02 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -506,6 +506,6 @@ void seg6_exit(void)
 	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
-	unregister_pernet_subsys(&ip6_segments_ops);
 	genl_unregister_family(&seg6_genl_family);
+	unregister_pernet_subsys(&ip6_segments_ops);
 }
-- 
2.43.0



