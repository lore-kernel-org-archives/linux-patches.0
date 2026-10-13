Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0027139D3D0;
	Tue, 13 Oct 2026 12:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895686; cv=none; b=EVuYe60gS7GbUQrryCj52ICv+j13mTqEjyxWVLbUrWtRIZ3oXxo1EcJ10lwo1k3QCp94B1I5MsJd/OM4imlpKMg+D4s07o0t2Ku4+MM8sqSV8gZVkAlrF4WyjNO6soL2rFXGHsytzp+vVolK2ARpo8Q3urSDn8q50X6QTVxjres=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895686; c=relaxed/simple;
	bh=tfEysrGUlX5Q/VYAsBfL0Af9ISSpeA2Q5Eg0PXp5md4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGX5PUiDVHg0cFThjtPKc1E+y6G1PHFM3sHG4Iq6CsvA9/jCRXVHWaLSdgNt6XJh/QeosbKNb9H5wiQBbGUFXdw1xgER4mvEX79njoIFpnVysBX/2dlc6pAoPzcWt/i+WYEuYJ38vWpVPZqkZ/siIzXfHcKbz+T4N5bg8kkNEik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dc7X337W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dc7X337W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8CA1F000FF;
	Tue, 13 Oct 2026 12:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895684;
	bh=TJMX+kcJLMe+nwZZ3rA92bbw0RhpQlbiz5ld7IHsxa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dc7X337WInSZE5S009lAsK3VV1EiZVgV3iZf6+0uDImAGA5yUQk848bhUlvgUF6PK
	 mHY50C7ThJB3hO78ip9raUXvjmFn4se6fUlMKYQ+kXz70/UQpHNIXPKhC1QqPjoUKK
	 rLOxVXiBHcnDwHYJjCoAa1ZOPqM10aNwcUvgJWuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 357/497] ipv4: do not warn on route notification size race
Date: Tue, 13 Oct 2026 13:38:44 +0200
Message-ID: <20261013112916.379865570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1085,8 +1085,6 @@ void fib_alias_hw_flags_set(struct net *
 
 	err = fib_dump_info(skb, 0, 0, RTM_NEWROUTE, fri, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


