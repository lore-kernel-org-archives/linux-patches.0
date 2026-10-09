Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5142207DF7;
	Fri,  9 Oct 2026 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555336; cv=none; b=I4/C0kMnO8M0ly0Xed5B8l71HaCie1goL8oo7prc8FPyG6gLt4hy3DkGqfJyEGTU4vuv8HegVjX/5wKKHKU6qtgN+H9g2MSHUXesKVwyviq4Tl1la4Vej8+Mo6W7w05fx5Gf4cJi150yUXCKvTGJe9URyFlnFCHSfiye2g9C0KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555336; c=relaxed/simple;
	bh=x0ImUGEmCrbELgIJ5P7h86LbSlHGrqzHTT+PspGsoWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ofuo97xb7Xdz+B4a7hZLuihwrZFkgntIZlWZ34pPE6nDPri8cPzOVAe3fh4ypaHSVwlMt64yEH0DJptTSRqGJeGuLwjv0KUJ/c3p+OCSHA3i9thh5iueZIF77mc2gkP/62R7a7o91CB63bgvJ6X/89xDSKggrGV3nmH3kbcFhRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYoWS8y8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYoWS8y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213B61F000FF;
	Fri,  9 Oct 2026 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555327;
	bh=97KGqzljKVsNzAtmWh58+Byvotc6a6I/dXYoGO5Hnq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYoWS8y8Fh36vHUT+a16qBTJWOsw/QBeYG7Fgz/3CEgpIUkHw2ZgTyfzCallbzYIe
	 lTvLeTR4M2X7TU+jdY0esnZLYsprPKh/EBOM/mGUPEYaXNxlRQcZ2JWrTqVxXqxDSN
	 7wVVPj7nvEXE5eI0DdnoSG0Y2I8JLwN5wA5RF36k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Bradley Morgan <brads@mainlining.org>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 020/403] audit: fix exe mark UAF in kill_rules()
Date: Fri,  9 Oct 2026 16:06:21 +0200
Message-ID: <20261009140952.590165001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit aa650d87a498844060eecb1d336f4d46f4d1b0b3 upstream.

kill_rules() removes mixed AUDIT_DIR and AUDIT_EXE rules when an audit
tree is pruned. It drops entry->rule.exe before removing the rule from
the RCU-visible filter lists.

After a rule has been installed with AUDIT_ADD_RULE, which requires
CAP_AUDIT_CONTROL, removing the watched directory can race with another
task that is still evaluating the rule. In that case, fsnotify can free
the executable mark before the reader reaches audit_mark_compare(),
causing a use-after-free.

KASAN reports:

    BUG: KASAN: slab-use-after-free in audit_mark_compare+0x8d/0xa0

Unlink the published rules from the RCU-visible lists and retain them
on tree->rules for cleanup. If any rule has an executable mark, wait for
a single RCU grace period before removing the marks and scheduling the
entries for freeing. Otherwise, call_rcu() already provides the required
deferred freeing without a synchronous wait.

Cc: stable@vger.kernel.org
Fixes: 34d99af52ad4 ("audit: implement audit by executable")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Ricardo Robaina <rrobaina@redhat.com>
Tested-by: Ricardo Robaina <rrobaina@redhat.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit_tree.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -545,22 +545,38 @@ static void kill_rules(struct audit_cont
 {
 	struct audit_krule *rule, *next;
 	struct audit_entry *entry;
+	bool need_sync = false;
 
 	list_for_each_entry_safe(rule, next, &tree->rules, rlist) {
 		entry = container_of(rule, struct audit_entry, rule);
 
-		list_del_init(&rule->rlist);
 		if (rule->tree) {
 			/* not a half-baked one */
 			audit_tree_log_remove_rule(context, rule);
-			if (entry->rule.exe)
-				audit_remove_mark(entry->rule.exe);
 			rule->tree = NULL;
 			list_del_rcu(&entry->list);
 			list_del(&entry->rule.list);
-			call_rcu(&entry->rcu, audit_free_rule_rcu);
+			if (entry->rule.exe)
+				need_sync = true;
+		} else {
+			list_del_init(&rule->rlist);
 		}
 	}
+
+	if (list_empty(&tree->rules))
+		return;
+
+	if (need_sync)
+		synchronize_rcu();
+
+	list_for_each_entry_safe(rule, next, &tree->rules, rlist) {
+		entry = container_of(rule, struct audit_entry, rule);
+
+		list_del_init(&rule->rlist);
+		if (entry->rule.exe)
+			audit_remove_mark(entry->rule.exe);
+		call_rcu(&entry->rcu, audit_free_rule_rcu);
+	}
 }
 
 /*


