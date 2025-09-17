Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EBD2F6563;
	Wed, 17 Sep 2025 12:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112697; cv=none; b=XUk79oO1g1Jodvy2fsmQCnxvmMG/9e5A/tIRAEBtjhbri8M/iJJlfkKY3Y76S0K1dmXnTRvzTAp9iAH6BkzEDPkQWLxsdFOmdXAKuG4G7KF4HJvqnxu6FaI8nR238by4FxDgEtBnVUMG/vTl0ztXqrn4CbOjPp0xpjJTLSoqGd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112697; c=relaxed/simple;
	bh=3U3cPqEcHr/8LsSPdWKilshgXOxpDEVUloyH9x1tZLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/TJ+8f/DjoyZRTpSqT5GqFPD6vi6Fck9mUKmTg4SbsnwEBPEXp8sny52xZcY69Iz92Bi/Jjb7IL6YGoB65Tu7eYZf0dTGKPcGUxjx7S0PJbSrUxVvkpsx/QUx0AV7a2HLX9mT+yPVj0tGQHw+X9RdP/88AL0QegOMnOAmz+ZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5M7R/G+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5M7R/G+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A01C4CEF5;
	Wed, 17 Sep 2025 12:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112697;
	bh=3U3cPqEcHr/8LsSPdWKilshgXOxpDEVUloyH9x1tZLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5M7R/G+TsotUcs8pe+vMC/vetf3lMtMFQ3+CrH/e3t+S9pvnG/IOlT5a2e3m24RO
	 QG8F4Ia5n16WfVlLqTRTuvIFX5Ld5UE6EWDcJmd6vGhID3DA8McDEOcGZAHHquOsRp
	 PgI8xq5RYBSZo9Dvq5rnA+VM4c5GLp79vZib6XQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Brad Spengler <spender@grsecurity.net>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 047/189] proc: fix type confusion in pde_set_flags()
Date: Wed, 17 Sep 2025 14:32:37 +0200
Message-ID: <20250917123353.010869413@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangzijie <wangzijie1@honor.com>

[ Upstream commit 0ce9398aa0830f15f92bbed73853f9861c3e74ff ]

Commit 2ce3d282bd50 ("proc: fix missing pde_set_flags() for net proc
files") missed a key part in the definition of proc_dir_entry:

union {
	const struct proc_ops *proc_ops;
	const struct file_operations *proc_dir_ops;
};

So dereference of ->proc_ops assumes it is a proc_ops structure results in
type confusion and make NULL check for 'proc_ops' not work for proc dir.

Add !S_ISDIR(dp->mode) test before calling pde_set_flags() to fix it.

Link: https://lkml.kernel.org/r/20250904135715.3972782-1-wangzijie1@honor.com
Fixes: 2ce3d282bd50 ("proc: fix missing pde_set_flags() for net proc files")
Signed-off-by: wangzijie <wangzijie1@honor.com>
Reported-by: Brad Spengler <spender@grsecurity.net>
Closes: https://lore.kernel.org/all/20250903065758.3678537-1-wangzijie1@honor.com/
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/generic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 409bc1d11eca3..8e1e48760ffe0 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -390,7 +390,8 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 	if (proc_alloc_inum(&dp->low_ino))
 		goto out_free_entry;
 
-	pde_set_flags(dp);
+	if (!S_ISDIR(dp->mode))
+		pde_set_flags(dp);
 
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
-- 
2.51.0



