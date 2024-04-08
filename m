Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AA77E101;
	Mon,  8 Apr 2024 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583416; cv=none; b=FnaWtD6R3U/8JS3mdFO9ehd3dW5ogxZYUZrFOoFu/V6T6Ndog4qKAGjeFdzTB+JOOfsDo1/9xheBT+XtTK6efP163MmNIsdzR2m60CZZsMEHIR3Dsh4jF0FjzwgJx2koKIFXvk53bPdruDewqTm8Bq4SdMBnCyKKZ5pojC9Lqv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583416; c=relaxed/simple;
	bh=qG3F/zq8pDLeY9toEqIGPCJd4Z/c5GpzbFEPWwHbQ10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayYnmC7ZaN6shccUjPCkCGny/ODgMDu2lvSYKVO6BxQwOCXKBIX5af/4LPjKDNhZai/qKgh+m3bU95FoVe8f+7//r3b+3K1DzC1A4rPBIU7UpKK4kZbdvnxxFR/TyKP0W9Kp0k7ZFPjf8zR7RUa4lsHy+8c6uZGkhGruIgC23Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaM0MVUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaM0MVUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D442EC433C7;
	Mon,  8 Apr 2024 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583416;
	bh=qG3F/zq8pDLeY9toEqIGPCJd4Z/c5GpzbFEPWwHbQ10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaM0MVUsgpE8z/+JBfwgbRbNs3atPPdWH6Q/q9OWvkBC9T6cBfpQbyUfWNqy0xNLQ
	 nxjvzBOlmDg3Xc848Xd13vt2tKhj5A617gXIgytzUWrQoqllry2g/cg+hKbb+qGh8t
	 SSd3qyEcF79ssoTb/nFjzV0hWIffaml5MMHFrk8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 245/690] NFS: switch the callback service back to non-pooled.
Date: Mon,  8 Apr 2024 14:51:51 +0200
Message-ID: <20240408125408.510738637@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 23a1a573c61ccb5e7829c1f5472d3e025293a031 ]

Now that thread management is consistent there is no need for
nfs-callback to use svc_create_pooled() as introduced in Commit
df807fffaabd ("NFSv4.x/callback: Create the callback service through
svc_create_pooled").  So switch back to svc_create().

If service pools were configured, but the number of threads were left at
'1', nfs callback may not work reliably when svc_create_pooled() is used.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfs/callback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 422055a1092f0..054cc1255fac6 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -286,7 +286,7 @@ static struct svc_serv *nfs_callback_create_svc(int minorversion)
 		printk(KERN_WARNING "nfs_callback_create_svc: no kthread, %d users??\n",
 			cb_info->users);
 
-	serv = svc_create_pooled(&nfs4_callback_program, NFS4_CALLBACK_BUFSIZE, sv_ops);
+	serv = svc_create(&nfs4_callback_program, NFS4_CALLBACK_BUFSIZE, sv_ops);
 	if (!serv) {
 		printk(KERN_ERR "nfs_callback_create_svc: create service failed\n");
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0



