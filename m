Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A783E70838;
	Mon, 23 Jun 2025 21:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713054; cv=none; b=cEbZinuoDx+05lf/dw+WZB9a+XyKllu5Cz1EluiQW/2xqAfKqAru95uU8FuuouMk3MLK4slENlZr0OCNq8TpDhCl5+QATbaLHqSf5AZn+nB9XMb/17q6z0Kpm7WBsmLdu3/+T4mmqCWMliZBHomS0Ms4Al65coGMZsfqMy8CYbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713054; c=relaxed/simple;
	bh=JxXYELSmYGCPe+F1Vd/8GTw2WDkogA6BwkxzAMZiFus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlW7jf4PPRvh3RM2wmSROpQ+B9qAmuyG2UtzBwxghMoD641EMfaP3apRGJo1u2kzMWijfm/Yn/cYKs9OHsYlmC7Tpd0fAYGwBOITc+uz4Nuy668v7WQlauOLrC9AlqqhbpZ1ZGhPbH0qZ3dVjjlh+hql114b2MSCZLaTycey3jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPeIsauF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPeIsauF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDB9C4CEF0;
	Mon, 23 Jun 2025 21:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713054;
	bh=JxXYELSmYGCPe+F1Vd/8GTw2WDkogA6BwkxzAMZiFus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPeIsauFan46Mj4s+H+VvgdEd2HEH9LfvPjADRgFdjhm9rekDjZDQlsGlE8bSocyo
	 tIBq6OWZf+i5Civ5FRqrU4RLSU4WVGGJQfx/+KIZP2fW2KHwfXZk02Nh8Kb+2WJqXN
	 ok3mT5JSLqN/gaQfUZ/S7nXJxxbcJ0bSbaVgEYD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Michal Luczaj <mhal@rbox.co>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/355] net: Fix TOCTOU issue in sk_is_readable()
Date: Mon, 23 Jun 2025 15:05:29 +0200
Message-ID: <20250623130630.591249304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b9e34b955c561..bc9a1e535d580 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2827,8 +2827,11 @@ int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
 
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



