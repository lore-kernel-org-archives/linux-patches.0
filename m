Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5601830E0F2;
	Fri,  7 Aug 2026 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117209; cv=none; b=H4OiCOP4vP6GeJjo1vc0zzD0GVTkKcAECAkWDvDLSbcnNc3DAgNriGrSGH2v2GNh4ylaSMCvNUQOtJ87XjY7twEXJ2dyaedFJjpIsubERoMf3LiaUM+68DvC8zUbJWxnVtI4+/Zf8h3pwwbAnX16+rybIgVbrjsArn3fmArQLD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117209; c=relaxed/simple;
	bh=W4c3W8NEeApSgX6OWtr5GCZfiSr3nlClw+sAfg5+zuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0v/lvyouUNcJNKuYeTSy/glmfce0eiUEo3g/ldqhIKGesfxvLO8nYJYzM7lzAwzdBB1hL5/hDKGtILNf+AtiepuJbbDUOpWTVRE6rtVtXV8JKFtUTK970/hXEBssnRKt96knO5Npf3HZnLSy/1ksLR91yq7r99k2e/nvipKw50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxxgKRQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxxgKRQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A175B1F000E9;
	Fri,  7 Aug 2026 15:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117208;
	bh=PxOZZEPhvIsA1dDHezwOVwnB8xmM/11wC8MOstt2cdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxxgKRQ+opsueV7rQ+tEVQGKtE0tYtDBtBxeTvv6OFViPtLOiuh8uM59y/1q64Fo3
	 SpqT3BzORY6STmQXvoa5TuLNhu3kpQIH8biR4vhA8yn3GlalQroeDv9b7BMWlNXP6X
	 owOkR7SMkolr6/7ZmG7Kox8KtthpI0opvzdUX5w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.1 238/438] audit: fix potential use-after-free in audit_del_rule()
Date: Fri,  7 Aug 2026 16:37:14 +0200
Message-ID: <20260807143433.078006763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1045,6 +1045,10 @@ int audit_del_rule(struct audit_entry *e
 		goto out;
 	}
 
+	list_del_rcu(&e->list);
+	list_del(&e->rule.list);
+	synchronize_rcu();
+
 	if (e->rule.watch)
 		audit_remove_watch_rule(&e->rule);
 
@@ -1062,8 +1066,6 @@ int audit_del_rule(struct audit_entry *e
 		audit_signals--;
 #endif
 
-	list_del_rcu(&e->list);
-	list_del(&e->rule.list);
 	call_rcu(&e->rcu, audit_free_rule_rcu);
 
 out:


