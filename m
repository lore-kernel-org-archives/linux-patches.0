Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A331EB5E1;
	Wed, 25 Feb 2026 01:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983323; cv=none; b=tK0XA3pyNckyHpyAPw37CW6bffFjYjlhdC0IXE2LE9mQvQ977Y2ao4RiiefzOpYSKQnVQmI/1caXNvmVpiYZeJR5ivk+xfMSOBG2OG804DkNlb8Xb0ApQkCsAzrhz0S62cztK7WzyVzizHZv2dOEKfpbSaoohqER5Tbc4CYETNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983323; c=relaxed/simple;
	bh=y5g0pxswbCKf2f8fdZPGVoN4X9VwmVMcr/ORPJ7Yono=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoNBT5d+yEXz+zo0i5ULBV5aatAzSFaT+aISciAVgjbNJEcTi+bUiwKGxOBzaEfV2Ar5XBBI7q+m9b+h2tK+JyLMSN8kOvSHrplJXMse/8zANUZRjlrIqW2w1bmN0m52xz/ORKkxn4MVE8EEMGgTroUnOCEkLDxKI+e/tVP9dlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAkPUIQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAkPUIQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442D3C116D0;
	Wed, 25 Feb 2026 01:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983323;
	bh=y5g0pxswbCKf2f8fdZPGVoN4X9VwmVMcr/ORPJ7Yono=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAkPUIQDgvRu7woQ0WDE1plhIt4XaN57jMHYF8xfS5i+i16XVWa3Fkh6kdiJ5lFl0
	 mpvaN9Y06T4vvl8PVVrcnkrgQYOuITmSyhgbNZhdJBqNcbvnN+7aCLAHPcQl56eq28
	 gqlwG5gLs6QzQ6jx9g1PkxWZtAAHC65uQqR5vlrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 438/781] af_unix: Fix memleak of newsk in unix_stream_connect().
Date: Tue, 24 Feb 2026 17:19:07 -0800
Message-ID: <20260225012410.444770060@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 6884028cd7f275f8bcb854a347265cb1fb0e4bea ]

When prepare_peercred() fails in unix_stream_connect(),
unix_release_sock() is not called for newsk, and the memory
is leaked.

Let's move prepare_peercred() before unix_create1().

Fixes: fd0a109a0f6b ("net, pidfs: prepare for handing out pidfds for reaped sk->sk_peer_pid")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260207232236.2557549-1-kuniyu@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d0511225799ba..f6d56e70c7a2c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1650,10 +1650,9 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr_unsized *uad
 
 	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
 
-	/* First of all allocate resources.
-	 * If we will make it after state is locked,
-	 * we will have to recheck all again in any case.
-	 */
+	err = prepare_peercred(&peercred);
+	if (err)
+		goto out;
 
 	/* create new sock for complete connection */
 	newsk = unix_create1(net, NULL, 0, sock->type);
@@ -1662,10 +1661,6 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr_unsized *uad
 		goto out;
 	}
 
-	err = prepare_peercred(&peercred);
-	if (err)
-		goto out;
-
 	/* Allocate skb for sending to listening sock */
 	skb = sock_wmalloc(newsk, 1, 0, GFP_KERNEL);
 	if (!skb) {
-- 
2.51.0



