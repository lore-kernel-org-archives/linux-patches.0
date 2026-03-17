Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E452116F6;
	Tue, 17 Mar 2026 17:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767481; cv=none; b=ZeSlh5IKwz/+jXoHgl7bdujDxLiZRqSsw+emtHXmqCgqGRzWgXZr2bbl6A7hN8Gk3v/0dCvNts7poaoq1BsVtoFvh++YY9WD+MJzaX9TvLuXWf9VSQ25kPKNCRmCCpFlnzfpR84SD11D/+hKsZ+fHbwTHr/WpBVmZTyhpu2UD8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767481; c=relaxed/simple;
	bh=ZQeVsJc2/d9shfvHAmH5lXz1r3vAt1/Sor1L91VHnDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmqnL0DKdRrYVz9itP6jhrJ7NJLG7g81HFzHI+SpaO+PxUFd7VlcVvIwofgECExtyazxBsQOygc2fOzcDxX1wD+3fF18g+mA0WoqEqSnwZXaomp/9qRV5/qxogULa9JWH0tcOEfaYPAjoOuDd0xPB68JkHenwMNUBiW3+TwuEW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ8dixGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ8dixGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47372C4CEF7;
	Tue, 17 Mar 2026 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767480;
	bh=ZQeVsJc2/d9shfvHAmH5lXz1r3vAt1/Sor1L91VHnDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZ8dixGHSb7n3AOG1Y556SzWT7c6JxcE04b2NsepZgA0amL9267W5A3sR1d20gZir
	 veyt4sW+BivReLUJhRIkpzuLymuXszwTwQwcp4eCim8Durou5ZxlK+qjdb53I9I+Ob
	 HTVHHQTgz+gHaAIWVhAUHZfR5ITvBH3EzPzh3zMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/333] neighbour: restore protocol != 0 check in pneigh update
Date: Tue, 17 Mar 2026 17:32:04 +0100
Message-ID: <20260317163002.893700727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit cbada1048847a348797aec63a1d8056621cbe653 ]

Prior to commit dc2a27e524ac ("neighbour: Update pneigh_entry in
pneigh_create()."), a pneigh's protocol was updated only when the
value of the NDA_PROTOCOL attribute was non-0. While moving the code,
that check was removed. This is a small change of user-visible
behavior, and inconsistent with the (non-proxy) neighbour behavior.

Fixes: dc2a27e524ac ("neighbour: Update pneigh_entry in pneigh_create().")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/38c61de1bb032871a886aff9b9b52fe1cdd4cada.1772894876.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index bddfa389effa7..6dab4d1c2263d 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -821,7 +821,8 @@ int pneigh_create(struct neigh_table *tbl, struct net *net,
 update:
 	WRITE_ONCE(n->flags, flags);
 	n->permanent = permanent;
-	WRITE_ONCE(n->protocol, protocol);
+	if (protocol)
+		WRITE_ONCE(n->protocol, protocol);
 out:
 	mutex_unlock(&tbl->phash_lock);
 	return err;
-- 
2.51.0



