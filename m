Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427691E7C2D;
	Wed, 17 Sep 2025 12:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113847; cv=none; b=OyTuqQqE+ksHZ8186l9NvpxXIHdH4XGmvfU3I2/ErHyi91r0p18keU2U3SMiPTEZDGU1ighTLLc5dKmZO1rITrAvInfC8KwjdSTISCk1qun0KzYLN1QzuCXq+LDMxqepAHecQ8wcpoeBhaLXZufUuQOpYeGaeYwWIsyLMVlasxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113847; c=relaxed/simple;
	bh=l6TFiAI9FAAeQv0UukQ/NEHjW6c5FGH02f42kbHxcWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hePM2eBd//bmHlaOon0gVhjQKZGWxNk4/U0OvQfJt8AE2pprvsb/Er0PNo3R0VGfpT1y6V0bpbGGfmittidXzHlMXCdUO0Jy+e5iFWoi07dHzBkMxeDQHNq/3gd0cEAWmPDMe6ctLnPBV0gOjeqMJPdPVZoUuD1NlWWQxJPzL+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrZlBQNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrZlBQNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20A3C4CEF0;
	Wed, 17 Sep 2025 12:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113847;
	bh=l6TFiAI9FAAeQv0UukQ/NEHjW6c5FGH02f42kbHxcWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrZlBQNZFaVyVt0mdvVIkhlzgt7DLd5hV6HWWqdg2GjNpEHyxvYsjcfnsdBFL9mmK
	 VMLczC3e1y0SsvdCudqkhd40nMDNT7EA4qHJHnGSQgxisxFaP6vokGKwrPMXA+nMfd
	 2r0s2vXBOqrZrW5412M1N681L1QTbXV+PS6d+Bf0=
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
Subject: [PATCH 6.6 026/101] proc: fix type confusion in pde_set_flags()
Date: Wed, 17 Sep 2025 14:34:09 +0200
Message-ID: <20250917123337.488680954@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index db3f2c6abc162..4cadd2fd23d8f 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -388,7 +388,8 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 	if (proc_alloc_inum(&dp->low_ino))
 		goto out_free_entry;
 
-	pde_set_flags(dp);
+	if (!S_ISDIR(dp->mode))
+		pde_set_flags(dp);
 
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
-- 
2.51.0



