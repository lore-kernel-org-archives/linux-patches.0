Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834F246F4B7;
	Tue, 21 Jul 2026 17:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656788; cv=none; b=ZW5+YgnTHlUHspxkn5m2E0lTuZnPtYFuZTFtuTLmKxe4o264PhqrWs21nIKAhfQKuuY6LTcqbO9VHlvS+qZ/HwVfsekIVef6aX3evPanNKnqrpkoJilD4n/DWR6YIeE4gN1Dy3+GQ9zjdSJBWstR5Gdc18B5T/uvnCK8v3cJUHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656788; c=relaxed/simple;
	bh=kBlGhZpRRzRmkHeJW2X8HgXKiEM0NiA3HSyWExZXYKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CClIqUJx86LJIp3vk3t2b2itR0CTlkMeWI4CPQQGezeb2PhgUeWfZnIW8vYlByQGEIx8ZOVgX+7VpBO/u2QBc8WzZooAxctuS6CRrqEe+mBDhtKU8Sf3BjLwGXteAMb9RlxaeXNtP7/1nEDLenA59qxVHIewszWQTvEOjfsxGA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKT7HNQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKT7HNQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E940F1F00A3D;
	Tue, 21 Jul 2026 17:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656787;
	bh=ZcmJumk6ymJOaoxm7PRdZShvptl+UhBpFwp3SAxm834=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKT7HNQiGSeTaQvIz7aENMK8AI4kbQX2Ftugja/O4qXo6r/TiELiKG3VT1ktWd8PR
	 tPw1TjpM65yws28zHU/ZLXqA64DOL9vu6iqgjAWhswajRFbz+mjFLVzV8yWTL+wr6N
	 A1ZvKGCPxwjNBwdHKLgTBbVqAeS54gtAGSxkQRNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0512/1611] net/sched: sch_dualpi2: Add missing module alias
Date: Tue, 21 Jul 2026 17:10:28 +0200
Message-ID: <20260721152526.863087335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit ee1ba0add3fbd5a28fa5423be373acd147f1e344 ]

When a qdisc is added by name, the kernel tries to autoload its module
via request_qdisc_module(), which calls:

request_module(NET_SCH_ALIAS_PREFIX "%s", name);

i.e. it asks modprobe to resolve the "net-sch-<kind>" alias (e.g.
"net-sch-dualpi2") rather than the module's file name. Since dualpi2
was shipped without this alias, the autoload fails:

tc qdisc add dev lo root handle 1: dualpi2
Error: Specified qdisc kind is unknown.

Fix this by adding the missing alias so the qdisc is autoloaded on demand
like the others.

Fixes: 320d031ad6e4 ("sched: Struct definition and parsing of dualpi2 qdisc")
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://patch.msgid.link/20260611205849.3287640-1-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dualpi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
index b4a57e1d9513a6..02d3c6c45aa3f7 100644
--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -1211,6 +1211,7 @@ static struct Qdisc_ops dualpi2_qdisc_ops __read_mostly = {
 	.dump_stats	= dualpi2_dump_stats,
 	.owner		= THIS_MODULE,
 };
+MODULE_ALIAS_NET_SCH("dualpi2");
 
 static int __init dualpi2_module_init(void)
 {
-- 
2.53.0



