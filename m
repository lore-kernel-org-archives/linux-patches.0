Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47813C10A7;
	Tue, 21 Jul 2026 21:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669657; cv=none; b=dIKksvEwRnOp+KMVaubDQWnVTYRmZizie10vqcd9btMKVOHLmmHC7AKbs5UDKE4z+yMuNIVVbnSSdmPNYjbIbBI5FgFP3U+A47daZxpzc1k19wNHObc4UTS8Aja0923Iw5rmmbPdcs0aT2iBBZJ97opLreXkhYKBzCx8EuvhZig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669657; c=relaxed/simple;
	bh=n19h9IfIkQW9nLFNfF9Z6B9UBa6aaT0eVIYOdWcejy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT9sY0BHGoldigQkFj1g0UpSS/XXfebpFxWQNQ0vPD7e3ogtH7JikY1/EKgscDHXMDUkHnAi+efJfldUPu1nipmRlYL0kyoZ5i/C19GgMG2VyXChNNhIF4w8LdrrzyTY6C01Mp9HuRFTaSaTZmbkx0LWcukRwgf/ub7yqaSLHM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3fKogO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3fKogO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4D11F00A3A;
	Tue, 21 Jul 2026 21:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669653;
	bh=4QAVhoNDfkuz9JOC6M8hwQOb3Z8CmfXkTWwVvKhnr2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3fKogO5tknUwhhaWZgdkYZ/Jgp/QqNzjDi1MAUrRysoPBz7RshIK/chDeClPQCpq
	 47mfeHTSoU+r4TIfILaPKfrVL0REnh+KV9vy8TLZwGAugWoAwYd+XSrvz+PXFP5cjR
	 VIVV9Lmaa6bzec8+zQgzjoK1n1slfBN207cbkV5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0636/1067] ipv6: fix error handling in disable_ipv6 sysctl
Date: Tue, 21 Jul 2026 17:20:37 +0200
Message-ID: <20260721152438.822620821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit c779441e5070e2268bdfe77f6e2e0de926c431e3 ]

When writing to the disable_ipv6 sysctl, if proc_dointvec() fails to
parse the input, it returns a negative error code. The current
implementation is overwriting that error for write operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: 56d417b12e57 ("IPv6: Add 'autoconf' and 'disable_ipv6' module parameters")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 56f3af49f123b2..2ae1548f58737d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6376,6 +6376,8 @@ static int addrconf_sysctl_disable(struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_disable_ipv6(ctl, valp, val);
-- 
2.53.0



