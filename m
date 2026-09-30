Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6124E324D;
	Wed, 30 Sep 2026 16:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785497; cv=none; b=luWT6krioELGslfiD87bcQs8nKZwOdVogpqZhbd4BaGkbum6XTXbOFuMJe2xzr25rpLGm0iioPsqWB1KoNI/bOpBT15ryL0vGljUXgVXY9OEoGedbgx+wev6uvIfzIiRkHeOFegq2WHsm5T9nGPqXa7NGdZ+gMAs6wOdGn8AyEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785497; c=relaxed/simple;
	bh=drPKblNJSqyxj/oyvoadYADbQGDZ6UNHZM5Fpim0P10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYCcLO3f/gmwGKiyKfLq7Ti5G076ZkeyEXzyMDSu4ABUlhuWZk18h4peMsaK09jDuOTBgn2qleUtgwT9W3eNqhbJe1fGsFc3x13Fdy+W9i3J3tkUR/gSwhpCOS2B2uf0vKOySOLkWqhn4uHZajNy/KqTlpkNShd6+B3Nto3Mjds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVHGID+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVHGID+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A205B1F00898;
	Wed, 30 Sep 2026 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785489;
	bh=q7RDHQ2rPM2U4XNM3q1UmUNdoCkFtedgQyZQZuL+rJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVHGID+cnFZ8FGEYbCGy47GUJWKCYJRtnN7cYtsfEPjm+HdlyfMWixyN6WxfSGp1A
	 wsDkQAtG1w519NUr8xBF/+DeUONo6nphA319ndlHx1rZV4ZpPrkAwEZzL4SmWsa7Lh
	 oqxx9lFJZ4q6K+QDYZZ3m6KuEg/O5Kh2RwDxIbko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Zihan Xi <zihanx@nebusec.ai>,
	Petr Vorel <pvorel@suse.cz>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 526/982] ipv4: fib: bound automatic table ID allocation
Date: Wed, 30 Sep 2026 17:21:02 +0200
Message-ID: <20260930152428.073296474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -203,6 +203,8 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_ma
 	return 1;
 }
 
+#define FIB_MAX_AUTO_TABLE_ID  4096
+
 static struct fib_table *fib_empty_table(struct net *net)
 {
 	u32 id = 1;
@@ -211,7 +213,7 @@ static struct fib_table *fib_empty_table
 		if (!fib_get_table(net, id))
 			return fib_new_table(net, id);
 
-		if (id++ == RT_TABLE_MAX)
+		if (id++ == FIB_MAX_AUTO_TABLE_ID)
 			break;
 	}
 	return NULL;


