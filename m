Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBA54432FE;
	Mon, 17 Aug 2026 15:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979924; cv=none; b=WffO2vmOF5xcCJus9TYVK4hMTPmVrqYnVhysSa97C4IuVaOYIAmQTyP2svsEN+/KvHL5vlAfVZdFy4glARNgfz9qL4SPCJaJS02S5YRndlmRbUXPGp4DB7vSeckOvTGM9bJxaU/6DVqNQDLHZVNqiuW3hE5lFd9K75P9MWEs2iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979924; c=relaxed/simple;
	bh=w9s1tbEc4EMCKFSI0+b5E5QTWfbGv3YrjRnxaybFOU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbqTJ9pkawWPyidpMckyDwmmUwdGa5f+pN/UxmLBKXi4Ngu0RO53Nc8wR1uuTEF4HmZeR7QE1c1B0J8hgDNu+MBbeGHteiDLIFXXhBRUeATUc1nJlTQ6j8D7aq+Pkiegs9TL6ACg1ABhz4L1EjzvKtFB4G5g9aOTikRWrfq7744=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHjGrOjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHjGrOjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B2C1F000E9;
	Mon, 17 Aug 2026 15:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979922;
	bh=UAFjt0nXn4qZyBzxoycgBo2Byi662QWmKaqx3nCAifE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHjGrOjCTd+Ov+5et18QDU8MMQIlafHjQdCVLUomEef8kq/AxSVf8tx9QluxrsM4N
	 cohZF1ZrwoY04bePjEy7bpwvov2qmie+OrXxoqE2EUPfotOtCTbKdQuRB5ktCMvjmH
	 ZGFCTaCC0Q9fYIA2OoMe4PrAb+Ox5VddsXLM27sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 393/609] audit: fix potential use-after-free in audit_del_rule()
Date: Mon, 17 Aug 2026 15:31:29 +0200
Message-ID: <20260817132557.385910978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


