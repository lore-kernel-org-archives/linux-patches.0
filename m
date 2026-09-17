Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494104F402F;
	Thu, 17 Sep 2026 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664592; cv=none; b=pBG2bmn+wC2Qd7wVPBBhA5OqnvgakiAeKgC7Qr1EgFRETSlaUD3XOD39BNMXiT9nGf2pm5QACdavB23e1Cs2mjmVSxGwsD2V7/U9e8ntARQMYlASwoPSId3m3hMbwECt1hvZyLCunV5YFqepvmWRfmz6/ujW/JBMGo9wU08nbtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664592; c=relaxed/simple;
	bh=8/mZ4nhngBHYYHZWlfu8azeHDYaIJq79pVkR3GIFOjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luHsdgWSxqjK5nxJ2l9oJ6l4Nl9E2tZRf5iRO2NLyTQq9xzAGOWUjm95Uydq6qMzl8WEP96oEVL2IrsO2rbEVfX63b6m421GkmF/ric5mAAXTYmvSddx77fihNZhLHR77+zEH58h64zqiArvuCfIF0w+1yhORN1dNqsPUNPGbVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3s/OaFC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3s/OaFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A133E1F00893;
	Thu, 17 Sep 2026 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664591;
	bh=XM41UyQDoy/zHd+Oq5bW/EImHrgWEHc7uc0HeI3HUTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3s/OaFCMDbILUH7QhFsznvt4ApRIjY8GsF5xunZqd/mx4qPcdWWStVOTJO0SA+24
	 VNXabIduVVXOKD0mb3ZyFzE/8Yj5LWkMw1m77Pc2wJuWhk4G2ojCbzvztCeIhWM7p9
	 bvGmwudBf77M44zEh14rossqh+5o+coj530wYYDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yichao <liyichao.1@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0422/1250] fuse: set ff->flock only on success
Date: Thu, 17 Sep 2026 16:03:37 +0100
Message-ID: <20260917151603.456211181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

[ Upstream commit 71947173cef279be5eed209ec28f8c11f9d73159 ]

If FUSE_SETLK fails (e.g., due to EWOULDBLOCK), we shall not set
FUSE_RELEASE_FLOCK_UNLOCK in fuse_file_release().

Reported-by: Li Yichao <liyichao.1@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index ecb03dfef1592..0812eee881519 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2524,8 +2524,9 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 		struct fuse_file *ff = file->private_data;
 
 		/* emulate flock with POSIX locks */
-		ff->flock = true;
 		err = fuse_setlk(file, fl, 1);
+		if (!err)
+			ff->flock = true;
 	}
 
 	return err;
-- 
2.53.0



