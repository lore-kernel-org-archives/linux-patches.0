Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF5915746D;
	Tue, 18 Jun 2024 13:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715823; cv=none; b=YR+r4jzeknacMhtmcyrAf2yBdPwIS/fXzi5yhUnQriOpeHqqt++U2rX4S+JpxqEkGNw+TfP+fj53wPp9Q59HlWZqxh9Jp5gp7Ry4GkuS6huZnSEoLmixBjv7mx7g4ImXar6FNacA1BCbtHpUxwvxLQ5LNfTAWRfGgXtluikim0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715823; c=relaxed/simple;
	bh=2uPikhlCD1NorMlB5vUJX1AjdNmhcREDNkdNW+Q4520=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtubnQTq3zMSKihTMe8qtneNcW21lCmyCBxprEu5c6WdOWTBJK/0BfIXCGhjfOPlPJ1TWB7scESCbYqiM1tBKkd6E4J/NHWGK31iK/yVJqMFagq/wEpswmmhmRP1NpO2dqK8Kx/KA5WXxcPALOepwz4aHL51NTFmKx0GCzWAbE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHcg3gaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHcg3gaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6185C3277B;
	Tue, 18 Jun 2024 13:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715823;
	bh=2uPikhlCD1NorMlB5vUJX1AjdNmhcREDNkdNW+Q4520=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHcg3gaXsE5LaNIinJDOEqboHOP1F3jLtDL8Z+5YRKIohilpmdxZSW+w7AnVXpB9g
	 Gf8TIB7UlpOmr3HwWAtlFtLaLDQYN2SKetVN0HLUEjcxYZ/8HcDirIqlTyiItsd99r
	 UGPcBGORjy0rw1wQBsGuxpZlaUk6CFgS+Dv0wOpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/770] NFS: switch the callback service back to non-pooled.
Date: Tue, 18 Jun 2024 14:34:51 +0200
Message-ID: <20240618123424.194723494@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



