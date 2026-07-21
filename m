Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635B447255B;
	Tue, 21 Jul 2026 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656696; cv=none; b=DG3QYB3gVXgVHTCErPCjEcp9VmECobyfAZmMjeEjhNxs2G6bpVmPaY2DvwlgC3K19cQFsz5/g/LUue1Ao3LdzRrc40LBHifdtoYyF91r/9FiiA159ZkeEAMHjww8cCp3sISE/UvzSr3ZMVwSmSnkY1xhNZEIEDQ6jllnMXvPgIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656696; c=relaxed/simple;
	bh=DMFkwvck/M8AgTn09rTxydGetdQVgzUVh80TeyFpaMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqQDyH4aZJ5HidAvy771vPLtRotAVgwedObiFSeRWo8sChcFa7F+KoXFcm3anFe6iK62WbCEz10vQ16C6YbBWbATjUmYyt/yeVVCX2egOZcmbSJRQZTgdo7VCrCvOhyKPjERheRT+DBb6L+QqQPOwR0hIlTW3DAuNjm6DSdT034=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jOegUux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jOegUux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256561F00A3D;
	Tue, 21 Jul 2026 17:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656689;
	bh=tQw2Idic92ulHX3uOR/OdsyW6DD+kDyBpg6OhBU/mBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jOegUuxq95GCCvLJTT39Gxqbk8RmRQSPBcENuYFhCsGbTwx/owgR18SdfKpCkloE
	 tAcHbteC5TWLB2odQijhklJ204tnLYlbUJluJ+8wb6ySdz8sFtkHH1w0XZYoauK5/j
	 7mfcaSwiLs3IX4gl4JovgMSAeqRqqlW/jzs8FLrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0483/1611] net: fib_rules: Dont dump dying fib_rule in fib_rules_dump().
Date: Tue, 21 Jul 2026 17:09:59 +0200
Message-ID: <20260721152526.196712750@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 2821e85c058f81c9948a2fb1a634f7b47457d51c ]

rocker_router_fib_event() calls fib_rule_get() during RCU dump.

If the fib_rule is dying, refcount_inc() will complain about it.

Let's call refcount_inc_not_zero() in fib_rules_dump().

Fixes: 5d7bfd141924 ("ipv4: fib_rules: Dump FIB rules when registering FIB notifier")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260610061744.2030996-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/fib_rules.h | 5 +++++
 net/core/fib_rules.c    | 6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 6e68e359ad18c2..7dee0ae616e322 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -111,6 +111,11 @@ static inline void fib_rule_get(struct fib_rule *rule)
 	refcount_inc(&rule->refcnt);
 }
 
+static inline bool fib_rule_get_safe(struct fib_rule *rule)
+{
+	return refcount_inc_not_zero(&rule->refcnt);
+}
+
 static inline void fib_rule_put(struct fib_rule *rule)
 {
 	if (refcount_dec_and_test(&rule->refcnt))
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 8ca634964e363c..cf374c20873258 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -349,7 +349,7 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 
 		if (err != -EAGAIN) {
 			if ((arg->flags & FIB_LOOKUP_NOREF) ||
-			    likely(refcount_inc_not_zero(&rule->refcnt))) {
+			    likely(fib_rule_get_safe(rule))) {
 				arg->rule = rule;
 				goto out;
 			}
@@ -410,8 +410,12 @@ int fib_rules_dump(struct net *net, struct notifier_block *nb, int family,
 	if (!ops)
 		return -EAFNOSUPPORT;
 	list_for_each_entry_rcu(rule, &ops->rules_list, list) {
+		if (!fib_rule_get_safe(rule))
+			continue;
+
 		err = call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD,
 					     rule, family, extack);
+		fib_rule_put(rule);
 		if (err)
 			break;
 	}
-- 
2.53.0



