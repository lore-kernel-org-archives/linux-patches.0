Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8D633F5B4;
	Thu, 28 May 2026 20:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001110; cv=none; b=FIWTsfNObFjJmthL9vrdRwOCVj1cKM/MPyd1N2KfuAO3ZmFxHlPkMtKtn0cHUN0VhXEp7LugQ/iZxIqghxM5gMvg8yTjKdgKAI2jHTOaXZ7GhxpSJZnNCN/e6E1CYJfB65bOJBAV1sjJxZ32aruCLyGsIMAEJWjT83TF5Bwv1do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001110; c=relaxed/simple;
	bh=heLFXq+zWYaQd+br/q/kWaa1UBj/1baYOgthPrjlN4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQesff7Sbddf+AQYGJ635xnimvCMsAv3Db8xpYZqUoj6XvqI89oaBrQwfYntrUj0Hkm4lXyLiD92fXvNtjZoaemD6eEBH2wgtkAGdmxud6wgWpS8ADn2ebIA7zIfazRq9OShBism1SRYLBhBcL3geOjgRH+i2jgMqUoFrpCnmuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFKviae5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFKviae5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6DB1F000E9;
	Thu, 28 May 2026 20:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001109;
	bh=ODemq8dT2zJ13dPqHYdGKBGVRZ5JiRizzHMvpzCXEzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFKviae5BaP5ub/rhD/IrRepIWVAwJ3HR8/vykkKKyy2KGFyNcCqxTFQHx7VxqMyL
	 1didd/1K9nXhHhK1TpqTRny6gcvTMqJfK0oG+zAC1csy53J54JSZV6E7slxGK9YDWR
	 NNoiSi2K2rlhNB7DgDmYthgAdhwxw/FosI23rtP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/186] ksmbd: avoid reclaiming expired durable opens by the client
Date: Thu, 28 May 2026 21:48:11 +0200
Message-ID: <20260528194929.257670937@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 520da3c488c5bb177871634e713eb8a106082e6b ]

The expired durable opens should not be reclaimed by client.
This patch add ->durable_scavenger_timeout to fp and check it in
ksmbd_lookup_durable_fd().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 9 ++++++++-
 fs/smb/server/vfs_cache.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index eacc6ef41db03..729758697c129 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -515,7 +515,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id)
 	struct ksmbd_file *fp;
 
 	fp = __ksmbd_lookup_fd(&global_ft, id);
-	if (fp && fp->conn) {
+	if (fp && (fp->conn ||
+		   (fp->durable_scavenger_timeout &&
+		    (fp->durable_scavenger_timeout <
+		     jiffies_to_msecs(jiffies))))) {
 		ksmbd_put_durable_fd(fp);
 		fp = NULL;
 	}
@@ -784,6 +787,10 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	fp->tcon = NULL;
 	fp->volatile_id = KSMBD_NO_FID;
 
+	if (fp->durable_timeout)
+		fp->durable_scavenger_timeout =
+			jiffies_to_msecs(jiffies) + fp->durable_timeout;
+
 	return true;
 }
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 5a225e7055f19..f2ab1514e81a7 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -101,6 +101,7 @@ struct ksmbd_file {
 	struct list_head		lock_list;
 
 	int				durable_timeout;
+	int				durable_scavenger_timeout;
 
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
-- 
2.53.0



