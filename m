Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A9747F2C3;
	Thu, 20 Aug 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248516; cv=none; b=mrwhOk00aXogxqKDxb+rgrxvgY7Qj8oikithBr/VroWLRPRuMg7MOl8FN7I/OEzhTS7hbj47RiGcirEtX0ZgMp/WJQiAH+VHdSqoIJKD0xlDvV2pHlGRhH1uIpq6RvqfyayvjibHKO6JgAiidb897KcbUjI+/icMM5cRIT0ozgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248516; c=relaxed/simple;
	bh=R23k0eohq+EMQu7/KlxGGIhpwLSoZxclQFqBUfSKyF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOGu0K8KujhWVZKx7rCQwrhxMZObPQsgzpzwunh7Jb8pkvjflENHAyZXOCSR1C8nI+HccEMubXBInE4hRdomLYkvZum5wZuimT5OMb9f70d0e5l+zRQYHS6k8yN0YlKUTshguxlOxdzBmK9GcvDZgZIEjsn9GBA/NeUcz3hkcZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiKVOloc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiKVOloc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8199C1F000E9;
	Thu, 20 Aug 2026 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248515;
	bh=YvsBwEqgPWJ9AvRt4wREh0Qi4a+jTUt0WL39BLqvwME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jiKVOlocEQ6ZFahbf59sozF3y2wxadMCQ/qsslBSeYHKBIbkhBXg5Uy6M297/2kqJ
	 SfiSAOQG1qYsGqX+7fCTFb6rVHgOSYv7y61zKncNEkawFavE2i6rSC0DMMGifyqwgh
	 0DKmQxQCA6zRClh+VOvLZzB3b6zHdbooSpIka2K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/303] fsnotify: opt-in for permission events at file open time
Date: Thu, 20 Aug 2026 16:56:30 +0200
Message-ID: <20260820145301.082474694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit a94204f4d48e28a711b7ed10399f749286c433e3 ]

Legacy inotify/fanotify listeners can add watches for events on inode,
parent or mount and expect to get events (e.g. FS_MODIFY) on files that
were already open at the time of setting up the watches.

fanotify permission events are typically used by Anti-malware sofware,
that is watching the entire mount and it is not common to have more that
one Anti-malware engine installed on a system.

To reduce the overhead of the fsnotify_file_perm() hooks on every file
access, relax the semantics of the legacy FAN_ACCESS_PERM event to generate
events only if there were *any* permission event listeners on the
filesystem at the time that the file was opened.

The new semantic is implemented by extending the FMODE_NONOTIFY bit into
two FMODE_NONOTIFY_* bits, that are used to store a mode for which of the
events types to report.

This is going to apply to the new fanotify pre-content events in order
to reduce the cost of the new pre-content event vfs hooks.

[Thanks to Bert Karwatzki <spasswolf@web.de> for reporting a bug in this
code with CONFIG_FANOTIFY_ACCESS_PERMISSIONS disabled]

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/linux-fsdevel/CAHk-=wj8L=mtcRTi=NECHMGfZQgXOp_uix1YVh04fEmrKaMnXA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/5ea5f8e283d1edb55aa79c35187bfe344056af14.1731684329.git.josef@toxicpanda.com
Stable-dep-of: db1856ea9196 ("binfmt_misc: restore write access when removing an entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -185,6 +185,12 @@ typedef int (dio_iodone_t)(struct kiocb
 #define FMODE_BUF_WASYNC	((__force fmode_t)0x80000000)
 
 /*
+ * fsnotify pre-content events do not exist in this kernel, so a file is never
+ * watched by a pre-content event listener.
+ */
+#define FMODE_FSNOTIFY_HSM(mode)	0
+
+/*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
  */


