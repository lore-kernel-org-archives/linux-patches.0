Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B4D35961;
	Thu, 13 Feb 2025 15:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460053; cv=none; b=e3+xDHFa8PnNTO8JtuLLrWUlVlt0Mr33qyCmobo7FUTQlP9Kup2uLXUyGp2+wxAxs/FC2NE6u6ZoQKlJ1h5cm7ni5vr0xGyoUaRQ4MB38CMu8mJbRW/OpgGp7Q4T8Huu3ZDOBcwEAvSILzzo3RVkHeryrk1wdRt8A1VkL2dwSko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460053; c=relaxed/simple;
	bh=MqP5DaJPsAYuAiUiibbqYpgAghgZhiYKWjK2B+z3JxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlVoO77JcfZULTeb3DpAn6JnHALc+cI2Es4T2I1j/KGkId4wjvsx4gmnpRDKwyCWRA9oG72Kwhy/9CJsNSNiqbtewPeD1qWBFX/f8/GwDNZRm5Y8SqGYQD1RzURX5W7QAw+tpC8QSjghMOGL5Tc9LECCs5fzNymsFZzA8K9NWMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Quy0nwcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Quy0nwcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25401C4CED1;
	Thu, 13 Feb 2025 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460053;
	bh=MqP5DaJPsAYuAiUiibbqYpgAghgZhiYKWjK2B+z3JxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Quy0nwcvr5phjTICwuSLl8dvzR0GYskMLwkRgMqyG0rhVmdp4blGoUv2yTreR59yg
	 XRoWyx8+jfOT5uNumKKsFvC/nITcDhZ7uqYpLR6TV8BMxXgUy4Jp2DqtJA/PIj0GSL
	 oIM2wSEbM4pjRaVPeL+UeRfy36dc7mCAai1MEaGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 443/443] fs: fix adding security options to statmount.mnt_opt
Date: Thu, 13 Feb 2025 15:30:08 +0100
Message-ID: <20250213142457.708518801@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5037,30 +5037,29 @@ static int statmount_mnt_opts(struct kst
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


