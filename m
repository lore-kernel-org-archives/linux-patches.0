Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A23F82871;
	Wed, 19 Jun 2024 13:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802273; cv=none; b=FoW/xctk4HFiYWl2248R49RbMoaHQypPHBN2MDpSAZSvcG73fZdGoHFbEjA3FbPJYWqmWqW31+tB/NdskMssEE9cAIn+v/GE6X/iMqjz8+rdeYCSpC0zm1JLzOwVyrmXeecH+hJfMBggriO9zAHfuEagOqCdccm9zsaahptFH6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802273; c=relaxed/simple;
	bh=jRIgtNfssuzajYyNgLJCWuj5EYFb3q1aSXDtapevWBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb/PWo3Q34xWrOapaYS5a3G14ktCgCERtl1zKp2EbddVG8/5IixFEhocCqWleyGzcA7EO5Yr4q87X4Se+FI1fJ7ii9HAtfXahi7I8heX3IBg/8s4MScaP4mS9tv9LEzYbuo7JPrfCnBch04N1MyVLkSlGwKSEvw73XKF6n4QwGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8ifDTVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8ifDTVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BBBC2BBFC;
	Wed, 19 Jun 2024 13:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802273;
	bh=jRIgtNfssuzajYyNgLJCWuj5EYFb3q1aSXDtapevWBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8ifDTViU7uJLC2lBOvazbmj5ccJiPRRqTw3dUJs0RwUAwbPGniVQhO9VvhaWOB0f
	 8YXbCIeGBbvyoOixoiOJraI+zN1HO3zU8Ttq+6Lj/6PJ5sgNVBwfUaL/NKNQxfrvgL
	 GpYD0QYUXHWSNVWxU9h6ZM53vEU5agEEDJgzqFmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/267] af_unix: Annotate data-race of sk->sk_state in unix_accept().
Date: Wed, 19 Jun 2024 14:54:51 +0200
Message-ID: <20240619125611.721295017@linuxfoundation.org>
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

[ Upstream commit 1b536948e805aab61a48c5aa5db10c9afee880bd ]

Once sk->sk_state is changed to TCP_LISTEN, it never changes.

unix_accept() takes the advantage and reads sk->sk_state without
holding unix_state_lock().

Let's use READ_ONCE() there.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1710,7 +1710,7 @@ static int unix_accept(struct socket *so
 		goto out;
 
 	err = -EINVAL;
-	if (sk->sk_state != TCP_LISTEN)
+	if (READ_ONCE(sk->sk_state) != TCP_LISTEN)
 		goto out;
 
 	/* If socket state is TCP_LISTEN it cannot change (for now...),


