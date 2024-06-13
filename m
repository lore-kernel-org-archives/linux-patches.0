Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3DB1448FA;
	Thu, 13 Jun 2024 11:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279871; cv=none; b=LH/KhwTSD+GuBfCl0jAkW+HAD1bWcOotodw1YgUClg3a1OmbOg3iGOZWoIqz/edHqHNDY1i9KnyNoBbJ/4j32jfWFlPMTez5ibzIi81JU6aq0HLsqPHM4bMe68NKTVkNucRoYEQ2OC27Qcg5ZBlTPiFu5mJIFqoKvWmYzzWg/yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279871; c=relaxed/simple;
	bh=AE9RzksKLEP7iV0X+emEmuESTpsYiCNFgcU2pot3Tcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDXnbk9BorzdaXJ+VXN/z1fZenAqkUbD+FQFWb9ZDY3FF1QUjWYXPzHE2bJlbZapgfKS4VmpS8PVCH9/kK8OJvzQdteet5osmCPEppgpvsWgUBLtkdpw0WmRamcE9c7aX5BVNQPMI/nt5GO3H7aj3QEApST6e9ta3HtZpHLRMcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qe05cbFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qe05cbFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960A0C2BBFC;
	Thu, 13 Jun 2024 11:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279871;
	bh=AE9RzksKLEP7iV0X+emEmuESTpsYiCNFgcU2pot3Tcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qe05cbFbcZZVUAeOwCOUO4UOEtXd+s9t1KpmBwKjPhzyNRPrn9yaHDnRJl142RKiu
	 c5P0lJ7hDfCH36uABfGDru4yjR847FBl7ygEI8nVZ2V8JErX8/Wmpm5UDM79OzT/yv
	 UtY4ALwxHLOQKwZBMdn+dvOK6azjk90QPCHgnmn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/202] ipv6: sr: add missing seg6_local_exit
Date: Thu, 13 Jun 2024 13:32:43 +0200
Message-ID: <20240613113230.287803586@linuxfoundation.org>
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

[ Upstream commit 3321687e321307629c71b664225b861ebf3e5753 ]

Currently, we only call seg6_local_exit() in seg6_init() if
seg6_local_init() failed. But forgot to call it in seg6_exit().

Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 7094f8691ac68..7d8fbbc363ec0 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -493,6 +493,7 @@ void seg6_exit(void)
 	seg6_hmac_exit();
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
+	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
 	unregister_pernet_subsys(&ip6_segments_ops);
-- 
2.43.0



