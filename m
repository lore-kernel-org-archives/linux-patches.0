Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38571171E70;
	Wed,  3 Jul 2024 10:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003914; cv=none; b=S/wm6Kt6kstXAycnxGCnealkaoMIPVyygdqaZn7mg6Nv80qhbdIx3B+cZET2eOT9MozKZlcOWinIgza2mM+37PZZP/dbbvAlTEcn0BHEI+e2CyJoAqrJqENx6OPuAg1j2cnjfNEXFRxovRVedIN+loUgQDhvkGYsPIv6x6OBNtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003914; c=relaxed/simple;
	bh=2D1MVleHWMbDJZqwQfvE3Ako3D1PU5jiV2/jzh/weTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru/mp2C3tmdByqz6YUCT5PMnDD73k8b2gSzsJQ4zosZqFxUK8Pz9shR9W1uKGnHxj/0YO+kiJmal5TqK1/wcGAjfeKyXHA7QpdblxU01Nyyb3JAgeKbBULseDr9NZ/CfzxAv0JBXTYXQ2HCCvzpZdUtRLxkRoKj+x5mCMP2IWm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psnyKMyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psnyKMyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B4C2BD10;
	Wed,  3 Jul 2024 10:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003914;
	bh=2D1MVleHWMbDJZqwQfvE3Ako3D1PU5jiV2/jzh/weTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psnyKMyc1bGYVCQAXaVKyaqtfOilCh15Mq6XFCqG34uwD8MuLiNHRLLGh4FfLLVyg
	 YUzrhmT0iQxWv1nj9BPuJvc5s01dhsyrvzrlEvtYVul8PHvENVMr6Sq9Ons6DjIvNb
	 vH+9VoAO/W+BpoMfsPKb/x6aca90CU7JHTLEnPoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/189] af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().
Date: Wed,  3 Jul 2024 12:38:02 +0200
Message-ID: <20240703102842.305029611@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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
index 5bc5cb83cc6e4..7066a36234106 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -164,7 +164,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	    sock_diag_put_meminfo(sk, skb, UNIX_DIAG_MEMINFO))
 		goto out_nlmsg_trim;
 
-	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
+	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, READ_ONCE(sk->sk_shutdown)))
 		goto out_nlmsg_trim;
 
 	if ((req->udiag_show & UDIAG_SHOW_UID) &&
-- 
2.43.0



