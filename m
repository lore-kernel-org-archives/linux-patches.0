Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFB9272E53;
	Thu, 20 Aug 2026 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243972; cv=none; b=KlNeA3TykZ4MdoOfQbF/B8zJu/dMyrPJ0Untt4ty/qLGgpudcLlImxcKMtZS285S7U3wwc0qavVMBhOG/hPrJ2YyAuy5AC64ptuauVL7+uxuHJg/iL4ECW58RLB7+p3R3UlcT/BmZ20mA/YoZucyfASzPuavO5NvDuQFnWTUmYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243972; c=relaxed/simple;
	bh=RVQt0AjSLiGBwlWqz0txi1JYuJ1UsO6U7r1iAu+gzys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bnksn3HUqPdV7TBJsBlNS5S9hpnag2KQUWUShXQJJg3hGi2l7HgPuh0PBTr6u5asEyvMUHTJKvqjrOEl5otfyh8mrXZxzy7STbKtGLKXrLrqFwfx3navKsnTcuII3Ag5Vn3AtYa+5cHoTOm2aHbJthTOOdKRrHZqUxYqjTNmauA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apcacb4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apcacb4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41D91F000E9;
	Thu, 20 Aug 2026 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243971;
	bh=xU6V91x4fomImutFVuNzTZgb6sxOJ8EtUHc+jsKfNqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apcacb4VRJYevG/YWgz6cSrjvXNSKKeoiGNEJES1FIKP6GL1F1khMPiMHPvN6h86e
	 sPehsPErflUPjvaL1ACqxoR1Tvw3SrsT1iQl2M2w1mTQgYUWQge12AistE18yZ63cQ
	 7jD62SKi/rdV9Wxm2sd4hSWEN3tGKMKJMFL+GkiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/272] binfmt_misc: restore write access when removing an entry
Date: Thu, 20 Aug 2026 16:57:03 +0200
Message-ID: <20260820145238.788082203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -163,8 +163,10 @@ static Node *get_binfmt_handler(struct l
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


