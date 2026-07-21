Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C951F3D56;
	Tue, 21 Jul 2026 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653719; cv=none; b=IeTguYcA2ymvkOa6aly3jb6fwY5/DSaYbQ2qNNuKoiYMid0L45e3sGm2S1HMrCwxYXREFiMFk+B98JxxXotoutU24s1cFhMbqmw4QEwy4wkAfMPhnJ4zYl6C4rSVj7LMCDUSVII4S+6cvKaa4MZHKm8Ze75R8CbVP2CsMa1Hw88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653719; c=relaxed/simple;
	bh=o5Yle12qqW+Nj81jEckKfJR+9Y1uCN40oIpvkYw+Pps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hyn14Gw4MwPSXyXtXGEoE59LubxAQyZiiN1/tF0RAb9sHL5ApU2vHSRLB0OGGdhvIQYgYpa9LCxa2aeZHi5V80b3XPB74qPJ0xvBYL8WFtRsU6zm6lXleL07tA1OfwukZfzpWnwFpBwH9P2RuswBkH/3VhqO0HVJPjpx0INBd0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbUHzSKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbUHzSKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F001F000E9;
	Tue, 21 Jul 2026 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653718;
	bh=8Hzv+rntQSBSN0lXMRxbV1czOzwFj8y8fQntFBgSpGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbUHzSKG1RjSVIjXdbzZUtMY9N/UdtRTR854cDhTyjedFuAVxf/s1PQ6eWH4nkyrf
	 U8ettUH+p0O9L8ybkIgL2UarY9XwcbXJhjJ/YtiRk0qKQbqMiIvdsH8Q1rNWJauCMJ
	 S9Pq/9AGVmLSr2DQyLppB5/OCojmvMCbYXp5deQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1390/2077] cachefiles: Fix double unlock in nomem_d_alloc error path
Date: Tue, 21 Jul 2026 17:17:43 +0200
Message-ID: <20260721152625.599146885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 8c256fba2b46020004201c500b2a1fbc707a33ef ]

When start_creating() fails and returns -ENOMEM, it has already
released the parent directory lock in __start_dirop():

    static struct dentry *__start_dirop(...)
    {
        ...
        inode_lock_nested(dir, I_MUTEX_PARENT);
        dentry = lookup_one_qstr_excl(name, parent, lookup_flags);
        if (IS_ERR(dentry))
            inode_unlock(dir);  <-- Lock released on error
        return dentry;
    }

However, the nomem_d_alloc error path in cachefiles_get_directory()
unconditionally calls inode_unlock(d_inode(dir)) again, causing a
double unlock that corrupts the rwsem state.

This is a leftover from commit 7ab96df840e60 which replaced manual
locking with start_creating() but failed to update the nomem_d_alloc
path (while correctly updating mkdir_error and lookup_error paths).

Fixes: 7ab96df840e6 ("VFS/nfsd/cachefiles/ovl: add start_creating() and end_creating()")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://patch.msgid.link/20260617085049.730789-1-zenghongling@kylinos.cn
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 2937db690b40b5..2c46f0decb02e4 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -209,7 +209,6 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	return ERR_PTR(ret);
 
 nomem_d_alloc:
-	inode_unlock(d_inode(dir));
 	_leave(" = -ENOMEM");
 	return ERR_PTR(-ENOMEM);
 }
-- 
2.53.0



