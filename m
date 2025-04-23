Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6B41EFFB9;
	Wed, 23 Apr 2025 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420129; cv=none; b=BmTLAJVaEIOMz/qc4T8Ys+82HocpPlfFgXuGD9RlNbQU90EF9/6hEHLbnfJF+IeBiZNJ0aiE0g+vg0W9XxqAFthiwDVJo7fNLx7d3LIyOR1FE3CGoq+siyYL8OV036DuunXXq0sW/IiD8LJlk0oeRobZd6XHPiTQrPc3EwlcExk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420129; c=relaxed/simple;
	bh=C7kzoWcXQoWVR0Tei/zS5JFLNPBkC/mJVTRNxIi08wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WawdIP6dNl6bhzWRXwJ9IVXPWxjNJIhhofEdUR5RZQTkE3Ke8z2jq6AI7hFJxaEjYdEpHo8cIJgDQGg0DI99+Mu1tXPRl1ZvXNSIlDw4OJ3THhyGEQ2vzZG7V0jYpANOorfMMDTqTS+F/ypxeDT6zH0DTU03lhwmtKEAHNf09aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeEeWv+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeEeWv+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97302C4CEE3;
	Wed, 23 Apr 2025 14:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420128;
	bh=C7kzoWcXQoWVR0Tei/zS5JFLNPBkC/mJVTRNxIi08wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeEeWv+HBDCSSJwwfTSkUs/ym8UCbfPqxpqyhRFYwJwFTMJb+rwTnynbCUBM+jQjC
	 Q+9QCy5mmdPAxn4uGmowV9266Z0y9z1LD37UgBJNclHqcoDy2exTEPJg7cesZQMh02
	 c0gSb8TGNNmvd2XxUon+F7gZcaKCvSsBZT6h47KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/223] fs/stat.c: avoid harmless garbage value problem in vfs_statx_path()
Date: Wed, 23 Apr 2025 16:42:54 +0200
Message-ID: <20250423142621.267815264@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 0fac3ed473dd2955053be6671cdd747807f5e488 ]

Clang static checker(scan-build) warning:
fs/stat.c:287:21: warning: The left expression of the compound assignment is
an uninitialized value. The computed value will also be garbage.
  287 |                 stat->result_mask |= STATX_MNT_ID_UNIQUE;
      |                 ~~~~~~~~~~~~~~~~~ ^
fs/stat.c:290:21: warning: The left expression of the compound assignment is
an uninitialized value. The computed value will also be garbage.
  290 |                 stat->result_mask |= STATX_MNT_ID;

When vfs_getattr() failed because of security_inode_getattr(), 'stat' is
uninitialized. In this case, there is a harmless garbage problem in
vfs_statx_path(). It's better to return error directly when
vfs_getattr() failed, avoiding garbage value and more clearly.

Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20250119025946.1168957-1-suhui@nfschina.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 777d0961ff95 ("fs: move the bdex_statx call to vfs_getattr_nosec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/stat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index cbc0fcd4fba39..b399b881bbbf9 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -246,6 +246,8 @@ static int vfs_statx_path(struct path *path, int flags, struct kstat *stat,
 			  u32 request_mask)
 {
 	int error = vfs_getattr(path, stat, request_mask, flags);
+	if (error)
+		return error;
 
 	if (request_mask & STATX_MNT_ID_UNIQUE) {
 		stat->mnt_id = real_mount(path->mnt)->mnt_id_unique;
@@ -267,7 +269,7 @@ static int vfs_statx_path(struct path *path, int flags, struct kstat *stat,
 	if (S_ISBLK(stat->mode))
 		bdev_statx(path, stat, request_mask);
 
-	return error;
+	return 0;
 }
 
 static int vfs_statx_fd(int fd, int flags, struct kstat *stat,
-- 
2.39.5



