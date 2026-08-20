Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F704218EBA;
	Thu, 20 Aug 2026 17:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247127; cv=none; b=ezqq/cVhnLOmRyQGU0VTP8JxlIvBfXytFb//bMFRur6iM0VSNtJX2uobx/pA1jklHpV0NR/abOj1pkxs/g7Gf1lj/6VE20F31e2IzFEBN/tE3/o2B9uQCT3gezs0/pIcaAc5EKmamGyRqy3a8lk5AvLVGHDvrx8st80Kv2d9M3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247127; c=relaxed/simple;
	bh=pq1be9wIl5vFdcRdqIui+BPjjvcMfKbjey0c258oDtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMOGHGGn54zMfffYeJwagHzCegI3H/t9T/8JimIOr4ISIzGQq6dQv76j6T5vPzZK/3dPS25iP5TgbP5XguFx4RQIC0x92/zQezD7sfx2dKH2Aw8jFodKc3gbX4xgUGU2nw/tNPIRaouFXmjvnrHtEGKjyMKsfUoX0aeFF2wtbHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MadVQWSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MadVQWSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1A01F000E9;
	Thu, 20 Aug 2026 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247126;
	bh=PahMvABirNTi+L8yDbyyvL0/0WX0DyS6/UqMV9yhv+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MadVQWSuxKi7d29B6gRRVKBwt+usgnxVLjGLrfhEOGpGHmIp6fjDK/Vwz2K8FVjVc
	 XAWyUr9qkjOFffa1elFTejUAgQ0gQxA6WkPx21jxc769YEf66DPk/oCZ/C88zM7CZH
	 Wkctq34PxKIlC9GuuS4JXB9fKvs3yW+3UbCOvA7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/220] binfmt_misc: restore write access when removing an entry
Date: Thu, 20 Aug 2026 16:55:49 +0200
Message-ID: <20260820145228.255091835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit db1856ea9196cf6e015d12199a34c0b9313c7bfa ]

Registering an entry with the MISC_FMT_OPEN_FILE flag opens the
interpreter via open_exec() which denies write access to it for as
long as the entry exists. Removing the entry closes the interpreter
file via filp_close() but never restores write access, leaving the
inode's i_writecount permanently negative. Opening the interpreter
for writing keeps failing with ETXTBSY long after the entry is gone
until the inode is evicted from the inode cache.

Commit 90f601b497d7 ("binfmt_misc: restore write access before
closing files opened by open_exec()") fixed the same imbalance in the
error path of bm_register_write() but the actual removal path has
been leaking the write denial since the introduction of the flag.

Restore write access in put_binfmt_handler() before closing the
interpreter file.

Link: https://patch.msgid.link/20260710-work-binfmt_misc-locking-v3-1-a162f7cb58d6@kernel.org
Fixes: 948b701a607f ("binfmt_misc: add persistent opened binary handler for containers")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -161,8 +161,10 @@ static Node *get_binfmt_handler(struct b
 static void put_binfmt_handler(Node *e)
 {
 	if (refcount_dec_and_test(&e->users)) {
-		if (e->flags & MISC_FMT_OPEN_FILE)
+		if (e->flags & MISC_FMT_OPEN_FILE) {
+			exe_file_allow_write_access(e->interp_file);
 			filp_close(e->interp_file, NULL);
+		}
 		kfree(e);
 	}
 }


