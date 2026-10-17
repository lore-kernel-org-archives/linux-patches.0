Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058883B6BFE;
	Sat, 17 Oct 2026 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257147; cv=none; b=At0hVr1mEE24hV5pIiWVJA9EO083CKAJPQJ4TjV6xstG2Nnq0+VhzIwAwxZLMQ0jVspGL4elQQtkMhtQpLEHmXmvLjXhrepZMVfm/z2nYkypQDsZGAl2KXmpVLAvpGigrhRLUBhwRlv7DUYKr2pKdIkEu4PrRopvZnzHc8tGHTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257147; c=relaxed/simple;
	bh=JvffVdUaoTM+GnPxVQE6SVg6AiTgdGQNmxd3lPYqBNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTNGFKhYKktWFeMuMVitbn4UplbBzMfrBnyJlAq/wUAqh4M/aDokQ8d5yHYvwvOeGcVersM41BEVJgRb1ZrIumLRC/a8nENjcBH43mhsEs+OWOjK4Yze5pFhbLtT0Vi0lNXlWaDTsUP86fTfGthPaW5iU2jSvGnn6iNsPfhMo7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfVxHdhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfVxHdhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511081F000C4;
	Sat, 17 Oct 2026 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257145;
	bh=Z5E0ZJAfdpSECoM3fO/0wsUvF8krgaYp8IYDoIXbZ5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfVxHdhYQ5FiU+bA1wt47qSdONuWMmw/35lZ1DC1t3XmV8cn2NK7UCBS0aA+5t7/o
	 UQ6MIisr0t4+7YnG6bUFrz2BxHdRzxVuHzqawyRk+oxYyCRNdylD8mm6sbM2P1vEmN
	 SdDEzx2W45HxOgywM0Ux9cz3ZGrKtP8afiCdjDFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0465/1674] ipv4: do not warn on route notification size race
Date: Sat, 17 Oct 2026 17:45:37 +0200
Message-ID: <20261017160443.056180884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit e02a5b6588161673ef75a4bc5cdfb62bd493374d upstream.

Commit 680aea08e78c ("net: ipv4: Emit notification when fib hardware
flags are changed") added asynchronous route notifications for hardware
flag changes.

fib_alias_hw_flags_set() sizes the skb with fib_nlmsg_size() and later
fills it with fib_dump_info() while holding only RCU.  With nexthop
compatibility mode enabled, a concurrent replacement can grow the group
between these independent snapshots.  fib_dump_info() can then
legitimately return -EMSGSIZE, so the warning does not prove a sizing bug.

Remove the warning.  The existing error path still frees the skb and
reports the error to listeners.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261004082043.GB92032@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/b7e203fc5867651cb67ef84aa03e082f0f76008e.1791423190.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1084,8 +1084,6 @@ void fib_alias_hw_flags_set(struct net *
 
 	err = fib_dump_info(skb, 0, 0, RTM_NEWROUTE, fri, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


