Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3312EE29D;
	Thu,  3 Jul 2025 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554618; cv=none; b=Y0B4mBFka/GA6Zm5QiVB+H+N79p7KxYBnaGW4DgstG86BsQ+VM2MfvgUa1oZ5sZO7XH/Wrxb+b6ZnFVbp9YlhLhypO0y+vr6OOi0nNmwMleYRiRzxKfaziEXbH3K9ivA0FsWuySqhEjsvI37fTAP73AqdjQBy8UOFUVkdLhZlHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554618; c=relaxed/simple;
	bh=DzWFJI2qv/rTSmYBqEKPtBT78nHJz7KyGqmv7VSxykQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG10TYakP+uV2UnDNIN6g/V12bwCpajgq0Cm3z+57DKjQbcqNHVxG/NmMxq4zpq6vZvaFcWOSxrKpAiYyihOd3oHmp8V/UiEg1beZMlUqvjBtXbxk98+IhQ8h7ei+niVeOZbA8lCUJOrw5mHXr0uRuzgLGRekYBZrICt056SKfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fo2fjIvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fo2fjIvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70C0C4CEE3;
	Thu,  3 Jul 2025 14:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554618;
	bh=DzWFJI2qv/rTSmYBqEKPtBT78nHJz7KyGqmv7VSxykQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fo2fjIvydUtAvoiQPG0/L+b7YKK02mGSjGbh6wP2KDF6HPqRCJ23CkrweeX/J7HRu
	 uKvxG5QuY03QtvkppFC2B/xTRph6FQcCknvWX8wbdQ8N3JV7JyjpADqVoqMKQ5BLRh
	 dYtV/7EnAYhqjeknjbKHCbkUpFWnrUOsfV3/7N8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 005/263] NFSv4.2: fix listxattr to return selinux security label
Date: Thu,  3 Jul 2025 16:38:45 +0200
Message-ID: <20250703144004.510803666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 243fea134633ba3d64aceb4c16129c59541ea2c6 ]

Currently, when NFS is queried for all the labels present on the
file via a command example "getfattr -d -m . /mnt/testfile", it
does not return the security label. Yet when asked specifically for
the label (getfattr -n security.selinux) it will be returned.
Include the security label when all attributes are queried.

Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 9db317e7dea17..56f41ec327397 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10861,7 +10861,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3;
+	ssize_t error, error2, error3, error4;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10884,8 +10884,16 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 	error3 = nfs4_listxattr_nfs4_user(d_inode(dentry), list, left);
 	if (error3 < 0)
 		return error3;
+	if (list) {
+		list += error3;
+		left -= error3;
+	}
+
+	error4 = security_inode_listsecurity(d_inode(dentry), list, left);
+	if (error4 < 0)
+		return error4;
 
-	error += error2 + error3;
+	error += error2 + error3 + error4;
 	if (size && error > size)
 		return -ERANGE;
 	return error;
-- 
2.39.5



