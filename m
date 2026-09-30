Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03F652BE3A;
	Wed, 30 Sep 2026 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789404; cv=none; b=Ruf85VOrYPwDeJfAAWJsLtAg3wb8oHhHVxOnagtA9ddEcQkkeWROP3iHvNB7O9haFWhmTHybhbw9XE/JM3IevsznpYAHWAsvrK6FFefDu8CuMn6eNSTblUX1gAdQolXTikJyp3rpMW3mbahUk/ZfIYvqqLzIbVA6Yk+dbt8+84U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789404; c=relaxed/simple;
	bh=dQWkcKAiCi6+FKcQ0ziGpCW/IJXqhaPsHKd4b2QoKpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtHFq8BY4U30V0MbTsEExxtrqmTsuSUb1yIirxHsdXOeUsDc1YNmH/pIWvu3ghO7jv7WyMBGIR6AkCMQP5TizueVaEhRlN5I71uGV3QnbrfqlAwAfXjdIAKjp/xworaR4kVw9+rzkOgr2JLU4z1MDjNZSAaY3uQiKWPz5Zf5+GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARxsmZgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARxsmZgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549441F000FF;
	Wed, 30 Sep 2026 17:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789402;
	bh=96PCmuMKr/ZQD/HkK1UQc/4mwhJv8b3lAQOldR8Zz74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARxsmZgAMsZT4t9XVb67y3v1f/+JZdeLf0Uqn5eJYS2ohhskS74AHk9KdywhOD53g
	 nMMQ8f1NjZJ+h8jAOB7iG6g3x/q0HNOJCM6ZDUokjFxomqU8FGcjxhZ+ZG4W4CH11x
	 U5TpTFbbzPScaa0AD04wPoOi+pIFfT9lOys0OvSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 448/877] autofs: fix sbi->pipe file reference leak in autofs_kill_sb()
Date: Wed, 30 Sep 2026 17:22:39 +0200
Message-ID: <20260930152424.348596634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

[ Upstream commit aa5e44b29ffe4eaa08cc2237fd65bc2596bc023e ]

When autofs_fill_super() fails before clearing AUTOFS_SBI_CATATONIC (for
example, when find_get_pid() fails on an invalid pgrp mount option, or
when an fs_context is closed before mounting), deactivate_locked_super()
invokes autofs_kill_sb() -> autofs_catatonic_mode(sbi).

Because AUTOFS_SBI_CATATONIC is still set in sbi->flags,
autofs_catatonic_mode() returns early without calling fput(sbi->pipe),
permanently leaking the pipe struct file reference.

Explicitly release sbi->pipe in autofs_kill_sb() if it is still non-NULL
after autofs_catatonic_mode().

Fixes: ebc921ca9b92 ("autofs: copy autofs4 to autofs")
Signed-off-by: Hui Peng <benquike@gmail.com>
Link: https://patch.msgid.link/20260919204808.2812930-1-benquike@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index ec3c1ac1c1f9d..7203dba0ebce4 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -51,6 +51,10 @@ void autofs_kill_sb(struct super_block *sb)
 	if (sbi) {
 		/* Free wait queues, close pipe */
 		autofs_catatonic_mode(sbi);
+		if (sbi->pipe) {
+			fput(sbi->pipe);
+			sbi->pipe = NULL;
+		}
 		put_pid(sbi->oz_pgrp);
 	}
 
-- 
2.53.0



