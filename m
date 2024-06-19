Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFD61422B8;
	Wed, 19 Jun 2024 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802860; cv=none; b=JvHiZla+4FTvxt5J6xGIP8NCOxYBfUEdKPVopCPyxzLNb/sU6mz70qMCVPOcAPCLYfb+P2slSPpR/1E5o3/qEHCuJR13gyIgZYSHnw1FUcf7JXDQgZC0yEhO8jY1EMbc7qbyS1gP+gy91dFe8UrWlB0XgIKQuhHQbtLpxtlRx8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802860; c=relaxed/simple;
	bh=wCNqA6E04SlDXLKTHdyTPf+2ZSWhxPh4qNOlb1HfL7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdVunrW0j2wOyUamGNjAZmQr0Vck9Jdl9HfzyAl4m0HZG3TDm8u4z/WB+Gv69SoTjrc/poOKdzs1TbDK0uNn1UTQO9Ymrz4tLV1qd6xJ+parM/d1d/l8cM++ONIx5HaPdC7RwFgQ7srqWLvVcr3SCF4kJ6poworHvDSwzYfMxlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXqEaVkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXqEaVkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968AAC2BBFC;
	Wed, 19 Jun 2024 13:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802860;
	bh=wCNqA6E04SlDXLKTHdyTPf+2ZSWhxPh4qNOlb1HfL7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXqEaVkcHhOI5iLAJeXs1n4FdZXfwr3W6y5lZAt4a+l2xI46r1igKsToYmXQH+0nq
	 s3hGJZnIPDkqDbNbQnqrAtDs+OU23uC32jH1bVwySwEfFW0A1Bdtil9wfCIw8daWFz
	 ln/Cxqpj81/imv7GCEyJ/BXMGcGyBT1Jt+3nacxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 070/281] af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().
Date: Wed, 19 Jun 2024 14:53:49 +0200
Message-ID: <20240619125612.537374778@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit efaf24e30ec39ebbea9112227485805a48b0ceb1 ]

While dumping sockets via UNIX_DIAG, we do not hold unix_state_lock().

Let's use READ_ONCE() to read sk->sk_shutdown.

Fixes: e4e541a84863 ("sock-diag: Report shutdown for inet and unix sockets (v2)")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 321336f91a0af..937edf4afed41 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -165,7 +165,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	    sock_diag_put_meminfo(sk, skb, UNIX_DIAG_MEMINFO))
 		goto out_nlmsg_trim;
 
-	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
+	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, READ_ONCE(sk->sk_shutdown)))
 		goto out_nlmsg_trim;
 
 	if ((req->udiag_show & UDIAG_SHOW_UID) &&
-- 
2.43.0



