Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D4143744F;
	Mon, 17 Aug 2026 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977354; cv=none; b=NAbrxoCnAsC/D4u7GuvuSXLFAXzMjUl/T09ucJ1KrBpUgk5h3PQGjBCH+BWRrbcAT7inqVs17gOqmEWxhgePkTEAAzQeaKUEvJo9tpkNAplCXqWvq6eWE8dCSPYBsMGvVa785gfTkZd8ej7ivk/z3Jl3Sm5I6XRIjvE8iQVX5OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977354; c=relaxed/simple;
	bh=RTumslFj9+P/YX52jSgd6xN5FWMyCbXOy5Bi7AfNIx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkMU8rivLRL1Mvv18hpByu9gdfkxS1apYDJjZ7o5VpnBlNYGnauhxt5y28Z7dbomfKaf/MDxBepqdTl2oPpGi8K9+PW4KCS61Bf890GBeHt5fn38J8DNVasxGT3vCpvPdiYThj1nRHXWvFu9bSa1T271JtMOyzqsz3RkSyagPRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+vgeYfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+vgeYfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9851F000E9;
	Mon, 17 Aug 2026 14:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977348;
	bh=G68uDxShVMvHJ+JxOHReoo3GzWuepLXI/OuGXSbbKpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+vgeYfGEkC6Phf8fAlC1spX+2f6a7GSrcMgSmUNvnrdMBZB9UA4VjmSR8ObsWBf2
	 6YcqKCz+ZRRKrmQ0rGKjlejeHrl7RFLeFVRjLKi9HNs6HTxbxu87U5Cu4QWI3dXeOl
	 LL+qsMBaFsPvU2Sj+ciqSxm4vtOXbFXZKSc3SgCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 297/456] audit: fix potential use-after-free in audit_del_rule()
Date: Mon, 17 Aug 2026 15:31:27 +0200
Message-ID: <20260817132551.456925779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


