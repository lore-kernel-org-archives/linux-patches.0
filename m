Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9307B39FF3;
	Fri, 24 Nov 2023 18:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TW0wTDjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1465FC433C7;
	Fri, 24 Nov 2023 18:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850088;
	bh=+lGobjYdLdDN+HdYuSZMbi91dUFVPKnDThFYZJGwQRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TW0wTDjYnokzXVGvS4pOV2eUUlROg1lQ2qprk3oWEl6D7OPaMe1McqeqkoKQ+dMNV
	 gxs0UiUmlkqdN6qMxljbKtKTqJwOq2glKILIZMqt+fg3aFHaa82hkIkcCVX32jtTkM
	 EWmrrfzvvus7WOIn7k5SjyWXWEZQP0p9LAyluDAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 441/530] lsm: fix default return value for inode_getsecctx
Date: Fri, 24 Nov 2023 17:50:07 +0000
Message-ID: <20231124172041.516919036@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

commit b36995b8609a5a8fe5cf259a1ee768fcaed919f8 upstream.

-EOPNOTSUPP is the return value that implements a "no-op" hook, not 0.

Without this fix having only the BPF LSM enabled (with no programs
attached) can cause uninitialized variable reads in
nfsd4_encode_fattr(), because the BPF hook returns 0 without touching
the 'ctxlen' variable and the corresponding 'contextlen' variable in
nfsd4_encode_fattr() remains uninitialized, yet being treated as valid
based on the 0 return value.

Cc: stable@vger.kernel.org
Fixes: 98e828a0650f ("security: Refactor declaration of LSM hooks")
Reported-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/lsm_hook_defs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -273,7 +273,7 @@ LSM_HOOK(void, LSM_RET_VOID, release_sec
 LSM_HOOK(void, LSM_RET_VOID, inode_invalidate_secctx, struct inode *inode)
 LSM_HOOK(int, 0, inode_notifysecctx, struct inode *inode, void *ctx, u32 ctxlen)
 LSM_HOOK(int, 0, inode_setsecctx, struct dentry *dentry, void *ctx, u32 ctxlen)
-LSM_HOOK(int, 0, inode_getsecctx, struct inode *inode, void **ctx,
+LSM_HOOK(int, -EOPNOTSUPP, inode_getsecctx, struct inode *inode, void **ctx,
 	 u32 *ctxlen)
 
 #if defined(CONFIG_SECURITY) && defined(CONFIG_WATCH_QUEUE)


