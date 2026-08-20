Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432E4483BE6;
	Thu, 20 Aug 2026 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247712; cv=none; b=kqI/LONd1Qhu41XuHuP5xNpqmvmymNTwJWFCcayiReb4sAmHPRcdJhwXXh5gg2zO+tRUY5n3Ut86Wz0hGebngTUxxUhXjd1HL2UReiXqLEizbiZ1XT+Oung4cu2o5DW64od8sV0dGT5evLRHy1HkFCRm5xGHCZ/ymBCXqEWZBiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247712; c=relaxed/simple;
	bh=7UE+UJcPjWxO+kaTSSaxGmOqf4yr6leretzCfFUrQPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouzN7z/P19MT3EsGl25wXK0Rqd2EDLY6NOrSV+hoqp847SPBz5ZT4V8tliPMuXdQpGf+nGXOsJymFyCIRTJyhmSJicumOHkXcM9Pl8b2j0zGyvNIYTccW+v4di77U4Dr8ew8vGxMir29TI3KWNQoVXXymFjXalHWpQBt+YmfLiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJ+g6YXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJ+g6YXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4E91F000E9;
	Thu, 20 Aug 2026 17:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247711;
	bh=pkEtrB4mXGunEzTdhY16vTzPdbW6DdSmawwVNoSMvBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJ+g6YXyzGX9f2OCZ1UgRzEBsVf9o43SIMyJWgIR/HZ+UwpwNJVyv6QPh47GdTDPK
	 vvsEAalygWj+3wqNC7nlWho1tIhn+gyAjgmwsImZ/MJFEwo7Zeto3UonMxR396g8ma
	 lyq8ib446raJE2icdqjv2ROwAA6kaGaEi5xcrMHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/166] netfilter: ipset: fix list type element drift bug
Date: Thu, 20 Aug 2026 16:56:41 +0200
Message-ID: <20260820145215.442832241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4cbd69766b35a089664cadb1f613bb85f7ef77a9 ]

If list_set_uadd() calls list_set_replace() to swap an expired entry,
the element count remains the same, therefore the increment must be elided.

Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 9d6ab69ca1a37..e417ab37b69c7 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -301,9 +301,12 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	e->set = set;
 	INIT_LIST_HEAD(&e->list);
 	list_set_init_extensions(set, ext, e);
-	if (n)
+	if (n) {
 		list_set_replace(set, e, n);
-	else if (next)
+		return 0;
+	}
+
+	if (next)
 		list_add_tail_rcu(&e->list, &next->list);
 	else if (prev)
 		list_add_rcu(&e->list, &prev->list);
-- 
2.53.0



