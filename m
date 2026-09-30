Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7C536F905;
	Wed, 30 Sep 2026 19:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796919; cv=none; b=BiDGzCFgoJ1qPkfo4u4JZjcKnLE/w0hecBFUSxYV7/gUSzvW1ceeZHV+FxUv1k2KBehqqU8t5oTNpQ9sGUjvI2yMOjUh030NqXdggH+my4rhK1uaYqRCNVjjZZNriTPj4s8YCON37UwMXKiRTvS0xvl1TQ6R5g/Tc4rIm8yLNkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796919; c=relaxed/simple;
	bh=JzvbrsokMoPh+KFJcXFOCRM5A5FYP+iLT0MPPvtVKdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2cPLZW/n4/UnkrhmrlqQ3FdjsTr3+8ZiwG/XWtOCOORJ6vcZf0o3s1tnHsRTJZEizkquBLiEh1JGWoyhdzbPuSRaGEyYo6pMXcXiqADxsZRrW2hNLcL9Rj1g9j4k/ECnmGvCb6k5i6NqaZprfVt7U5sjlQUUpaJPLochqggpHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bR8K1SQ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bR8K1SQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313CF1F000FF;
	Wed, 30 Sep 2026 19:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796918;
	bh=8Iw8oMVuDctSahS/m4ZSHe63FwEOPel8UXk7WgHEqRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bR8K1SQ8YfpmEH52f7pzxvDJVvNHx6rxkQ4txtmm5Hn1+xPxrPyxQ+ctwM29UcxF4
	 gAkHZ7ze0mNQ7SqLyRTghz7QgLykPWEMVQNdZtDfNqpX8bVL7mVvDo71Nkec0/jybL
	 92xM4DhdJwxyHdFYDpr8V6EaayyDcJW8ikstXslc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1082/1193] autofs: fix sbi->pipe file reference leak in autofs_kill_sb()
Date: Wed, 30 Sep 2026 17:29:26 +0200
Message-ID: <20260930152458.273267027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2b49662ed237d..8b2c056ea7c27 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -50,6 +50,10 @@ void autofs_kill_sb(struct super_block *sb)
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



