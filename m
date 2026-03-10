Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2DD387361;
	Tue, 10 Mar 2026 11:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142005; cv=none; b=p5A2sB6KYc8MCQTUnObIubYo8FubQQonPrOkVoi+zPfQFQAyMgkBiS01zWtT3Ng2maJx8K6QGLF3HuwjiR9OC2BILCRCd77NGkJ9D/19/Tz4rvWTBKXxI5I64iimX37O+Wxxjj+zWWPa42Mq9WLvmy2HqEAd8jX2Xbvg/yITPZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142005; c=relaxed/simple;
	bh=94kREnGIarE3KrddOWIco9VSQcY6P4Zmcy7zvyRH+LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoTGsIAAAbOt9GF3C0ZxAAlAj3q/uzpPm0dBLMBYqqA+6EIrlXErgc+NsMpatY9y3IE6xrDb5jquYERGm1ENjcuv2U+tpOexKpGPNTOumycSP5gjPcmtRZ7/2doj6trOg1C92ifUyTsuhu7EQeDcSVRB70tJT0VIJuMzLcmtl0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsZcBQCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsZcBQCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEEAC19423;
	Tue, 10 Mar 2026 11:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142005;
	bh=94kREnGIarE3KrddOWIco9VSQcY6P4Zmcy7zvyRH+LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsZcBQCZyYf1KVTkYXonlC4V2U77r597ho/S2yCTpg0JtnNSfXgoE1X53ii9I+1sL
	 oI44ZoSdTfKdl3hoCm4fL+OyJPjWYu04yh/thqCvqeAJSfo4zHzyBUzD2Xm6tgxepj
	 HTP8836Ii836q/2sZD9ukb1ft9XFuSPqCWmBbF3T+iNhfIQ9Ex0Y1tNKmDPpMhLa3b
	 ojdsjr0ErWVTlnnl3onxXcLFbZ3j9JE81+HqU+mtYCusHpu9I4PZMiDhs35coXmxzB
	 AHQ0hZijfDX8BOzxruK0XHJj+UgR3oHInW4I83Ck5a6pEMxqsMr+oPNFwBajfGzLlc
	 AhmB4QhDSk0gQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 131/314] namespace: fix proc mount iteration
Date: Tue, 10 Mar 2026 07:16:30 -0400
Message-ID: <99b33236e808f4d18152f0369acb80ef0b973687.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index b312905c2be5b..8531b8deee416 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1531,23 +1531,33 @@ static struct mount *mnt_find_id_at_reverse(struct mnt_namespace *ns, u64 mnt_id
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

