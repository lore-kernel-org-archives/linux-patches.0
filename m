Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A8F143873;
	Wed, 19 Jun 2024 13:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802110; cv=none; b=pvd/IX7grC9HxmmleDjAKvn7o50gk9pPcCQGr+iHoLJdWK6KUmRny8UqdNHrqbl2PEUYEtMgrTsZVczKE9bpwKM7DO4/itj9Dgru2FEbuu/DecKYz8mMowdsAZsiIBVlPbv05RpYur2UUrIgOulpfJFmE84Ipr4mg+RsBjQzFb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802110; c=relaxed/simple;
	bh=6l851CqzCZB9SnMATgucg+YoNty8QsYWxCU51mRXcFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FW+jN5sRgyMoZwPg3cEt9p1zCbmPUHPHp5yQnQAuEoqz3E64Ceq+vFJN/38rqcSMMSGQQ7vi0qlhxCugVIVsJLDhwSzByz1H1QfZSab13FfPrz8hu8JH14FXNA1wyrjsyUHeK8dAJteakEHoUKGAHmvjiYJU7ETzDU/Mq3z5aA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxLQOmzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxLQOmzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C59C2BBFC;
	Wed, 19 Jun 2024 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802110;
	bh=6l851CqzCZB9SnMATgucg+YoNty8QsYWxCU51mRXcFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxLQOmzXl4jIw6CI3CljSAjRy+TvFTHOef5Ai/vVEPy0lOyGRVRp4fiiP++AGrSOC
	 Vd9Rbk270IhNIXazx1v30EGW5epYoyDF+Jn8pTnudEhkzhmrziYvGrEHj1Ag0sjsOJ
	 nRbk/nE7iKcHRNmMpMPREb8Z+Azqxvs0ubSr1BhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/267] af_unix: Annotate data-race of sk->sk_state in unix_stream_read_skb().
Date: Wed, 19 Jun 2024 14:53:25 +0200
Message-ID: <20240619125608.435310345@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit af4c733b6b1aded4dc808fafece7dfe6e9d2ebb3 ]

unix_stream_read_skb() is called from sk->sk_data_ready() context
where unix_state_lock() is not held.

Let's use READ_ONCE() there.

Fixes: 77462de14a43 ("af_unix: Add read_sock for stream socket types")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index dfa013283f478..2299a464c602e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2630,7 +2630,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
+	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED))
 		return -ENOTCONN;
 
 	return unix_read_skb(sk, recv_actor);
-- 
2.43.0



