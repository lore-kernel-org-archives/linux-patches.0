Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7314236C9C4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302264; cv=none; b=M8tmiaQeLkvB1vKCLlVVtswQ4ba1MW1HOMRDZtmK+tMfxm9kXa6gXgSXSojJjdIrEmjG5j9Y0VYKpys7cSmGulAZWTA72Qr5e7VSgJFQzAISQsTk+e9IceyOfPELoyLeGUrqzDRGim6letE6qWp5VZPNjF/0GtBcCaDWp13L4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302264; c=relaxed/simple;
	bh=mpvGAouRdmmEBeN2Pz5xiIAzZ+mdgAb7cJwdfl/OZIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pza4q/zcnqDVwk2PeXJtRa9lYWfrVrXXELHHeMQeJOdVzNF3OZRyauwL16UbUrfee5EWC44xALyIXw1ow6AOR+nQAa+65y8HMNQBoD3JQ+rrOeG82PAaVEiFDFR3eZHR7rV4SuwRjBPJFL4EJ8tbsg2VPTAt4l9BIF64TRjQbiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDPfNNvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDPfNNvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFB9C19423;
	Sat, 28 Feb 2026 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302264;
	bh=mpvGAouRdmmEBeN2Pz5xiIAzZ+mdgAb7cJwdfl/OZIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDPfNNvUqspeJcXDcGMEFjF+8ZjI4NNfv12ZHvEHDl6zG110of2weWsuKU4sucVSE
	 yC+q4giEz/d/t/0laFGcsauIgtgcxP278nlqEXtFobaj0qIr4Nt9qynDxGG4Ksf0Uq
	 pP1oUwD2tPoVCUJsKSFlq4atL9OObT+i6kOiptP7gdrC1n4mDDlTKUpiseiYPtITgf
	 NSNIA0eN1ZE988VVcUQjNIhJ3Az00/6oKOiJkk6Hoq4iOFaUFL9fDYX8iOTPHBh0gf
	 XQB6hrotBoUVZh8MhHerFh5SgbaXpLNy1WTZ33R+7P+uHtq/hB6AZkiVkmKlha46Pp
	 g1nZQ3eyqZzIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/283] ipv6: fix a race in ip6_sock_set_v6only()
Date: Sat, 28 Feb 2026 13:07:02 -0500
Message-ID: <20260228180709.1583486-280-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index c6932d1a3fa80..9e5e44c6da0a6 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1293,12 +1293,15 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 
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

