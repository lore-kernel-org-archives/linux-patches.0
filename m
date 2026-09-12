Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C3D31F9B4;
	Sat, 12 Sep 2026 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232676; cv=none; b=hWOWGWeW2MM1G0dJ9/58fAUR0tX1CO0IO2ldE39WznGKOq5/Ch5T948/FclimiZcpwue0wUcgTKkEmqy5qTLOaYTgR737L+t3gwwacmpatjeqVmie6pqae5xd+9aUcHwkq3W8ith4FUcsl1MBpvqGP3voLNjQ+qig3enc4iUmW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232676; c=relaxed/simple;
	bh=aNEecgCX7Ws/2oFDbeZPb7s8XafJzM0yoMX4ia8JkIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldyMsdTDOiAZf1jyR3vcPj5gs+E1+HvbUdsptXPZ6517WHLLTCELGvFeM3dU9ayxwBKJhIT6Dgvz0Tvb9zlVLvgLevtW43SZeuodWFlo8T/7LndR/Eo/RQ0XcW9d650/1KiUXe1B64Q0hKI70XrzuL0cNQGQZHDNMzLpuMlhcOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxw05+UX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxw05+UX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5A51F000FF;
	Sat, 12 Sep 2026 17:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232673;
	bh=1UvIKTQ4sTlOEYOEPJm1kQnnFXZXwrZAzSUE9ycbMDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxw05+UXWsHDOvRkcCQEUtdaHMJ/j9O1eR/cizt5XGn11fqAUBTM6FioP0U4oBwtt
	 hDilO82w1/b0NsJ6ESnS6/DDRjh9oE+aSARMb+LttHEO7SsBgGjcy/AJqMnOK1UrLd
	 bfxJzjwSGFYrmJnxNxFecc5XsqWmOxdGtScFn5YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 058/935] audit: avoid dropping live tree ref on fsnotify rule autoremove
Date: Sat, 12 Sep 2026 08:51:28 +0200
Message-ID: <20260912065528.168137316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 783f0f0974c156aca630f4ffff248671082a098d upstream.

audit_del_rule() is used for both netlink deletion templates and internal
fsnotify autoremove.  The former passes a parsed template which owns a
temporary tree reference; the latter passes the installed entry itself.

The unconditional audit_put_tree() at the end of audit_del_rule() assumes
the template case.  For mixed AUDIT_DIR plus AUDIT_EXE rules, an fsnotify
autoremove event therefore drops the installed rule's live tree reference.
Repeating this across rules sharing the same tree can free the tree while
another rule still references it, and a later autoremove dereferences the
freed pathname while comparing rules.

Move the temporary-tree put to audit_rule_change(), the caller that owns
deletion templates.  Keep it in the AUDIT_DEL_RULE cleanup so both
successful deletion and -ENOENT still release the parser-owned tree.

Cc: stable@kernel.org
Fixes: 34d99af52ad4 ("audit: implement audit by executable")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Ricardo Robaina <rrobaina@redhat.com>
Tested-by: Ricardo Robaina <rrobaina@redhat.com>
[PM: dropped unnecessary comment for line length reasons]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/auditfilter.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1015,7 +1015,6 @@ static inline int audit_add_rule(struct
 int audit_del_rule(struct audit_entry *entry)
 {
 	struct audit_entry  *e;
-	struct audit_tree *tree = entry->rule.tree;
 	struct list_head *list;
 	int ret = 0;
 #ifdef CONFIG_AUDITSYSCALL
@@ -1063,9 +1062,6 @@ int audit_del_rule(struct audit_entry *e
 out:
 	mutex_unlock(&audit_filter_mutex);
 
-	if (tree)
-		audit_put_tree(tree);	/* that's the temporary one */
-
 	return ret;
 }
 
@@ -1150,6 +1146,8 @@ int audit_rule_change(int type, int seq,
 	}
 
 	if (err || type == AUDIT_DEL_RULE) {
+		if (type == AUDIT_DEL_RULE && entry->rule.tree)
+			audit_put_tree(entry->rule.tree);
 		if (entry->rule.exe)
 			audit_remove_mark(entry->rule.exe);
 		audit_free_rule(entry);


