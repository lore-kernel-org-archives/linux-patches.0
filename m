Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330D62BF3E2;
	Tue, 10 Mar 2026 11:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141100; cv=none; b=gMYd2VbLzYK/QuFc1LUkmb+JqRkutsF7ySACdzuHxW2Qsdr8bncD436yW9rnOCorT6idamlrwe1iETxdPVAv5IxWM9R8WGBcdFaLSi86pWe++LVcWkvoYLf+j1u+zPjS08f+wOHctVMdfhfD1z5F7zzTY2aFWjGHn8bPAg8CEVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141100; c=relaxed/simple;
	bh=Rm51h3w3hvHcKNm6ZudIyWNXGOz9Ke5cULf42DWchCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZngTEDAH7M8QLBYIriL/Zdjhnql8bTxe4lnACRAq/uETSXXmWdPhA06bkOyWas6RJJa32DGV2VPAb0THCh93LweaKxNRRT+dtjgMNtx19OSIj1TrIg1m5MTNMgDJEQ3WxbSqUlVr/CvyCalQhPnocvx8msvvx4PtbruNO/dJKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRrGvwAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRrGvwAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934ABC2BC86;
	Tue, 10 Mar 2026 11:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141100;
	bh=Rm51h3w3hvHcKNm6ZudIyWNXGOz9Ke5cULf42DWchCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRrGvwAzDChXpjRFOihLd2QIWgMHJWSltiPv0BjPj84+5ltiozSLmTzXSNBPbopOm
	 PPsTW6BaJ75Jbl7PkiOaAeJTu8sq1zh7GjEsqPFFjxcUMWERjDha1QoAer4Htl5uZJ
	 Wu8o7chBVmAhS/4cQvgaaQlB742FyPd/6b2UTvJAOHfr+S4o3/LZLaVmDBpQPqdubi
	 OAbGSpAFvZMB9FW3H8rtzov7isRiTBv7DqLCLkat9RsNPdGv6bnkgbtO1Wp59hLXBv
	 VSnLdzPcG+FrbWxiw3jwSUafH1CIYJDagiDjt63TAv7/2fV8ouzLDqablwrxy6thg0
	 oK+L6NRuaWACw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 101/311] namespace: fix proc mount iteration
Date: Tue, 10 Mar 2026 07:02:28 -0400
Message-ID: <d3250992892d0ebcce581a408deacc98ac8501a3.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

commit 4a403d7aa9074f527f064ef0806aaab38d14b07c upstream.

The m->index isn't updated when m->show() overflows and retains its
value before the current mount causing a restart to start at the same
value. If that happens in short order to due a quickly expanding mount
table this would cause the same mount to be shown again and again.

Ensure that *pos always equals the mount id of the mount that was
returned by start/next. On restart after overflow mnt_find_id_at(*pos)
finds the exact mount. This should avoid duplicates, avoid skips and
should handle concurrent modification just fine.

Cc: <stable@vger.kernel.org>
Fixed: 2eea9ce4310d8 ("mounts: keep list of mounts in an rbtree")
Link: https://patch.msgid.link/20260129-geleckt-treuhand-4bb940acacd9@brauner
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ecf0e72ce6cfd..9e5e3f1db02f9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1537,23 +1537,33 @@ static struct mount *mnt_find_id_at_reverse(struct mnt_namespace *ns, u64 mnt_id
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_mounts *p = m->private;
+	struct mount *mnt;
 
 	down_read(&namespace_sem);
 
-	return mnt_find_id_at(p->ns, *pos);
+	mnt = mnt_find_id_at(p->ns, *pos);
+	if (mnt)
+		*pos = mnt->mnt_id_unique;
+	return mnt;
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct mount *next = NULL, *mnt = v;
+	struct mount *mnt = v;
 	struct rb_node *node = rb_next(&mnt->mnt_node);
 
-	++*pos;
 	if (node) {
-		next = node_to_mount(node);
+		struct mount *next = node_to_mount(node);
 		*pos = next->mnt_id_unique;
+		return next;
 	}
-	return next;
+
+	/*
+	 * No more mounts. Set pos past current mount's ID so that if
+	 * iteration restarts, mnt_find_id_at() returns NULL.
+	 */
+	*pos = mnt->mnt_id_unique + 1;
+	return NULL;
 }
 
 static void m_stop(struct seq_file *m, void *v)
-- 
2.51.0

