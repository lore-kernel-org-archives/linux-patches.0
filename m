Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FF7154449;
	Fri,  6 Dec 2024 15:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498409; cv=none; b=d8/4r2K5JIkWFlVHXC5ar8pO6PiXGrJ58jDG44ppgPfXuXaVSCw08nlJ95YRsVQzSGLxh3j62OooE7Gr07wPlJvxd4C3TMhsTYgPIOtFl16L1UYo7/53kcszDxo52I9yyRG7zT06A4X4wU/HuotORSr8KcgcezF3ZsuQMzfl8W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498409; c=relaxed/simple;
	bh=DNCQRkQ5IdDvT5ZcuPyO+WW2Ko8DpK+WS85ZXSoAXnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qi6aJnMnWcmXkOcaG2LixXjQGoyNuvL/aJIXHWccrAcwmUNmK423W5z/iE9Sx6yYrr9XoKt/iH78qkBfN+YoYn4gR/MKb9y4BBqftwJITN2XMMaQmWV/QyDFFwACwfFw1RkrlTB34H3u8x7PNumvlzeTaNgRTuutYHcj3HZfHjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHk30Ecf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHk30Ecf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3E4C4CED1;
	Fri,  6 Dec 2024 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498409;
	bh=DNCQRkQ5IdDvT5ZcuPyO+WW2Ko8DpK+WS85ZXSoAXnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHk30Ecf9YKcIeUpQMZR85IU8ofw22jn9kizTG8Pf7jbrat9I+j9Z63SzxPo8oS02
	 7CuoSqyZ6XueORDYube1AdbpMQBt/aYQh3Dqy1YqfiniyVLPuvzNUQH3sUpcW+Pg93
	 VTtd1WwcA7y+pzK3s8kicK1nMAKQLfXQwN9TilNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 576/676] smb: client: disable directory caching when dir_cache_timeout is zero
Date: Fri,  6 Dec 2024 15:36:35 +0100
Message-ID: <20241206143715.857658018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit ceaf1451990e3ea7fb50aebb5a149f57945f6e9f ]

Setting dir_cache_timeout to zero should disable the caching of
directory contents. Currently, even when dir_cache_timeout is zero,
some caching related functions are still invoked, which is unintended
behavior.

Fix the issue by setting tcon->nohandlecache to true when
dir_cache_timeout is zero, ensuring that directory handle caching
is properly disabled.

Fixes: 238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 5cb6d1b47415d..7b850c40b2f32 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2601,7 +2601,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	if (ses->server->dialect >= SMB20_PROT_ID &&
 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
-		nohandlecache = ctx->nohandlecache;
+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
 	else
 		nohandlecache = true;
 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
-- 
2.43.0



