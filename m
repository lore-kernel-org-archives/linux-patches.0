Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C829233F59A;
	Sat, 12 Sep 2026 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220163; cv=none; b=SgIVFMB0ha1ske3CnUdGhAxmaZBYzF4j7Y3HFxuDwHdv9WKoilytKB33iJKF+hwo8Yyjxnbn8ZEokP09vbpF1cAfy2fm+w4c2mPk7SBhIFAqwzab9/xOYDw0Bo1HlPM4y5ynkSCV0tWS9BtoTnEfUL37KrQARIkDZJ1atgQg04Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220163; c=relaxed/simple;
	bh=F60ZGcBi4SyhRuTYBSdXOmW/Qkew7Iz07HJtguX1HKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uM2tN3ArM9w0bWOg9JTkxz3rU77jkwAzCptSLR1MwWLpCdIB5DkNyb8MOLP5QM6PRcpvR1FU3ZiSbOfw6phBWtkdwCdvTDoZMTnqmdxm7RUgAurx4Zo/cLL8UQ9rtGfyF5VnxF5ri4eG83HXoZI60IXmFZ1Zy4U8PrFtnl+JiEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCI4xvHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCI4xvHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FE01F000FF;
	Sat, 12 Sep 2026 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220162;
	bh=0w92eypYXU9T/aEyaqh3/3jAtBbzHvQeYJ84TBN6als=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCI4xvHr1rEu3G7Z4XuLd2Q80FjCbEZxdMyz/IHzEHXxaa1GId2n8cB84XFPPgpol
	 lGsz0Ko1mXE0wEvrJg8M5fPfbG+Kc+ibTm1OgHvXjgO1WBb8CbE1Z2AE5Ww0+FMrH+
	 9lfYfYA2spjD1UlmKq2n0pTEcrZlFxD5TKdbmeaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 0078/1424] audit: avoid dropping live tree ref on fsnotify rule autoremove
Date: Sat, 12 Sep 2026 08:41:50 +0200
Message-ID: <20260912065609.053900422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1025,7 +1025,6 @@ static inline int audit_add_rule(struct
 int audit_del_rule(struct audit_entry *entry)
 {
 	struct audit_entry  *e;
-	struct audit_tree *tree = entry->rule.tree;
 	struct list_head *list;
 	int ret = 0;
 #ifdef CONFIG_AUDITSYSCALL
@@ -1073,9 +1072,6 @@ int audit_del_rule(struct audit_entry *e
 out:
 	mutex_unlock(&audit_filter_mutex);
 
-	if (tree)
-		audit_put_tree(tree);	/* that's the temporary one */
-
 	return ret;
 }
 
@@ -1160,6 +1156,8 @@ int audit_rule_change(int type, int seq,
 	}
 
 	if (err || type == AUDIT_DEL_RULE) {
+		if (type == AUDIT_DEL_RULE && entry->rule.tree)
+			audit_put_tree(entry->rule.tree);
 		if (entry->rule.exe)
 			audit_remove_mark(entry->rule.exe);
 		audit_free_rule(entry);


