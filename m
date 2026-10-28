Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210874;
	b=xfGJ+iEgsZKQYweZV928c4gBOXnyiG/YdqqVL8XhB+/AxsSeV+BDzEk4O2oH4ZisBv+h
	 uD7mG9T1Yu3HGUpfJG/tWPPyZwZ+rRE3RCmDDTWr+jJv2K6QBWKYuitEj8Dl8E9iwPZ15
	 ckc7RZrWUkM998WPPqKbGTRyiDaGAksuBB+UdwCb3rIBaSgZROANP+0LQ+nZT5prIBARw
	 VzwgrzN0m6IVHNqmjxbeTtVBQECLgBr7KAVeYSI31YDQ9d8uoXnxDPRY1V/5plcFzR0J4
	 bVX3qBla8eAgWzfs0HZSe89qkSVQJIqqN6rRjE+Wqe5W1VVez8CFXgCnkdP29G3z4Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NdXuLfgmxiiBv4ZT4ABnwk58XteBr658rkdhE7Tyd+0=;
	b=h4gtdkQsC98z8cE1sx/Uup7iYAHIqN3aIQuTnZfiwSu5SXrEhmht36X7y8ZyxJe762Ly
	 ITtTAYLjXrpayCW+aefiOgeLgdUYG0u0CIpbj5Odn8o7MgKFFhVqmxgMX0qC4RoRiA/OU
	 EXrsLJz/C2qqejQBWxqQBBHOLwCwOS/DHD+Qv41BYuoYWFVA55tmvr2CMl9trlw7H78uZ
	 R5O2jpDJJuOeTtdYcaiWSaDERg5VSqi76bhE9LBDOuEnP0+YnrCeHfbhILkgqjY2DoPbj
	 GWi7OBv8beXaSeo67wrQnwwvmiWAVBaXlIKdI/aIlwdW+9+SA3OhHjsXKP2vWIoqRCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJCzzqhW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB17E606A32C;
	Wed, 28 Oct 2026 18:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJCzzqhW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385011F01825;
	Wed, 28 Oct 2026 18:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210873;
	bh=NdXuLfgmxiiBv4ZT4ABnwk58XteBr658rkdhE7Tyd+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJCzzqhWptxKnP8OcglwfQatecRVZxdE6c6uYIrzR9b0ox0n4A/zMXu/fegyZ0inP
	 42+kpYP+RgHSzb9FuMW++Lxv/Q2p9kEQOjItwulYszgV5XedV61JCgagymu1iCbiLA
	 qNkbSIuwa6Iyd/Tk3W3V9dnxSQMQjgmWHcJ5iqLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Bradley Morgan <brads@mainlining.org>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 135/571] audit: fix exe mark UAF in kill_rules()
Date: Wed, 28 Oct 2026 17:54:42 +0100
Message-ID: <20261028170011.220881175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -543,22 +543,38 @@ static void kill_rules(struct audit_cont
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


