Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FBA54707F;
	Thu, 17 Sep 2026 17:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666430; cv=none; b=ZDwCkYCcj4sy2ayxppP12UHYkiuMgdAWZaHC4IU2Ac375UqfhTbMeeMlwZ0CGqXt9gMKL89J4ZhGdsSIDx52uFbVSzmJAte6XI2OpLJcW6GZDU5AqrhDkHBQ+Y/uFHv0qwukOCbQc4IPWrws6PUDX/SyCmEBPJ7ePeJAlVVYNRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666430; c=relaxed/simple;
	bh=MLCZazHFKvVuyvsAR6AZGq4C+G5VKGVfKUJtYt7hYPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOTsBLHBh5kMum9FsHoKSp1hXHcHqbYw2J6uz9pZcpBXS44HM+T4Pq8y38yYrj3LlEAxYNWWOvykinZ8azmZODKRUBfDCSGTo+9I7Mmomlk5YWPiAiduPWS0RYzL8lBaLrpNywYBvPdcM7xOTjvH8MgqAlRvfyLUJMSzwIYL36I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp/k98Vk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp/k98Vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED3D1F000FF;
	Thu, 17 Sep 2026 17:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666429;
	bh=4QDewlBPIw/AvdabfEjwkpg+iGKXbd+6+EGz6kHHg3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vp/k98Vk9pXutqAPcP3bqaqu5yAn0eTDeutfAIAp5Tfvyyml3yDUoAaaqOqstRIQZ
	 6IL/BB5fcLieqA3611p1vpOABmDlqt8MIwdVXesFocYSlJRNORXJX6Qc3U5+6fKK2q
	 ISN9VFcPK7bDIiJ5PMaFkJojJ4l4UOaxv06g6AWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Zihan Xi <zihanx@nebusec.ai>,
	Petr Vorel <pvorel@suse.cz>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1035/1250] ipv4: fib: bound automatic table ID allocation
Date: Thu, 17 Sep 2026 16:13:50 +0100
Message-ID: <20260917151620.132297936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -214,6 +214,8 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_ma
 	return 1;
 }
 
+#define FIB_MAX_AUTO_TABLE_ID  4096
+
 static struct fib_table *fib_empty_table(struct net *net)
 {
 	u32 id = 1;
@@ -222,7 +224,7 @@ static struct fib_table *fib_empty_table
 		if (!fib_get_table(net, id))
 			return fib_new_table(net, id);
 
-		if (id++ == RT_TABLE_MAX)
+		if (id++ == FIB_MAX_AUTO_TABLE_ID)
 			break;
 	}
 	return NULL;


