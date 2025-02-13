Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5901662F1;
	Thu, 13 Feb 2025 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458502; cv=none; b=hIQtL29jYXro+4XTm/aHIhGERjJP/9w4ieVmI+9aAokIi2DdSNY086NvBw3kxql0rS/zNL7ChvxSoKCc59Toyzh0Q69t/19lJ7imzFJVL3h99s2TelvKUeMIIiY0tX4MDyFlMnlVnRN2/r736eTQsESKi6p/74Ud0qyGszGNuXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458502; c=relaxed/simple;
	bh=ld/5jicoHd2gxfrAGjp0Z/ZHLeDyANWsi7n4IbIH4M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfNI0b0eCSiIkwLb56wULl9AcFZtL9Nh8svi9vd3hiKBDAIFrXF+8Wjp6nPCp9jEReTQQbi+aO1vYcYt4QZZk8v5z61AIJOye3Qo7QssobGteHBDw/cPW021Nidkkkn0mx1UDo0ayGL3M+3K7simBLWM+ubp3uDvqeXi9SgdQMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unl9suud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unl9suud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A33C4CED1;
	Thu, 13 Feb 2025 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458502;
	bh=ld/5jicoHd2gxfrAGjp0Z/ZHLeDyANWsi7n4IbIH4M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unl9suudHn77Ev8DHXgl3YAe+fG5d9c+TuG/E2EyGZPIA11MaHaoE9cPJyhHsPDOF
	 N7M902QaFATjIG4FEljYGKetSPxIgrvJHj3PibFyfTw29i9e/TcBY+kzccmHBVIPXt
	 EPblf9fdF9gSaKPEC/IgFSAtFxlt6WyRuRuo1a80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 419/422] fs: fix adding security options to statmount.mnt_opt
Date: Thu, 13 Feb 2025 15:29:28 +0100
Message-ID: <20250213142452.734338880@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit 5eb987105357cb7cfa7cf3b1e2f66d5c0977e412 upstream.

Prepending security options was made conditional on sb->s_op->show_options,
but security options are independent of sb options.

Fixes: 056d33137bf9 ("fs: prepend statmount.mnt_opts string with security_sb_mnt_opts()")
Fixes: f9af549d1fd3 ("fs: export mount options via statmount()")
Cc: stable@vger.kernel.org # v6.11
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://lore.kernel.org/r/20250129151253.33241-1-mszeredi@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5020,30 +5020,29 @@ static int statmount_mnt_opts(struct kst
 {
 	struct vfsmount *mnt = s->mnt;
 	struct super_block *sb = mnt->mnt_sb;
+	size_t start = seq->count;
 	int err;
 
-	if (sb->s_op->show_options) {
-		size_t start = seq->count;
-
-		err = security_sb_show_options(seq, sb);
-		if (err)
-			return err;
+	err = security_sb_show_options(seq, sb);
+	if (err)
+		return err;
 
+	if (sb->s_op->show_options) {
 		err = sb->s_op->show_options(seq, mnt->mnt_root);
 		if (err)
 			return err;
+	}
 
-		if (unlikely(seq_has_overflowed(seq)))
-			return -EAGAIN;
+	if (unlikely(seq_has_overflowed(seq)))
+		return -EAGAIN;
 
-		if (seq->count == start)
-			return 0;
+	if (seq->count == start)
+		return 0;
 
-		/* skip leading comma */
-		memmove(seq->buf + start, seq->buf + start + 1,
-			seq->count - start - 1);
-		seq->count--;
-	}
+	/* skip leading comma */
+	memmove(seq->buf + start, seq->buf + start + 1,
+		seq->count - start - 1);
+	seq->count--;
 
 	return 0;
 }


