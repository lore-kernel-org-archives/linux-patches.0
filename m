Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518E233345C;
	Thu, 27 Nov 2025 14:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255312; cv=none; b=lp6zqCaTHcRsEPSGqzNENuJqeupHSV+t4QvW/f2zxTprKUKGaNyOid3IJcHnXKdoS9UCji5X3f89Szf6MK+RddnZnIsu2tJG2gaapasMRSFR1PyVamJjed6Yfj4X31ytOUt0Fsw1i6K18fPZp+Yg7sw62q8oWVf4LIK+8ww3HZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255312; c=relaxed/simple;
	bh=Fr6/edGXdsz+XGxlmxgnUlDznEGFNGmsuWw20xCqgpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kssbJXMSyuVKupD6bRUx3TzEI00C0c4RPwoAv/3LU9LafBz9Xb/LC0Rj5xUpgu6FB/ktdNJDXd4fez4bB1jcARd7xXPxfOcMEs/gc+qH53Jd54RWh7GtQffoRTYsh822Zd6cbeuSb4cjuNEPXTs3s7jK0wrbzK0ViP57A41jjg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ui6VLiJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ui6VLiJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1433C4CEF8;
	Thu, 27 Nov 2025 14:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255312;
	bh=Fr6/edGXdsz+XGxlmxgnUlDznEGFNGmsuWw20xCqgpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ui6VLiJgjlICSqUs63Oj/mDM4yKr86T6crlp5pX5jZ2QNvfBuyrcWfCNfFwUbCqqW
	 6SfFWy+0U2iQfzxUBJ0CkKM+ZeFxxcjNCF9suL0KgJfTMcyEW25J0rIC3cvlzzA5Zt
	 yOg/rlASK/T0A0SEOP/ZF3ggYUPr4+AQHbrXTb2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/112] cifs: fix memory leak in smb3_fs_context_parse_param error path
Date: Thu, 27 Nov 2025 15:46:23 +0100
Message-ID: <20251127144035.806928872@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

[ Upstream commit 7e4d9120cfa413dd34f4f434befc5dbe6c38b2e5 ]

Add proper cleanup of ctx->source and fc->source to the
cifs_parse_mount_err error handler. This ensures that memory allocated
for the source strings is correctly freed on all error paths, matching
the cleanup already performed in the success path by
smb3_cleanup_fs_context_contents().
Pointers are also set to NULL after freeing to prevent potential
double-free issues.

This change fixes a memory leak originally detected by syzbot. The
leak occurred when processing Opt_source mount options if an error
happened after ctx->source and fc->source were successfully
allocated but before the function completed.

The specific leak sequence was:
1. ctx->source = smb3_fs_context_fullpath(ctx, '/') allocates memory
2. fc->source = kstrdup(ctx->source, GFP_KERNEL) allocates more memory
3. A subsequent error jumps to cifs_parse_mount_err
4. The old error handler freed passwords but not the source strings,
causing the memory to leak.

This issue was not addressed by commit e8c73eb7db0a ("cifs: client:
fix memory leak in smb3_fs_context_parse_param"), which only fixed
leaks from repeated fsconfig() calls but not this error path.

Patch updated with minor change suggested by kernel test robot

Reported-by: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=87be6809ed9bf6d718e3
Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 4c295d6ca986a..9a4492106c25f 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1764,6 +1764,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	ctx->password = NULL;
 	kfree_sensitive(ctx->password2);
 	ctx->password2 = NULL;
+	kfree(ctx->source);
+	ctx->source = NULL;
+	kfree(fc->source);
+	fc->source = NULL;
 	return -EINVAL;
 }
 
-- 
2.51.0



