Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D2F43E9FB;
	Mon, 17 Aug 2026 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976067; cv=none; b=uFqEkwdeQi0oA0uRouHdAyw7s8ifUpjJu/e2dqnCUzVjuzi4eStUdaBxhObkzFeSr2dxxcYTjl5Aij4nhWwkA1DxX5k1bXtfjJWxeIeXQZBxWTcBKOrv0VMGXc4AVZMFzXpu8oCgc54odXTgRzUQ4OrVMcRfjgM+M2X9IQFtAvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976067; c=relaxed/simple;
	bh=vWNXBubDNQQy8XBL8htrirMce1/obhR8FUOMqNv+jSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMTgLv5LpNkODDqgQgS5iWUZrQtWh5PetMZ6EcdJg7CZ3cGhiC0PP68WUAdoauh9frLD9iyUkGXiHKAX42xRSg1FMTVAb0GHfYv4hwEMzV1t0j1OvcFu6bql8iUUgoRkmxem/Y9sbkPbQZBlKAsXGt+6ppVd6RWsspzvqgIYQKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCBRHZ7E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCBRHZ7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1804C1F000E9;
	Mon, 17 Aug 2026 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976065;
	bh=PWF3UQpJs2UJzoKsVzwJaZHKxbUdyfQ6Msrmh28D+Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCBRHZ7EMlOtCv80DKItkNKg80PMIcrYCrrvf8RuM+PSCjq/cUk4c4I5nJDEv0YMk
	 kCFAvDpwmWnoOQo01co5WlciLJGdmq7yJnjEHBolbkkwXsmuQ0n7V+Qp2smSYG3H2a
	 KMQGdhGkhhVv9/kHWzcmUHTXqpR5x+0Foh3t5tRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 246/389] audit: fix potential use-after-free in audit_del_rule()
Date: Mon, 17 Aug 2026 15:31:25 +0200
Message-ID: <20260817132548.873305532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

commit 246df90b5f1a8a6e6abbd2f058b029558720adec upstream.

`audit_del_rule()` destroys `e->rule.exe` via `audit_remove_mark_rule()`
before unlinking the rule from RCU-visible filter lists and waiting for a
grace period. Concurrent readers in `audit_filter()` and
`audit_filter_rules()` still dereference `e->rule.exe`, while the fsnotify
mark can be freed on an independent lifetime path. This creates a
use-after-free window during rule deletion.

Fix this by unlinking the rule from the RCU-visible lists and invoking
`synchronize_rcu()` before calling `audit_remove_mark_rule()` (and other
rule removal helpers). This ensures that all existing RCU readers have
exited the critical section before any underlying resources are destroyed.

Cc: stable@vger.kernel.org
Fixes: 34d99af52ad4 ("audit: implement audit by executable")
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/auditfilter.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1036,6 +1036,10 @@ int audit_del_rule(struct audit_entry *e
 		goto out;
 	}
 
+	list_del_rcu(&e->list);
+	list_del(&e->rule.list);
+	synchronize_rcu();
+
 	if (e->rule.watch)
 		audit_remove_watch_rule(&e->rule);
 
@@ -1053,8 +1057,6 @@ int audit_del_rule(struct audit_entry *e
 		audit_signals--;
 #endif
 
-	list_del_rcu(&e->list);
-	list_del(&e->rule.list);
 	call_rcu(&e->rcu, audit_free_rule_rcu);
 
 out:


