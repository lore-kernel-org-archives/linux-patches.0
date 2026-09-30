Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C164F4CFB;
	Wed, 30 Sep 2026 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783907; cv=none; b=pJbWKLBAE9Iqtli2xvvS2/0Z4PuOQK5Eh3cIRZA6mm4ZAdJMB/LExUxJ5s9DLGlMZOyFgUhSmURQSQXLCu1Vnl/Yn/JhVyJqEM0zTCuI+byTJwIAtlo6CyPTnKJshvCgPBlJaetq5G/DtwzJUdLtAGhgjprp0Z75tNsY7BuXEm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783907; c=relaxed/simple;
	bh=yPSkn7O3qHYTxcS/9nsHFM61l4oQSqkM+vRYykidDfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqPg7yu8akoUXJbQdGE5PxQafrS54kcv0sNWABZmCxlGYQsxZUxNvwc33LOC3zguQzbia+OjDtIGryoagaeL7IWnb3d1RevCi9woFS2Zn7/stFRN4uzL/xlv6PXQvaywKIK/b+LtLFcnS2fB6Z7wePQdqLQKEmgi87b1Y5hasxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tA/UI2ep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tA/UI2ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C241F00899;
	Wed, 30 Sep 2026 15:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783900;
	bh=tShhkzt0CppdJ4TIR1I3N+e7Uh2GFTA5v5XpAbEOku8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tA/UI2epWvNJH+vhUyEbbXz91ghLzUmp/ZrQlRRxnsL6dl5qfpebAaWfzCDkdGCko
	 nsoAIxjR/f0StqZNLRhgfU7v796etlbHY7s6uDr4hw7oO59Ojwm95GJGwlI8pOu71C
	 Z9WSbkR3oCF0IUpBrZSr0KEPZcz2+3pIoo9FA5nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 545/595] autofs: fix sbi->pipe file reference leak in autofs_kill_sb()
Date: Wed, 30 Sep 2026 17:27:18 +0200
Message-ID: <20260930152359.436191750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9edf243713eb6..94870bdb4cb20 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -49,6 +49,10 @@ void autofs_kill_sb(struct super_block *sb)
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



