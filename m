Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8D8359A91
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302480; cv=none; b=DkdqAC2oCnd42w34Lm1bcSI7r/G3QxlJr0mduHJmKDjKZaH6/FRzzSOjesskgMD9tRhRJyV9lhwMoo7YIGXziJMUkhwapkMkdzO30UYsEUz9opezyMzYt0RnRxa311DcldjHQRrUWca4mzkb80EYBt0TFi5XD5lESQsJQp7wCzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302480; c=relaxed/simple;
	bh=nyHbfN+xScB/1FT0MnfMknEdHC7MxVEItiM2iT70C20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sthQcfsA/qO0Ae0lixfhszYk3R9lHrvn6Yda5ipd1LpeQzufR5z8W48YGKtnkSGL/ZwSFy6OPQj2HQn9xY7JEHiUx0w89e78RHxmVHMZ0DBzVmlabKRVZM05+zKeEz9qQlM122Aib48j+iZig+9dlnvqRt8xOCHkKHIOlLYuYfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgToqUG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgToqUG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13FCC19423;
	Sat, 28 Feb 2026 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302480;
	bh=nyHbfN+xScB/1FT0MnfMknEdHC7MxVEItiM2iT70C20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgToqUG21KKWIalRyqqVwDwii4BZKCrif92Rf6Vcoo/LVH7MFLLcPKgEPe0ClmYvt
	 61O1I5K5U4TkLJYtOiAwGuneWK1wjtQTXm/CR6MfoWv1L8vk2c9jr1R0kf/tjVzc1G
	 DMvWJNib0GJD3f7TWMJDGKhZ3cPX8ipLc/pP2WQuRX/9xru5y1ua6XigDjfbfnHQo+
	 JLDPh+Tqn6R7vwGpASyzbQA15Cae5ecvCVKJBSf6Y1oFHLpqi/OdBG3iAxiBAAUxPU
	 Jj0MdUHr/CHI4/THO3ITjF1S7ZTqWrpiJxd/VGYvIOxclv7LUrCLcy6daSnw+Ix8wr
	 qs6iKAiihghCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 227/232] ipv6: fix a race in ip6_sock_set_v6only()
Date: Sat, 28 Feb 2026 13:11:20 -0500
Message-ID: <20260228181127.1592657-227-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 517bdae78614b..3bf743d601e1c 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1255,12 +1255,15 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 
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

