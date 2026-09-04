Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5182A3DB310;
	Fri,  4 Sep 2026 05:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500854; cv=none; b=k20o1nfwYU9Ng+5Ui35LiDc4jRycJuUpvwBk7QNDw3TgmX4oDnCNVzVoqebvshg5cZDK/tzJ/uaEwD131Uzg55X/qiNFUVqc67lu3Qzc8j7Vt5Dfx7yuM9Dvq8L4BJKo+MO6QkL0zhO2vIS8XXtqi+tg+gtiX9E0Y0HICw8DFE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500854; c=relaxed/simple;
	bh=v7qMEfO754VhaaBK0jsD6SGn/ONHW/jNFiAlIbaCMRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kC4Oz5lKS4s0ApvPES2BCLj5MHl3HWTVkkUwrnRErC/85JLBl28/1yn85mhSXQ7wY8Q4Ifaj9Ji3U2z7WegMUS/OXps/W3B7oECCEL9rs1kL+n24jdIyik2jt3F2gDmpMIzCkMngOrj+EaDRiBXDch8Rw/ElDewPB/27NFub6t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm5Nz2cu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm5Nz2cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CDE1F00A3D;
	Fri,  4 Sep 2026 05:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500853;
	bh=IzrV1EDU29ZkdgEWFPhBh0sHsObv+6qALHfwD5Hm3qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm5Nz2cuRSJCY+akjqy02hmCiBQuofX919NBDXAC7uGfpujBCk7ubTNc0OfDZ6IYe
	 u1E9LQr4FOjR4FT3ZyqQN9zvpWSPSerqVcfXoxd7LGkFa8rxgPCc/jVjXsW4tr9+ge
	 /n/E8dIOGMSRAUfvN9ehgTHsloOcvSOLxecFJ5Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 166/552] audit: avoid dropping live tree ref on fsnotify rule autoremove
Date: Fri,  4 Sep 2026 06:55:23 +0200
Message-ID: <20260904045752.790196077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


