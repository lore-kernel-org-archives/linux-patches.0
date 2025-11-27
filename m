Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147D828D8E8;
	Thu, 27 Nov 2025 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254995; cv=none; b=G5zDYP17AnINy637pKjqKgGtbokU3dA1msHPOlDeHfhf7utJmoxehivkyZ//rnXFlaE5YRcU/ZIGURqVvXJsoFQ93OAgCOhNYf8GI2OrHWvSrFwzlz+Z+nUBPStusiIvSng2TUF91i4wmuvzZiSOpCuG5beFQDP2fpZT+W5Rr5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254995; c=relaxed/simple;
	bh=UhzXs1XAn0rYVveesrCNV955Xw+Z4ULE63E9nONai+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cB2P8mFcNBH52iK4UVee05xunwT3eMSs7MzBK5TiqNfNjvBoRciPG7/RqiOXfn+APFlIOWtqjMWbKkG2Tc/DyQYxpgOziw3PKJ+RFLPO84NtEEfFu4eLlHC+xgkEQu7AJceGXwkgdp4cdrwNLeVF9r1miAI1VpaSroAMTsMu+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEvLEeNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEvLEeNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9449EC4CEF8;
	Thu, 27 Nov 2025 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254995;
	bh=UhzXs1XAn0rYVveesrCNV955Xw+Z4ULE63E9nONai+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEvLEeNBfPd5SJQsi7A/OktqfYtJhjtDJKRUzrMdpH/8TgnyO8m0MSndXAUOGI7v9
	 khKazMLn6FPf4QFulWmnwSAJKA54SB8DlQVzzWYv2mQwjrhomGKzwuoSm59V2nQfeS
	 0nF4te+be/oanUgkaGoFMuN16PLDjvTW+TZu9OMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 56/86] cifs: fix memory leak in smb3_fs_context_parse_param error path
Date: Thu, 27 Nov 2025 15:46:12 +0100
Message-ID: <20251127144029.878119860@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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
index cf233cb9c1943..a64c0b0dbec78 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1726,6 +1726,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



