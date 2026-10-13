Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624745038E5;
	Tue, 13 Oct 2026 12:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892959; cv=none; b=Jzj+F9mrWQ3dLD/jppL4LuG2+xEH2P6r4oYXmXlskp/tq6y7o+4zztC+REY2FvspOz/HR0EClhOn1J3Vr4R/hDmwOkAhpITw+yMw8wKgIz+7C+/fXRLvlwMgLzfVvHa0MC3yfp+z/V679Q+cZwaggrkm/TrrmWuHqQs9yKxxQpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892959; c=relaxed/simple;
	bh=AUxQhShP7B68Sgxdj9Z+OZjTKn1ZyvFOqQRhkW8SmCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1CY4809UgtqJX8RnnRqJ2UVVeyISubYNltvL+6q+qwEbGdqidN1fUHVF6gAG4dt2byT7f1QZQBEhsxvbaJyuzB0e2X0hG0I4YYCbqDWAUEOtatXVvsrcPll/KfcUjjvz2sauVN9HrtjfeMS9RQDmgXo/ZDGx8HkkVxOFGPvPNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YEvS25r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YEvS25r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D04B1F00893;
	Tue, 13 Oct 2026 12:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892958;
	bh=p50bq3bWUnuw5aZL9C2GO0VquJSDy3bqVvsHX1XVQak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YEvS25rVnJFwk5bT2Z7uMAP37oWiPu9mWUifkJSV321ct+kzemt+uk2kUrdwaX6v
	 qnN9NebZizOTShJeCo15HTkg9eYqDrefPVIv+ATWib/6lT5k6iaesgjyKHrdlAeVmR
	 EM9CVra7e3L+Nc4y9UZ/8iU8cLnp+AGI3vTVLUlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 021/621] ipv4: do not warn on route notification size race
Date: Tue, 13 Oct 2026 13:30:16 +0200
Message-ID: <20261013112921.369719616@linuxfoundation.org>
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
@@ -1079,8 +1079,6 @@ void fib_alias_hw_flags_set(struct net *
 
 	err = fib_dump_info(skb, 0, 0, RTM_NEWROUTE, fri, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


