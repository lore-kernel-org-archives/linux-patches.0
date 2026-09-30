Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3F535C68C;
	Wed, 30 Sep 2026 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782683; cv=none; b=U6Y5lFg3jTE/jNG6jbunrmX6QhsHHEr0TeWP0/n9PWy0fWY7fKrQ7C9ZV+eKlK+bQ5f1wuEzbzMzl8TiftIpsZREiBe9f4VDtAh6slQhd5H45WyaRDtva1Gk6qGogmKnupxVTO9TRaef6P0Xjt/4HIhnwqJdEsK+7cGxcFHpzYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782683; c=relaxed/simple;
	bh=rqB1hoi+uuueK1E6LJGwH18eUBlK628TrpUIFdrJ4lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ar8LinFMf/OdsqknIlWn7HokYUsFtjWqZS1xdUL4nLZMKVlXNgjf1hqYQpcU0mdDh88cEAIY8LJ5hO9GT8kqm7XMpSSw2IKkwfpRjQyzQ8AtwZjxR+STguf9XQqTBWzXAuWtpFvg78Ex+Ohf+Ux8uOGIbCK4fcTKadJPJ6XsOEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mR3JKgWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mR3JKgWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35451F00893;
	Wed, 30 Sep 2026 15:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782672;
	bh=iW+oWpa+QtB9pbKLvWa4isK1E2Mz8szwQbkFnPreS0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mR3JKgWGqF+T/Ulmy4Vv48hUhI12jczzTkcEvewRnbsyjlfOjqcL/96RcV96QFfin
	 UywTb+ANtqCQ2kY9Vq4dApn1pz37eSd4JOtXvLEHqzDf3VLbk5HeybbxSylUvklEMe
	 VREamFpAjpvXybv08AS5nEAQAnHx49W6344GDzGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yichao <liyichao.1@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/595] fuse: set ff->flock only on success
Date: Wed, 30 Sep 2026 17:20:23 +0200
Message-ID: <20260930152350.534169936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a8c080b485d03..956c01a42d31a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2570,8 +2570,9 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
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



