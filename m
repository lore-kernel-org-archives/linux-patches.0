Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606933932EE;
	Fri,  7 Aug 2026 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114106; cv=none; b=Vo0w+x/n2fU80BwqdBN/3pixTHKhiAIFxqnhz0eETymCuSlHPU0fmtnrzHRxaYifVmau2nfxwZhTraOb3WiauRh5GcyikLnm2aEuEK5iWD0isYwaa3O+CpTFcWy1A4ej/uigpAgMkrMpHFxoEvWfCMcqTt5yz6ffyDmeqXqCB0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114106; c=relaxed/simple;
	bh=Ywxtm9x/9QN0Mom0CYLCacvxNdq23+9zUf1VoH637zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frRQKT4G6wDj9V6tw1804f7xldF9HgHmwLFJPEW8udy1E+1UO2tL4kZ5ZkRBy9lCwkWIGbXAhzetVDc6lfxViUZUhHYVr7X5vqtz2evlNCDdsHWEWsKM2+dr2APOXa0CBZycpyHKSzpTIb946cPmAB9qubaEe4uhNdoS/t4XuBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAy3adnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAy3adnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B18C1F00A3A;
	Fri,  7 Aug 2026 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114104;
	bh=llanDwbcArZ/7A4W4L5QZ+40+Fvaf7X3mN3OhuV+j6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAy3adntC6+/+097kAlZ5a5ath7HxhLNplIcwZkw9R8CVmrwgq5GOqxSIWZHPQ4U2
	 we85Dt7BP/CrcHcM0nMTwDPKghzzQ8PlNROS3oNCA5U5eUSRvSvj61ThcFteai/U4I
	 hrQi48jrypp2kbXKb3aqRLXFwl+bJs8MqfRNIEYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 146/337] audit: fix potential use-after-free in audit_del_rule()
Date: Fri,  7 Aug 2026 16:35:49 +0200
Message-ID: <20260807143421.707838061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -1047,6 +1047,10 @@ int audit_del_rule(struct audit_entry *e
 		goto out;
 	}
 
+	list_del_rcu(&e->list);
+	list_del(&e->rule.list);
+	synchronize_rcu();
+
 	if (e->rule.watch)
 		audit_remove_watch_rule(&e->rule);
 
@@ -1064,8 +1068,6 @@ int audit_del_rule(struct audit_entry *e
 		audit_signals--;
 #endif
 
-	list_del_rcu(&e->list);
-	list_del(&e->rule.list);
 	call_rcu(&e->rcu, audit_free_rule_rcu);
 
 out:


