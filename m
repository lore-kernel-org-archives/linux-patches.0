Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5333A502D76;
	Tue, 13 Oct 2026 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892962; cv=none; b=LptSNKSTw4yac3tCJH9CxLeg9sNq/lw0P3fndz4BPbvCkrBSw9NY3MhSS5Ge2h2DNhyK/Q/4Nw/rsOuzolD+sTBKabu2vIIE5iMxFC6EzQ4cXtl3go50Bu79tP/fGwO/QsA7+FCumetEGFrci1Js/Jji5bWn+P3DKYtiYvs2O6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892962; c=relaxed/simple;
	bh=7IvscZlgcTcd3yYlhM5SIFA0EzombU7MV6wS9K2q8nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu9bIr4KlV9q1sjazI+e1MO4XoO3ZS7fzXQQot3V6lA+JMkCTkvm3U6b+QTi4Fe9uEIuTciYfswnBjBtlGMdJsStTSu/Ac/DGJDABy7i1hV/h3YoNYybt1L0wbc5HCGFC9W5lVoTntMq9l7uebIbc3K5RlF2MAC/5CwDhKz9u0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKs12ksx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKs12ksx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAE31F00898;
	Tue, 13 Oct 2026 12:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892960;
	bh=81bxOyLDuSfE5VNIQ034eJBTpVjnG9Sahe5XGa8ZnS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKs12ksx0kPl9B5Oxiie139T9NVBHSYS3Z1nzjLfxbzOj8hFkeWThfO4aO77l+TDU
	 o09Ad9ZJSoNEAaQK8oeWbVnUKq8d4saHBHhaT83eAnBKMVuCgB53w5o6un2RigClpF
	 /2PlSSGpUavv0OyNuLSSG2mn1bu2z7UjdRvSSqDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 022/621] ipv6: do not warn on route notification size race
Date: Tue, 13 Oct 2026 13:30:17 +0200
Message-ID: <20261013112921.393074309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit c97426ec649d99596d8969e1a052c16b14b7b485 upstream.

fib6_info_hw_flags_set() sizes the skb with rt6_nlmsg_size() and later
fills it with rt6_fill_node().  With nexthop compatibility mode enabled,
a concurrent replacement can grow the group between these independent
snapshots.  rt6_fill_node() can then legitimately return -EMSGSIZE, so
the warning does not prove a sizing bug.

Remove the warning.  The existing error path still frees the skb and
reports the error to listeners.

Fixes: 907eea486888 ("net: ipv6: Emit notification when fib hardware flags are changed")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261007114003.GA1011260@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/4012604727e5ba80b69ccd4d08796511397ddaef.1791423190.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6468,8 +6468,6 @@ void fib6_info_hw_flags_set(struct net *
 	err = rt6_fill_node(net, skb, f6i, NULL, NULL, NULL, 0, RTM_NEWROUTE, 0,
 			    0, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


