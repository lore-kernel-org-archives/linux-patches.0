Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D0C157A49;
	Tue, 18 Jun 2024 13:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715900; cv=none; b=jPZjwlN9o1tsujy0jumolVgH+9aPrD6/PTuCteJpKj6g7oEWuUG7RPrzSpPJqeBAtYv+QnCpjwA++KtmomwC27/3cqqNiFh6Yshed4djpeQXf3J6q4QyX8rVc/QCTf8ROigU2xUiWWpFpAYC8XgQbH6dlSLDn9/T2oNJ/Z74CBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715900; c=relaxed/simple;
	bh=dE7/mZnsAH7pz0/A31iCopCjdrMiNu6PbUPEr2aCnGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaLmtFo/m1Wz4R/iOljjRu2bB7uSzrw+BNNKokyBWYOuwbwDXRdK7LAxuEoOeew7n+gWEQfV6GiTW7QJlLInBGDcqMlQNjCJ7A4PWjqLJP+LcTQgjIr2CnQpzKpzGvxgwGPK5fo76kIrG/PKDhxldCZH2BD6QptwDARAplX8mH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0GEjUN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0GEjUN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5B9C3277B;
	Tue, 18 Jun 2024 13:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715900;
	bh=dE7/mZnsAH7pz0/A31iCopCjdrMiNu6PbUPEr2aCnGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0GEjUN2wkhEu0BOw/jCgnnvrlT0CYcPB89Ti6sGOAkBIBfTj+YvW0f61i5rBZ6CP
	 W3YNuE3rzus6UTYLPrOHkjgYUFmTWz2mJwxsC6T/eyzX2hEd9vP1f6Tl2niUHGL8vV
	 csoPWyOJWTlnit6zcarQvQ94qirL7janBIMVjFH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 464/770] lockd: fix failure to cleanup client locks
Date: Tue, 18 Jun 2024 14:35:17 +0200
Message-ID: <20240618123425.224382897@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit d19a7af73b5ecaac8168712d18be72b9db166768 ]

In my testing, we're sometimes hitting the request->fl_flags & FL_EXISTS
case in posix_lock_inode, presumably just by random luck since we're not
actually initializing fl_flags here.

This probably didn't matter before commit 7f024fcd5c97 ("Keep read and
write fds with each nlm_file") since we wouldn't previously unlock
unless we knew there were locks.

But now it causes lockd to give up on removing more locks.

We could just initialize fl_flags, but really it seems dubious to be
calling vfs_lock_file with random values in some of the fields.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ cel: fixed checkpatch.pl nit ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 54c2e42130ca2..0a22a2faf5522 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -180,6 +180,7 @@ static int nlm_unlock_files(struct nlm_file *file)
 {
 	struct file_lock lock;
 
+	locks_init_lock(&lock);
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
-- 
2.43.0



