Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA238837;
	Mon, 28 Oct 2024 06:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098370; cv=none; b=suy9xh3IM0N4BVQLtHHq/c9HXK2yrp7fbQy+n+P2vXP4sY/WDMv3HO49BhCNSfnvL2HOn54C8/bKBmGiOZF2+YdnOx0eLJIHzRsKn2hg5OLgdWMYIQlvDMd/dsD521mwnm+nvlsjhz3SMHDHv7Uo/c9qQSx4Yyz4sXAYvwvpLCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098370; c=relaxed/simple;
	bh=r5EL1AGZGS/OQSRajeWVuc4oKOQPM4tOEJvCbA4oWgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVpPZ8xePArWTI/PdKZ+Hsm0pqUVsKgHvJw2QqEd4UvcxEG1f21icVr3H8rDnChw+U9jdBS0Zh/8vS7SU7fU3qCStaKclXDKJ+BVoxuBus110Ukwt4XN3Z5eRSw/0EEPkLK3x7G3+eTQLNGgytHWxHAwz0cIdSUiGq2Xc/GzI2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhGPlSzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhGPlSzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C774DC4CEC3;
	Mon, 28 Oct 2024 06:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098370;
	bh=r5EL1AGZGS/OQSRajeWVuc4oKOQPM4tOEJvCbA4oWgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhGPlSznJ8FcvzXDaeFO1EcDHzb+oL+zxsmJcLzcR7tL7Syh/kVBc3VIRK6D88AOW
	 yPc9uykvWHdS9Ld1qa+SWu4rLTq0PColDPUHW8czXIx3yAK7YkkPdbASbUe4DaZ3FL
	 alWwxKshMLvH2xWFtI1AeWb2eeJ2qiSSWHBdnxgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <make24@iscas.ac.cn>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 196/261] smb: client: Handle kstrdup failures for passwords
Date: Mon, 28 Oct 2024 07:25:38 +0100
Message-ID: <20241028062316.953042895@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

[ Upstream commit 9a5dd61151399ad5a5d69aad28ab164734c1e3bc ]

In smb3_reconfigure(), after duplicating ctx->password and
ctx->password2 with kstrdup(), we need to check for allocation
failures.

If ses->password allocation fails, return -ENOMEM.
If ses->password2 allocation fails, free ses->password, set it
to NULL, and return -ENOMEM.

Fixes: c1eb537bf456 ("cifs: allow changing password during remount")
Reviewed-by: David Howells <dhowells@redhat.com
Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index bc926ab2555bc..4069b69fbc7e0 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -920,8 +920,15 @@ static int smb3_reconfigure(struct fs_context *fc)
 	else  {
 		kfree_sensitive(ses->password);
 		ses->password = kstrdup(ctx->password, GFP_KERNEL);
+		if (!ses->password)
+			return -ENOMEM;
 		kfree_sensitive(ses->password2);
 		ses->password2 = kstrdup(ctx->password2, GFP_KERNEL);
+		if (!ses->password2) {
+			kfree_sensitive(ses->password);
+			ses->password = NULL;
+			return -ENOMEM;
+		}
 	}
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
-- 
2.43.0



