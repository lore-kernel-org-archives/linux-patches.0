Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98929248886;
	Wed, 25 Feb 2026 01:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983711; cv=none; b=uKXGp9A2B9L68Z/XH73WEqA4tl8JbcVK47x65xnHreEmE5NqDRgzAcYy6/6NcYUsQbYnQ3ydO8ZcY9LMVkNkzm3yyh5u9Wad1kmr/2X9Ex3rPogmk6pkEnu3lbfC/Ppy06tWHc08DFTdxqEPJJFeUFoki/J8826nZ2QXakkS4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983711; c=relaxed/simple;
	bh=EdEWTS2t04fQF5fAbAmiJKVDshRUYJ4giqXWuWph26s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unMwuINoVa/Vb3UkIMLwAwRSw7rjUJ3jPqFjqHutoSQL0H1Q92RwU0siQc1wDhwcCQCyUZjmvLK/spKW1bXclNNk4ZzxSQWPQLDniwJcbp/e+99izD/3hW0jMtTzrfNs/Wxw8pDcYTIygJLaPpW4OSCEvHzCrM4wsEVasDgap4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egfqog2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egfqog2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E20C116D0;
	Wed, 25 Feb 2026 01:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983711;
	bh=EdEWTS2t04fQF5fAbAmiJKVDshRUYJ4giqXWuWph26s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egfqog2q93W2dC/skhFog9Ynz9Q5fNWU7T5qYJPevh22/OLfoEhzAviGyF4XN5sCn
	 yIk+9JAf8U8jwXgQmtsDGPM1EBhPwg08FUdr5cRZupBU8ltaqkTFnyqVb0jNphBea+
	 pR9Ekl79f8GKT+IZ8L2akNvLoCR9Ae/Z9bLv1T9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/641] fs: move initializing f_mode before file_ref_init()
Date: Tue, 24 Feb 2026 17:15:36 -0800
Message-ID: <20260225012349.192398659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 1219e0feaefc9697f738b223540e8e8906291cb3 ]

The comment above file_ref_init() says:
"We're SLAB_TYPESAFE_BY_RCU so initialize f_ref last."
but file_set_fsnotify_mode() was added after file_ref_init().

Move it right after setting f_mode, where it makes more sense.

Fixes: 711f9b8fbe4f4 ("fsnotify: disable pre-content and permission events by default")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260109211536.3565697-1-amir73il@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_table.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index cd4a3db4659ac..34244fccf2edf 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -176,6 +176,11 @@ static int init_file(struct file *f, int flags, const struct cred *cred)
 
 	f->f_flags	= flags;
 	f->f_mode	= OPEN_FMODE(flags);
+	/*
+	 * Disable permission and pre-content events for all files by default.
+	 * They may be enabled later by fsnotify_open_perm_and_set_mode().
+	 */
+	file_set_fsnotify_mode(f, FMODE_NONOTIFY_PERM);
 
 	f->f_op		= NULL;
 	f->f_mapping	= NULL;
@@ -197,11 +202,6 @@ static int init_file(struct file *f, int flags, const struct cred *cred)
 	 * refcount bumps we should reinitialize the reused file first.
 	 */
 	file_ref_init(&f->f_ref, 1);
-	/*
-	 * Disable permission and pre-content events for all files by default.
-	 * They may be enabled later by fsnotify_open_perm_and_set_mode().
-	 */
-	file_set_fsnotify_mode(f, FMODE_NONOTIFY_PERM);
 	return 0;
 }
 
-- 
2.51.0



