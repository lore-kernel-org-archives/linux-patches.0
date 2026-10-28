Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215953;
	b=I/aVfWZBAKft6+wOygJsaRh3Y0Bzg/3XB+KXswB/vmsVUmid2ru3bPhHVZOOQmaCE/W3
	 gsMeNKT6/wsUsOQW191fQcxiPCT/+BW6nSR27Qo7F8SH+5vHYaOoA3QUj4iDvG6etNsJb
	 oB6t757GbbCmxDsZ+lqV0dXDZjKdDnX7OOWFwE/YNTU7CK+u8+MOttesiuKCmRUG5CqcF
	 n7SfUYb2S3poYRJ47N0NJ3fJ+xKYzNWMqBF9vAOrNvAvy97yOlEpdR6liaGy3dYBO8t/s
	 iZn3tMY1ONqzoHyCtaf7/VshUjaAtUT3Nw/zXwxg8lCrobI5g6o6D0S41bB7GtRbN8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XbFM46OUV9j440ALSIkTZNxD9rv/6QcyY6EhyXTzbpQ=;
	b=AeWAAsDp6qBbATkfyiUwtkR9liELeDJ9HcD75tJ+N0rxshemvJg4sOwvSgyx3fGwu3U6
	 XEgu8iXDw975ZEZYSJzIDDlxdND2Si1GpdpONKx71pgWbtW2TcgBG0O60uf/IDx7qehYk
	 faxxx2+MnYhuAzXpi6tvY5QvlKr/bDn4ElFvhw0YhMORc78SRwr9TUEz3llZ/KSm1xxUL
	 HdYAFVLaw8kXIOOUxTyt4uudyVKZQ0ndlb/kQpWP7xyuHdSmXbPCilIGzwooakjVqIH05
	 MhMaCiS/E6uKIs4UPp4cShcETVi7Mlh+2o66i885S+x9bu/ww2qdWqCYqZXVmTvQgGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/37SlyA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D617606A31A;
	Wed, 28 Oct 2026 19:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/37SlyA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1C91F01825;
	Wed, 28 Oct 2026 19:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215953;
	bh=XbFM46OUV9j440ALSIkTZNxD9rv/6QcyY6EhyXTzbpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/37SlyAcOhIdH5kXH8Un8Gbqi914pHTc8xynw/38h5o/d/jqTMK4j5D57FXe0F1O
	 VvvU//7a7rZCponle/dPHQOC/WeuhRLJ9DqNlCINZrQ7AacGio0zovjbfB8r4I+RTH
	 eRElgw8HAohdApOwtUso5F2bE7KdY+cjCMev6Ttc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1390/1887] lockd: fix NULL dereference on lockowner allocation failure
Date: Wed, 28 Oct 2026 17:58:06 +0100
Message-ID: <20261028170531.082028602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit 4c7fc129db061c7daab841c4f3c342d894832362 ]

nlmclnt_locks_init_private() installs NLM file lock operations even when
nlmclnt_find_lockowner() fails to allocate a lockowner. nlmclnt_proc()
then returns -ENOMEM, but the VFS still tears down the partially
initialized file_lock and calls locks_release_private().

That invokes nlmclnt_locks_release_private(), which dereferences
fl->fl_u.nfs_fl.owner and crashes because the owner was never installed.

Clear fl_ops before attempting to initialize the NLM private state, and
install the NLM lock operations only after a lockowner has been allocated
successfully.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/clntproc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index 99fffc9cb9585..7f867122e3883 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -479,8 +479,11 @@ static const struct file_lock_operations nlmclnt_lock_ops = {
 static void nlmclnt_locks_init_private(struct file_lock *fl, struct nlm_host *host)
 {
 	fl->fl_u.nfs_fl.state = 0;
+	fl->fl_ops = NULL;
 	fl->fl_u.nfs_fl.owner = nlmclnt_find_lockowner(host, fl->fl_owner);
 	INIT_LIST_HEAD(&fl->fl_u.nfs_fl.list);
+	if (!fl->fl_u.nfs_fl.owner)
+		return;
 	fl->fl_ops = &nlmclnt_lock_ops;
 }
 
-- 
2.53.0



