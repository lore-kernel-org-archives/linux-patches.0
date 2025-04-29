Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE9E242934;
	Tue, 29 Apr 2025 16:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945919; cv=none; b=QMvK5waSdAXL6zdr1TBhHrg8vMzKH7+B8CaKLkFy8ok3x3EazgC7feDWLTwGFY8SksMyhPHorZzCjugK7yIl0rlEnJR5BbmkMyh6HgGfKd6OVHn5lhMP3h5BhWBYyVLFy8lnf/m3BNTAH2sIia6ZEimQZ8vPf2sHtxbqjojP9X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945919; c=relaxed/simple;
	bh=9I0B8w/G4c0/64z6orstxrhfxO1RYiHHdJxmzo3eeC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imGFkXBBKixWhnmo1jkZyZdEqP9iy9egmpWxKgXEFSfO3VXvuKE7Pf+tll+CSYZTs4C5TfeH7yL+17fTds1lNkRTcFozQL4axQO27040rpD4/rNa9Tc1QgBSvtJqhzHh5NZS3HFJqpeoUgF6tpejiQtBXyudzlfT+UuAIEEmMUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKF3w5VP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKF3w5VP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C23C4CEEA;
	Tue, 29 Apr 2025 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945919;
	bh=9I0B8w/G4c0/64z6orstxrhfxO1RYiHHdJxmzo3eeC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKF3w5VPQg1AQ+i11RUQoib9Qn9lQsZ4AZ6wZ5x3OvQN1rf9Q9Lmgxkqmyy6wBCr6
	 3rpHICxRuHKLbHUOJ8iFVhR5qXkO7fkHHoZQZRWbArZKVn5F/y87Y+vn+Y8gHyFNHQ
	 q0hNYVX5EjIbeyj8O2WIkPFlHXsvW/DXx9sZEUK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 094/311] fs/xattr: Fix handling of AT_FDCWD in setxattrat(2) and getxattrat(2)
Date: Tue, 29 Apr 2025 18:38:51 +0200
Message-ID: <20250429161124.895028009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit f520bed25d17bb31c2d2d72b0a785b593a4e3179 ]

Currently, setxattrat(2) and getxattrat(2) are wrongly handling the
calls of the from setxattrat(AF_FDCWD, NULL, AT_EMPTY_PATH, ...) and
fail with -EBADF error instead of operating on CWD. Fix it.

Fixes: 6140be90ec70 ("fs/xattr: add *at family syscalls")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/20250424132246.16822-2-jack@suse.cz
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 02bee149ad967..fabb2a04501ee 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -703,7 +703,7 @@ static int path_setxattrat(int dfd, const char __user *pathname,
 		return error;
 
 	filename = getname_maybe_null(pathname, at_flags);
-	if (!filename) {
+	if (!filename && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
 			error = -EBADF;
@@ -847,7 +847,7 @@ static ssize_t path_getxattrat(int dfd, const char __user *pathname,
 		return error;
 
 	filename = getname_maybe_null(pathname, at_flags);
-	if (!filename) {
+	if (!filename && dfd >= 0) {
 		CLASS(fd, f)(dfd);
 		if (fd_empty(f))
 			return -EBADF;
-- 
2.39.5



