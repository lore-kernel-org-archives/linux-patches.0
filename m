Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF18718026;
	Tue, 14 May 2024 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685321; cv=none; b=H1BOzkwZSbrwU4uYRzedZLEGxbA/JituOOfVFS1sif9YuxM1+PByJb76l74J/0u1ejqU8FPAAl89ugaIy0sBY6RNewS5nRWbOAIJd4jM/1iv4ygwm8fsWNkw1f33+yiKO+w6+XkDa9T6RdcUb/qrwek0f7iynLzKtL/WOO3dWPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685321; c=relaxed/simple;
	bh=cHXfspJOU2bd4g2pg1wKrNvVahctK1sXMGE/4ngtVYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp1rgct0Fw6IufYfsTb+15egQGneY8Q25vBsjiwvd8aGvH3s7brQG+BMKu70FbEqkd4a8UgXGXyfrNdonEBPxhRuM6L1XFwoekSDtUJvxFkC2QpuCp5QzwfVKyZv2bhLqQ9c+O88k5l4cCaoWCplUpx5uoJ+TxJewCE2yfFAU70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQMUkJwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQMUkJwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30EEC2BD10;
	Tue, 14 May 2024 11:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685321;
	bh=cHXfspJOU2bd4g2pg1wKrNvVahctK1sXMGE/4ngtVYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQMUkJwXhUnUyCUiHsz5w/igLyzzmI7habAepyy+dk8+LZpD/m8wy5AqMmonM6iSJ
	 xa2wOTl/ZxK0WL9pfnIXgZ8T4uT0NlTpqP+FzCZXMV5xasvIBxpx56u42DtTthMo19
	 YKh0O8+sFKpUvCSOqEUjm+qAGcDgfoDkssMIPRcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/301] 9p: explicitly deny setlease attempts
Date: Tue, 14 May 2024 12:17:12 +0200
Message-ID: <20240514101038.336553958@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 7a84602297d36617dbdadeba55a2567031e5165b ]

9p is a remote network protocol, and it doesn't support asynchronous
notifications from the server. Ensure that we don't hand out any leases
since we can't guarantee they'll be broken when a file's contents
change.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 11cd8d23f6f23..8566ddad49ad5 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -591,6 +591,7 @@ const struct file_operations v9fs_file_operations = {
 	.splice_read = v9fs_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync,
+	.setlease = simple_nosetlease,
 };
 
 const struct file_operations v9fs_file_operations_dotl = {
@@ -605,4 +606,5 @@ const struct file_operations v9fs_file_operations_dotl = {
 	.splice_read = v9fs_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync_dotl,
+	.setlease = simple_nosetlease,
 };
-- 
2.43.0



