Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1511F75BD;
	Tue,  3 Dec 2024 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239954; cv=none; b=SWbYf5SatO9NfNhxOrIwnPbyjbDzohJ6TC7FpCtnYzixZfnerb4O9igcpce26o4kqpf29qyj26KtROnyc+SlmaJOkAVgTJ2gO+K+fd2r96EkF/qh3sseHqKT/rE7toCjS07gZ9mfL7EmdweMT++DEkwJKeioxQidgR/fZadMKTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239954; c=relaxed/simple;
	bh=CVFR8I6D0u/NPtGeV6I28NXnzmsACJF/lJmx9aL0JJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tF+f3b2wMeOt8l1uSZzwMLMPtFnU3/zpx1UFc9nTzB1uV+RReNTJxfw/wtTPxOzk4RrVkOf8cc8QebZpKR8lfSua0JSxZxUiIGyRFPgRoyQl8ovD8nSicqzTlr5UCE1+QrZxdCJs7yMOxQnOu4SkF4T3T9cJizn+XN+XNqtgB04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkp8bEss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkp8bEss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05988C4CED6;
	Tue,  3 Dec 2024 15:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239954;
	bh=CVFR8I6D0u/NPtGeV6I28NXnzmsACJF/lJmx9aL0JJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkp8bEssTwreM7d9CUP1fMS8Lf1l0AeqS3p7U8v5EChisyqAUs8dX5aqppKbbAuEM
	 KbWzeNBJuFNjlCQgguC3OBXc56OSUZW0hiE3y5xp0hwh79GINM/x4jrxzzrNof8RYs
	 S9QTq9mGobJSRbr0dpOROXLPa4RrJtZ4nDYPqP2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 792/817] smb: client: disable directory caching when dir_cache_timeout is zero
Date: Tue,  3 Dec 2024 15:46:04 +0100
Message-ID: <20241203144026.926206577@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index be0f91000171b..9cf87ba0fb8c9 100644
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



