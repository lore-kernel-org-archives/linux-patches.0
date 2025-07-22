Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D1C2EE60D;
	Tue, 22 Jul 2025 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193510; cv=none; b=if1E8BYUvmT8YjLRZd/WyXw6jGN/o2tauoEquKgvDlfNzYdUr6DIDA4BwsmEvclT4mzxxIVX2W3REZZZxFnFCWI5HtNlkpVm87SfGZQxQe8C11dhDnRWLiQH+n8viTSCli+D9DuzLTrk+FvFM9jRKclD8EouHEx8ZtF8UyfSUyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193510; c=relaxed/simple;
	bh=427JxyR3FrLN+/widdg/Sno+Pd6JwcamIrfKcwCa+PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTYK43YMzJU+dDb/5H35pywA9g65YreFXp108UgMs7mmiJXqN/xMq3qDlasgog4K5uIQ9UeBDMI2jLSqjAooQN5AHCgAninfzUQGMHmj/ZYzyhvg7ggbvO+W6xCIjw3oO85keaAF8OUEfSdfNgU1isePQrobkLQTu8nZ4GI+WvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3XIjbcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3XIjbcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9992FC4CEEB;
	Tue, 22 Jul 2025 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193510;
	bh=427JxyR3FrLN+/widdg/Sno+Pd6JwcamIrfKcwCa+PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3XIjbcQes6Km/Vud7Gpcmg+sW7YxifQm4rtFKu+heZf+c/azhbDynA0GLdwYZYE0
	 MHZoXnEg7hwUc5yeGqgy2EZzckjZwITJ1liSQ/tORIWoTq55bZIaZy31DJbaS99nuu
	 wX0umR7T4Zqcxb7dKw0n10WY8BRb4Jst2nTe0p6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 115/187] fix a leak in fcntl_dirnotify()
Date: Tue, 22 Jul 2025 15:44:45 +0200
Message-ID: <20250722134350.041663991@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit fdfe0133473a528e3f5da69c35419ce6711d6b89 ]

[into #fixes, unless somebody objects]

Lifetime of new_dn_mark is controlled by that of its ->fsn_mark,
pointed to by new_fsn_mark.  Unfortunately, a failure exit had
been inserted between the allocation of new_dn_mark and the
call of fsnotify_init_mark(), ending up with a leak.

Fixes: 1934b212615d "file: reclaim 24 bytes from f_owner"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/20250712171843.GB1880847@ZenIV
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/dnotify/dnotify.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index c4cdaf5fa7eda..9fb73bafd41d2 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -308,6 +308,10 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned int arg)
 		goto out_err;
 	}
 
+	error = file_f_owner_allocate(filp);
+	if (error)
+		goto out_err;
+
 	/* new fsnotify mark, we expect most fcntl calls to add a new mark */
 	new_dn_mark = kmem_cache_alloc(dnotify_mark_cache, GFP_KERNEL);
 	if (!new_dn_mark) {
@@ -315,10 +319,6 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned int arg)
 		goto out_err;
 	}
 
-	error = file_f_owner_allocate(filp);
-	if (error)
-		goto out_err;
-
 	/* set up the new_fsn_mark and new_dn_mark */
 	new_fsn_mark = &new_dn_mark->fsn_mark;
 	fsnotify_init_mark(new_fsn_mark, dnotify_group);
-- 
2.39.5



