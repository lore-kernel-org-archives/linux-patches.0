Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F082E4ABBAF;
	Thu, 17 Sep 2026 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668115; cv=none; b=X7IiFMT3AuCsICdV1qdR484skDpJ5n8Ihz2umY/7Jwu2ISd+nUYz/Oy4nngWaNSjbJvQIMF6AV3rcqPKjiAXHtsOOUf5FB7ohP4FJrEyKK50aqIdXBjnzL43TyQ2JDeg2kCdS4S2LyepX3rtwB6uZkro1Q/J8JIOF+ncn4V8gY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668115; c=relaxed/simple;
	bh=NZ0zssxdLfZoUwEf+LU34vW/GLJaKaZ3xOdQ70f9bi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMVT7+1zLhR+zk6AvpDc1OW5XlMtUj17J3jf5pEl4kWw6IY5Yv8kQmJsqg1nRyXcRQxxBprb9z58lLqw22PxeqAuvT3rcJh4EUaGUZ4nHoyaubyMj0all6uRng3ECmbtVAAXKqkTXwc1XixGkj2jY+rrawQ94a1rVatsmdeg5nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S96iJJtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S96iJJtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BF31F000FF;
	Thu, 17 Sep 2026 18:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668113;
	bh=7K8C/HE4QuB5i8mhXsvA9tZyYU6w/+bemCZ3kBpqzLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S96iJJtZqZDnto3ZYq6AWlxEHcXZKJde9mDHqm7j79tHTOCCxWLuCLyNHYcJqCdik
	 CcLDbfjDr3+2s1f6Y9A9bAdYc6enVN896o/X0uV15yV+ed6Ncuwkp54oLvWiwPx9Ol
	 rFaFn8lZBpOJYZ4f/xuc+Li+gOfsNf4b3hzZNNB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yichao <liyichao.1@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0317/1102] fuse: set ff->flock only on success
Date: Thu, 17 Sep 2026 16:04:20 +0100
Message-ID: <20260917151547.582170576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a03ebfc55ee06..33ba8ae3b8c22 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2794,8 +2794,9 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
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



