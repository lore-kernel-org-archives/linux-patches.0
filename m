Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494372F94B1;
	Tue, 17 Jun 2025 16:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176820; cv=none; b=O6qm1RABYXRUb2iXnV/QG3pbxZsBQRaHkcVVu82J37zWHo/TVbU9IMmVUlWbg7OjyV/+BRjGqEF+mLHcJMSPoUyz8MO4sV9l7Sd5d2CsS6hilP8iMyP0WP9aJ5Di0aatQy/UAMLa6w9XPBJrksiMpslDd1tHEeV2nZrceZCr8WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176820; c=relaxed/simple;
	bh=QhS2aPYZjE/rY5nNuyvWQ4ytBcc2QUSnEpp/vHzmRfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUwg9/7jrtvFd2vPGvoEvKD69xDBUuqFIxRiSgQh/LvLB0AMmCAlnUEnjwgDTiPerhv+j9EUNwKzXTVDts8aiFpckdZ+Juf/R02UkNN3MOfPRzEdM0VRdlC6GJiR2PCzyaxjCDdW2FYBCYfdQD8NziGfIJoiv6LvTfU7ggamjbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USTuqmVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USTuqmVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BF9C4CEE3;
	Tue, 17 Jun 2025 16:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176820;
	bh=QhS2aPYZjE/rY5nNuyvWQ4ytBcc2QUSnEpp/vHzmRfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USTuqmVbuNwqUtmXSc0WsaiRS3DmERbpi8k3I8+ATMLZdnBCKcWh+O1C+G6C8EK/D
	 AHi/oaWZhUsmA0iRFmV4gE60Zl07Hrnf39QHOKSIiZn1SAsfNq67R6Nb8uF9XZ9hvq
	 4GwGaLQlJdP7fl7PXgm1yTN6OgUl8qccAh//T8No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Michal Luczaj <mhal@rbox.co>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 316/356] net: Fix TOCTOU issue in sk_is_readable()
Date: Tue, 17 Jun 2025 17:27:11 +0200
Message-ID: <20250617152350.879757512@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 2660a544fdc0940bba15f70508a46cf9a6491230 ]

sk->sk_prot->sock_is_readable is a valid function pointer when sk resides
in a sockmap. After the last sk_psock_put() (which usually happens when
socket is removed from sockmap), sk->sk_prot gets restored and
sk->sk_prot->sock_is_readable becomes NULL.

This makes sk_is_readable() racy, if the value of sk->sk_prot is reloaded
after the initial check. Which in turn may lead to a null pointer
dereference.

Ensure the function pointer does not turn NULL after the check.

Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250609-skisreadable-toctou-v1-1-d0dfb2d62c37@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index dc625f94ee37b..e15bea43b2ecd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -3043,8 +3043,11 @@ int sock_ioctl_inout(struct sock *sk, unsigned int cmd,
 int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
 static inline bool sk_is_readable(struct sock *sk)
 {
-	if (sk->sk_prot->sock_is_readable)
-		return sk->sk_prot->sock_is_readable(sk);
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	if (prot->sock_is_readable)
+		return prot->sock_is_readable(sk);
+
 	return false;
 }
 #endif	/* _SOCK_H */
-- 
2.39.5



