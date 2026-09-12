Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC692E92BA;
	Sat, 12 Sep 2026 19:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241041; cv=none; b=bqU1KOK9/ig/+b0aKX+SUQ5G732e6auW33uXo68nTMMeAmF1EgcxMhibLHcaebbTNRZgC9uSZMayk/Yn6Znihwwq5gmQYHkoJh/UUYPgQhjpklkoMWdhENQkNuTuPMN0+3JHITBHgpV+CJypDN8zZYt+gtZmjiH2hCb09ZgvahM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241041; c=relaxed/simple;
	bh=uf0vaOzXSeKUcWak26xiITrsyu3MUpGPixjsJKtcLgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BjEgqoth3ZMisbPAT3DA0Gxrv+pUeX+QyrkEjQNt//qa/65VxozA59UEr5fYqueZmKA/KPssEMK6BamM3ZzQRDGU1DLj2GntbPikAgEaWbRZChfYefVF2WpbuSHTjOFKJB49MG5+g3iDFzUomUoDAGv56ulp9zNNsTDNPU5/edw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJfqbQ8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJfqbQ8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BE91F000FF;
	Sat, 12 Sep 2026 19:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241039;
	bh=9IetKuelEXxY8iL2zwaC5PgJlr3vbFDFEXu+Bm8aBa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJfqbQ8f+31cd+E4AYnyqEpEb9i3avqC8Sdn1zsP9PH5ahsBcfPjV9gWk3IdyvVmN
	 /ZXE4H6S4w0iUIccLvgQ3DwSDQVPg7EdcwPc/hBbo/VWwioZ6SxTBy4X3aMRtXug5U
	 lcKNBsiKzdR4iJz9BwcFLunFfAYpMwR2NmH/YbDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 052/798] audit: avoid dropping live tree ref on fsnotify rule autoremove
Date: Sat, 12 Sep 2026 08:54:40 +0200
Message-ID: <20260912065518.155965352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


