Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EB147142F;
	Tue, 21 Jul 2026 18:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659688; cv=none; b=QbAOgst94/RQ24FU8Qjq6vh+x3BEY3Ipz+66ppEwEAx+PU5jzbLqtJaUjawQYjB6FKa7mvm5g3zXNo2wiOYKJ1tRjSvlozRK/vcccrvKgEKcSBwejzy092LyigI1R6JGQU1aWX2zb8UQORvTo+lRw80QFgzd3jONyigQg3nuI9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659688; c=relaxed/simple;
	bh=XXcyfinz+d4PUe3E63B3VVT27a3YV365ipR3z+0ay4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsOs7F91gcZc5+pcydGs/VrKn9aEf6kGQ7y+RIaOo3fxWvZbr4NQQTdIQ0nX9PTxgpRXD7jkCFoOoitqYTe0Adi222td43933PY1EAK7CNkCy6yDs9Js3Vui5cP1vn7Jo9wCQ6p29yS4RuoaVOY7U0qzK3uFJsx+tXGBt/kJqso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yACHtY+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yACHtY+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10D31F00A3A;
	Tue, 21 Jul 2026 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659685;
	bh=PUF0OI6BspUpYsjz4jmW3Blo3wbQHif/sTSavWZCD94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yACHtY+Zj5JbjMHUhh9WMLbQ6ffq2/Q9fdwEaUDkBOojY3Lx8kY4QSUajSieAHA+V
	 ZDce5gUEsqdfQJ6HWhUZ80Fxv88i8Dz9BqLd6G84tmPjsQT05zBjT613ZIR8VHxYKy
	 35Cls6dFsdwIr9mu5jX2aec5rE8lp602bZY5uUGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1579/1611] functionfs: dont abuse ffs_data_closed() on fs shutdown
Date: Tue, 21 Jul 2026 17:28:15 +0200
Message-ID: <20260721152550.988020930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit fcb8985143540cbcb8e91c0ea8b7fb5d37c88177 ]

ffs_data_closed() has a seriously confusing logics in it: in addition
to the normal "decrement a counter and do some work if it hits zero"
there's "... and if it has somehow become negative, do that" bit.

It's not a race, despite smelling rather fishy.  What really happens
is that in addition to "call that on close of files there, to match
the increments of counter on opens" there's one call in ->kill_sb().
Counter starts at 0 and never goes negative over the lifetime of
filesystem (or we have much worse problems everywhere - ->release()
call of some file somehow unpaired with successful ->open() of the
same).  At the filesystem shutdown it will be 0 or, again, we have
much worse problems - filesystem instance destroyed with files on it
still open.  In other words, at that call and at that call alone
the decrement would go from 0 to -1, hitting that chunk (and not
hitting the "if it hits 0" part).

So that check is a weirdly spelled "called from ffs_kill_sb()".
Just expand the call in the latter and kill the misplaced chunk
in ffs_data_closed().

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 3137b243c939 ("usb: gadget: f_fs: initialize reset_work at allocation time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2086,12 +2086,18 @@ static int ffs_fs_init_fs_context(struct
 	return 0;
 }
 
+static void ffs_data_reset(struct ffs_data *ffs);
+
 static void
 ffs_fs_kill_sb(struct super_block *sb)
 {
 	kill_litter_super(sb);
-	if (sb->s_fs_info)
-		ffs_data_closed(sb->s_fs_info);
+	if (sb->s_fs_info) {
+		struct ffs_data *ffs = sb->s_fs_info;
+		ffs->state = FFS_CLOSING;
+		ffs_data_reset(ffs);
+		ffs_data_put(ffs);
+	}
 }
 
 static struct file_system_type ffs_fs_type = {
@@ -2129,7 +2135,6 @@ static void functionfs_cleanup(void)
 /* ffs_data and ffs_function construction and destruction code **************/
 
 static void ffs_data_clear(struct ffs_data *ffs);
-static void ffs_data_reset(struct ffs_data *ffs);
 
 static void ffs_data_get(struct ffs_data *ffs)
 {
@@ -2186,11 +2191,6 @@ static void ffs_data_closed(struct ffs_d
 			ffs_data_reset(ffs);
 		}
 	}
-	if (atomic_read(&ffs->opened) < 0) {
-		ffs->state = FFS_CLOSING;
-		ffs_data_reset(ffs);
-	}
-
 	ffs_data_put(ffs);
 }
 


