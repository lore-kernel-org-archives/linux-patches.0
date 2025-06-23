Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D3815ADB4;
	Mon, 23 Jun 2025 22:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717358; cv=none; b=hhhrfSfCkeQSuAho9WVa+pSVsbkWN0aIzu0iJHabP48QAWxsY8TI0J9My34PttBHv+39eZ/7r3NPh9Pwl+NVmWqw3T5vtIvt9Ug/XPo8+eAR6BlDmP9kIdZqMbf8Mt49IPZD+v5UILh+vwOW90Vv1v+iOmAYU/am1TrmhU6Y1lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717358; c=relaxed/simple;
	bh=xVDcuImuL87Jc7nkVzEQ3AZp/vUxR59jRymuJWHP97I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACSxGe6dz6rsS7RR4JteqnDZak+aJd6u0nJ3i20C/d7QXAhiDDe4nt5Q6O2nk6ne123SIQ44GGbIlPKJfQnfjurq63942KedoSZ6hKeqirXDPYiHMtfI5dDPKZ+WixR82hyY/thmuaZmHYuT/PYnaopjSmmLR51xhqb128m5YUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qU7rfPYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qU7rfPYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7EDC4CEEA;
	Mon, 23 Jun 2025 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717357;
	bh=xVDcuImuL87Jc7nkVzEQ3AZp/vUxR59jRymuJWHP97I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qU7rfPYZpGghvw5yyf4LWcfrqH56nOZswk4qoeMqXaE0ffASEJePy5UJmiw3dGnOe
	 FOxJdRD5c1GmHx3QEEA188vr+mJNTevRTlA5kDQ9kQwf4nXS1gaewguN888CAH3okn
	 JyYYj9YdGuoTMIkysOtVTIIFThcMbBuErgf0qW6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	willemb@google.com,
	asml.silence@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/414] net: netmem: fix skb_ensure_writable with unreadable skbs
Date: Mon, 23 Jun 2025 15:08:29 +0200
Message-ID: <20250623130651.256118847@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit 6f793a1d053775f8324b8dba1e7ed224f8b0166f ]

skb_ensure_writable should succeed when it's trying to write to the
header of the unreadable skbs, so it doesn't need an unconditional
skb_frags_readable check. The preceding pskb_may_pull() call will
succeed if write_len is within the head and fail if we're trying to
write to the unreadable payload, so we don't need an additional check.

Removing this check restores DSCP functionality with unreadable skbs as
it's called from dscp_tg.

Cc: willemb@google.com
Cc: asml.silence@gmail.com
Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250615200733.520113-1-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fdb36165c58f5..cf54593149cce 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6197,9 +6197,6 @@ int skb_ensure_writable(struct sk_buff *skb, unsigned int write_len)
 	if (!pskb_may_pull(skb, write_len))
 		return -ENOMEM;
 
-	if (!skb_frags_readable(skb))
-		return -EFAULT;
-
 	if (!skb_cloned(skb) || skb_clone_writable(skb, write_len))
 		return 0;
 
-- 
2.39.5



