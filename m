Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A016C1CAA82;
	Tue,  8 Apr 2025 11:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112910; cv=none; b=e6YDOie1a2wFs03x3SZLY1/fr1uGkrPEl6h7HbwL2x++vjwzSLT4DDydM4ZBoSLI2dI0B7L78o8hn4JzSUENxtBZ0xmvFWOE2ldZbThhKhcY2LP652vvEMEelchPy24qSdU/52WPjXqT9aJa7ihKhq4Hw42rcj8FsJ6hqk7mvOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112910; c=relaxed/simple;
	bh=8EGxqHbxWehlZPoyy4JK5YPv3tb1elvFrFA2Liz2Ffw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Go1Ufs1wMqJJTu0jDjrTphDvHY+RELHYcNbMrzAyD93F71Iteilr0h4ESrlea2R6ewgtLluhOSNXnqk/KevLEvQV63SjRdpquC9MAoPT3fCwG4J8pIn6PCpZ/im1ekPHnqzsXHb7AIbtHOBJxoMzTYnJVTsSsfkgZ5q5ojECP8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5ndmt86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5ndmt86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DACDC4CEE5;
	Tue,  8 Apr 2025 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112910;
	bh=8EGxqHbxWehlZPoyy4JK5YPv3tb1elvFrFA2Liz2Ffw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5ndmt86rkJ6U5QzgJzCLHIfy7Ga1SBVu9xUCoC0sZ5xV9NDWgd3OOG7XS6yVGUwV
	 qpovQ25a5V9H1BCqwAk1A88B8cpNjzuPHU4RfOdbwS0LrAFA4+KH8iqLaY5MsN5l4l
	 yCx/UWInzMKct9qREyfXCjze6Ql5UgD9lzMbe30E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Debin Zhu <mowenroot@163.com>,
	Bitao Ouyang <1985755126@qq.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/279] netlabel: Fix NULL pointer exception caused by CALIPSO on IPv4 sockets
Date: Tue,  8 Apr 2025 12:50:25 +0200
Message-ID: <20250408104832.916918017@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Debin Zhu <mowenroot@163.com>

[ Upstream commit 078aabd567de3d63d37d7673f714e309d369e6e2 ]

When calling netlbl_conn_setattr(), addr->sa_family is used
to determine the function behavior. If sk is an IPv4 socket,
but the connect function is called with an IPv6 address,
the function calipso_sock_setattr() is triggered.
Inside this function, the following code is executed:

sk_fullsock(__sk) ? inet_sk(__sk)->pinet6 : NULL;

Since sk is an IPv4 socket, pinet6 is NULL, leading to a
null pointer dereference.

This patch fixes the issue by checking if inet6_sk(sk)
returns a NULL pointer before accessing pinet6.

Signed-off-by: Debin Zhu <mowenroot@163.com>
Signed-off-by: Bitao Ouyang <1985755126@qq.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Fixes: ceba1832b1b2 ("calipso: Set the calipso socket label to match the secattr.")
Link: https://patch.msgid.link/20250401124018.4763-1-mowenroot@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 1578ed9e97d89..c07e3da08d2a8 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1075,8 +1075,13 @@ static int calipso_sock_getattr(struct sock *sk,
 	struct ipv6_opt_hdr *hop;
 	int opt_len, len, ret_val = -ENOMSG, offset;
 	unsigned char *opt;
-	struct ipv6_txoptions *txopts = txopt_get(inet6_sk(sk));
+	struct ipv6_pinfo *pinfo = inet6_sk(sk);
+	struct ipv6_txoptions *txopts;
+
+	if (!pinfo)
+		return -EAFNOSUPPORT;
 
+	txopts = txopt_get(pinfo);
 	if (!txopts || !txopts->hopopt)
 		goto done;
 
@@ -1128,8 +1133,13 @@ static int calipso_sock_setattr(struct sock *sk,
 {
 	int ret_val;
 	struct ipv6_opt_hdr *old, *new;
-	struct ipv6_txoptions *txopts = txopt_get(inet6_sk(sk));
+	struct ipv6_pinfo *pinfo = inet6_sk(sk);
+	struct ipv6_txoptions *txopts;
+
+	if (!pinfo)
+		return -EAFNOSUPPORT;
 
+	txopts = txopt_get(pinfo);
 	old = NULL;
 	if (txopts)
 		old = txopts->hopopt;
@@ -1156,8 +1166,13 @@ static int calipso_sock_setattr(struct sock *sk,
 static void calipso_sock_delattr(struct sock *sk)
 {
 	struct ipv6_opt_hdr *new_hop;
-	struct ipv6_txoptions *txopts = txopt_get(inet6_sk(sk));
+	struct ipv6_pinfo *pinfo = inet6_sk(sk);
+	struct ipv6_txoptions *txopts;
+
+	if (!pinfo)
+		return;
 
+	txopts = txopt_get(pinfo);
 	if (!txopts || !txopts->hopopt)
 		goto done;
 
-- 
2.39.5



