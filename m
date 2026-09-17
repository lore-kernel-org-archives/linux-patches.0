Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CCD4848B1;
	Thu, 17 Sep 2026 18:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671073; cv=none; b=ibXZaR91HKkyHKga2nfnsnanXLJrMChrvR3zs2ZwFmru4g8RpR/k+Dy1goDtaFZTgMTwoN8btnIUwJkbNhA2aUiSXB0OHKo+taazh9rPPtrMJ64QR5671i3g9mtRUdB6UdN86PykSZlgZi/iwdwLfUgMYNyxqxdR+tL+LjLFyn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671073; c=relaxed/simple;
	bh=dHY0dn6BGSyg3fvFl5S7XZUqee7Xi2gNBtQgjJ9tbLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQzSfvLYy6Qp/Cm5tJfMuECPwzpqWNSAFVpYRGxcVqFDxZ9ZBx0Y0DSdMLWR96BQb9tL75laBEFNujN1q6EJywoqLFSVLiAk8bfjhOeUIxOlTg+TTvKdwzn635vsEYiQ1woGLChGs59CZ2gPrjcWa0NjPSpjea4yuhcuzCgLevQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOk6SrVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOk6SrVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35EC1F000FF;
	Thu, 17 Sep 2026 18:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671071;
	bh=WOFtXrY7AV85hg0oOy7j7zl9sGPBJp0JTdsGwMyWmOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOk6SrVrdaiGP7eXni43IUAYFdakruME0XjIQcX4onw1EN11NssTBxFcVCgqyxezh
	 iSAK7iPzGy1OFFOLqWHHrkUvtVclYGPSAyM+O5RVusYngZZqz8oYWHqqcHZVpwdiTw
	 73R1xyiAHJjK/qJcWMR2n2b0tKAlbM7eY6mjzp9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Zihan Xi <zihanx@nebusec.ai>,
	Petr Vorel <pvorel@suse.cz>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0858/1102] ipv4: fib: bound automatic table ID allocation
Date: Thu, 17 Sep 2026 16:13:21 +0100
Message-ID: <20260917151602.086012597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit efdfb1e27a3328085b79540dfe781d537b576ea1 upstream.

fib_empty_table() probes every table ID from 1 until it finds a
free one.  IPv4 tables are stored in a 256-bucket hash table, so a
dense set of IDs makes each probe walk a growing hash chain while
RTNL is held.

Automatic table assignment ("ip rule ... table 0") is an IPv4-only
legacy path.  Bound the automatically allocated ID to 4096 so the
RTNL hold stays bounded, without changing lookups of explicitly
specified table IDs.

This changes user-visible behavior.  A table-0 rule previously
received the lowest free ID in 1..RT_TABLE_MAX (0xFFFFFFFF).  After
this patch the search stops at 4096 and the rule add fails with
ENOBUFS if that range is fully occupied.  Explicit table IDs above
4096 remain usable.

The automatic path is unused in practice: it is IPv4-only, not
documented by ip-rule, uncovered by kernel selftests, and both
NetworkManager and systemd refuse table 0.

Fixes: b801f54917b7 ("[NET]: Increate RT_TABLE_MAX to 2^32")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Link: https://patch.msgid.link/6f2f2a7a136aee005512a2e1ac8ede62ac8c7bb6.1788258884.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_rules.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -212,6 +212,8 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_ma
 	return 1;
 }
 
+#define FIB_MAX_AUTO_TABLE_ID  4096
+
 static struct fib_table *fib_empty_table(struct net *net)
 {
 	u32 id = 1;
@@ -220,7 +222,7 @@ static struct fib_table *fib_empty_table
 		if (!fib_get_table(net, id))
 			return fib_new_table(net, id);
 
-		if (id++ == RT_TABLE_MAX)
+		if (id++ == FIB_MAX_AUTO_TABLE_ID)
 			break;
 	}
 	return NULL;


