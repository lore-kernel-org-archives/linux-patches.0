Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED1D1DFC7;
	Wed,  3 Jul 2024 10:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003338; cv=none; b=G/2GehwHD70xzIceLnlWwOLsyWdr/10uTZN7H6Z8aFx1Vs8KK0JOsIRUpP78fjKEi2GEC40JnzuiV/kaeW/Da9Kn73+Lr8GiA1Qb4ss+bAoUlHpvqYv2L9DFLGxOZn5ZATeyiOIPJ3PlEr4bYV2yYY+Y1jQ1yrCwcATLbDgMB/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003338; c=relaxed/simple;
	bh=24pwAMMnfr8kHx5+dUxz/5DYqPAnlE00ONworKgE6ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGUsvvewALEv1IaWF9224kVthvY0OOdeRZBYyS/Vvqey34aUSmRo7YrLF0Yw4mHTGt38PwOZK0JWSQvrOahQUKx1ca0zOVkBVz1RXnnYfGqbM6TESurL+Yh02jsWltkGrOcwr7gyu1iiojmr8SQezSSq4DMK9LlUIIV9pOXhm9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMmOJxEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMmOJxEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F37C2BD10;
	Wed,  3 Jul 2024 10:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003337;
	bh=24pwAMMnfr8kHx5+dUxz/5DYqPAnlE00ONworKgE6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMmOJxEP6nVNaMrVwZMvTRhSbsDt9EAdtSaHmMVJ8uwD9XQIVZrF7h2qJgvcGMnFr
	 O25DHsPAIgAkQ5bCcKwen5sjsPj/eq+yoRmJ+RMBD6YnJPpEtFW556Oj0tuso35Tzi
	 vj1sfGu+E6IVFeQieUs9wP/Lhbfg5xQqzXLc/KX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/139] af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().
Date: Wed,  3 Jul 2024 12:38:33 +0200
Message-ID: <20240703102831.052562924@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3ff6a623445eb..9376d4d4263f0 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -153,7 +153,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	    sock_diag_put_meminfo(sk, skb, UNIX_DIAG_MEMINFO))
 		goto out_nlmsg_trim;
 
-	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
+	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, READ_ONCE(sk->sk_shutdown)))
 		goto out_nlmsg_trim;
 
 	nlmsg_end(skb, nlh);
-- 
2.43.0



