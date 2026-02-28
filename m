Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA5135AC20
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302771; cv=none; b=TuPHPhw63omcCn5RgFZRa6AsWIwGdGJQvvw5WtEld6kG2hiy/GqlT6IUi7njPdZlN6idgkVcXKg2mPanUK9qWVKRgCPW0nwO8A5hXCGcC+ZMOAn698OGiGdYtjycVRftST6nt6EBtj+v8VrEE2DXl7X9Afw3YwIVQwsZbErCtqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302771; c=relaxed/simple;
	bh=81un091ESFW314h6JIVdv1wNKzq4YbRrXXMmAS0sFU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRm9D3IiL/DPFIBOZ8qSdwi3Mb3pGYZDhB1E4ywywPt56rfSW0VtPBkfRTzlptgaOKMFFjykO7vyeOqbVyWyI/aUOInlsBonih78JSxxjoyF5z/FKd7WtP50oA0Q1RvF+5Mb3vDct2nubCId5jiDXq6IXCPoJtFt948rMbrtj6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZMTEM1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZMTEM1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CD1C2BCF5;
	Sat, 28 Feb 2026 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302771;
	bh=81un091ESFW314h6JIVdv1wNKzq4YbRrXXMmAS0sFU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZMTEM1zaHVnPm2kTXciJHtJc070rjOMFXQTvI+PkrdmZvwL0g2OQFPyKqWHEkbCa
	 guh9pmLEFUkp9ikCB9RNvsiaDxYCEEB7qrunY5yYX9ZeUFVf09IvcTEu93RvLdZsvu
	 mKo1mDHTD8OlFlRzgqehoL/7eaHWwGCYSREvjKrR2E4Pl6q0wZanOAFh3gp76QckKD
	 pXs37YLIfbP90u+ba/gvqwPPDa6ejqKgVj0/oBlBmlooz79saMp9lmkL6D12I+eacc
	 R8HxHHnttkvNTxPeu8E8YAHwYqkuIVY3XdVc6uga/ma2NMfLrLv9uzs5kd2NmHXZVC
	 0UztpiJ5UgnUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/147] ipv6: fix a race in ip6_sock_set_v6only()
Date: Sat, 28 Feb 2026 13:17:32 -0500
Message-ID: <20260228181736.1605592-144-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 452a3eee22c57a5786ae6db5c97f3b0ec13bb3b7 ]

It is unlikely that this function will be ever called
with isk->inet_num being not zero.

Perform the check on isk->inet_num inside the locked section
for complete safety.

Fixes: 9b115749acb24 ("ipv6: add ip6_sock_set_v6only")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260216102202.3343588-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ipv6.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 2909233427de0..d7b0710d0d9c1 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1177,12 +1177,15 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 
 static inline int ip6_sock_set_v6only(struct sock *sk)
 {
-	if (inet_sk(sk)->inet_num)
-		return -EINVAL;
+	int ret = 0;
+
 	lock_sock(sk);
-	sk->sk_ipv6only = true;
+	if (inet_sk(sk)->inet_num)
+		ret = -EINVAL;
+	else
+		sk->sk_ipv6only = true;
 	release_sock(sk);
-	return 0;
+	return ret;
 }
 
 static inline void ip6_sock_set_recverr(struct sock *sk)
-- 
2.51.0

