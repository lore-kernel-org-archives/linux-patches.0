Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E2B17727;
	Mon, 27 May 2024 19:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838333; cv=none; b=UxnnA3jKLqg10xb/hWdOpqnhQv4avyOMImrN85v6L6A16E4jtgz1WRiN8+LM+jFuZyb2HmgGseF9SQe/j//Ml8sFostF7RBpj0y4HUqijYlroN0b6yPQmWi5iENViggJ76IUuSqNEIm4qbLlvQnIGfM5bhMnrncLTSamFEAW5U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838333; c=relaxed/simple;
	bh=d7bwFjlGOP6nmMK40veE+dk1LZioRYUz/v9Q7q1X2bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPjYiHRmqfEW0P0cpl7Q852/EjyxF9ig+Zb4hoV/5M9V7aTFWlUELs1pxOUA2XPz7/jNrbdn6itEh2aZSUcQNuxyOT6uUif4Qhi+kpZu4lFZ6sg3N3lgoud1T3s3bxHpJSmqFsdDsynWm8m8Bp+T6RwZ9fu1ZIkW9rgib5KZnzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmbYsOea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmbYsOea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF42C2BBFC;
	Mon, 27 May 2024 19:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838333;
	bh=d7bwFjlGOP6nmMK40veE+dk1LZioRYUz/v9Q7q1X2bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmbYsOea4p0V2rhSIq74dx61cFkTa1F5HqSg7JgdTvl6Tmsm7oN6RupXVuKq3Kodq
	 buew1blnYOVt6BiK4dETWMwyX2PvVnRc7tQnDKGYkusCAA2V9SlrfkRSJkTHugbCuj
	 GIU3T8N58tTje2SweFjH4T0xVqiLqPGAUkaMXE5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 312/493] ipv6: sr: add missing seg6_local_exit
Date: Mon, 27 May 2024 20:55:14 +0200
Message-ID: <20240527185640.501229000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3321687e321307629c71b664225b861ebf3e5753 ]

Currently, we only call seg6_local_exit() in seg6_init() if
seg6_local_init() failed. But forgot to call it in seg6_exit().

Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 35508abd76f43..5423f1f2aa626 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -564,6 +564,7 @@ void seg6_exit(void)
 	seg6_hmac_exit();
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
+	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
 	unregister_pernet_subsys(&ip6_segments_ops);
-- 
2.43.0



