Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73A0333ABF;
	Wed, 17 Sep 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114007; cv=none; b=KAnOU4mFRUusHKI2eg06axfH3fsjWKfA1qzSx5OmhHXl244a7mWPCS2bOf2CvgiOb6Jjg7EnQuvFaZO/u57V7F0bhWDJXp6B7yzNnCGpnMCGXWkG8I+803sK5kyvdSQSnm6r5wM0Lvq/JFZ61oQM1Y7xx6Wpm3j4r76ldhk4mYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114007; c=relaxed/simple;
	bh=aKeNmVSeKw2xod3X8OCEFlbMiGelejJD+aq/6JZqT5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3AJ/hSStmfAAaixzNk3azvWdYcuSsmuPJHPz96tv9bqgKSpsf1jdz/+NAaW4fzUGPcOB/NcjNxdnzdpQOo/3EhsS98Ltd8oa+s3m8S5RdsXBapHC4dJSSlPcynu+DtRjmXrTtRfA/pbtvnNG5j2jfV2CXMgf0e//OZilHeN0N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nykwoJK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nykwoJK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20814C4CEF0;
	Wed, 17 Sep 2025 13:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114007;
	bh=aKeNmVSeKw2xod3X8OCEFlbMiGelejJD+aq/6JZqT5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nykwoJK7UZDEst+up9EmAgpdG/IIUUv3L2o0oldGIkgHaztGP9HiFXxXxfS+b2g1x
	 1HkAl3s9CBMgnJwAL5FMtafO9D5EMI8YFdFhvSfG40Pq/pimQlk/85KxaNJtf1gfuG
	 0K9AbUOerrzwequVkgXLrm/1OEafxWpVy6b3nDqQ=
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
Subject: [PATCH 6.1 19/78] proc: fix type confusion in pde_set_flags()
Date: Wed, 17 Sep 2025 14:34:40 +0200
Message-ID: <20250917123330.033876063@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c96c884208a98..21820c729b4bd 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -389,7 +389,8 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 	if (proc_alloc_inum(&dp->low_ino))
 		goto out_free_entry;
 
-	pde_set_flags(dp);
+	if (!S_ISDIR(dp->mode))
+		pde_set_flags(dp);
 
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
-- 
2.51.0



