Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AE92F235B;
	Thu,  3 Jul 2025 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555506; cv=none; b=QT1k6jDI/MHayRAtd2ah0swTGcVz45NoHg85oLimM/rze6TvhLxny71ZkuupsoPBfRqO3SCovzy54yPhOmD6NEjixG7dXVKwN90isRZD2VYQxrRJJN/FGtKe2zJ0BUeNbYep+U4JfyF6migdi327qAg31PJBJzUiKOtVsE3DcgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555506; c=relaxed/simple;
	bh=pJfEMZFqEcsy0Kfr7O0xcpoIOhbFZwYAvaDBH7yneus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tiv1nvO9FHC4aGg9EkHp/3WR4+md84ScaUV+Plwctq9oImWs0BMtMIuRETyRYgAX9DwdhTsltXoAfPuZkUJOSzWHzthqrr8pi3a3++xca2iDNF2TkHepJbNWBlY9VtcdK72HDZ9uot9+3nlTXnrZTe/ffDXcd8BJEWoc2WZwM1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seF0uELU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seF0uELU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A244EC4CEF4;
	Thu,  3 Jul 2025 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555506;
	bh=pJfEMZFqEcsy0Kfr7O0xcpoIOhbFZwYAvaDBH7yneus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seF0uELUQ6vIGC1h6GssOIAnve39MWrV+w/DMsAlzsW5FU3scBeYkB6d/5yhHqNEL
	 Uq2eRQIhth0czXIxG0QiNd2luEr17/FZGFcYnMblk74SHgIZ+mBIj9wAO0Y/1UacOw
	 3pv5PBLP8i8xS8LOC5zIhKo33qlojGTnUv9ePb4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/139] NFSv4.2: fix listxattr to return selinux security label
Date: Thu,  3 Jul 2025 16:41:08 +0200
Message-ID: <20250703143941.392619173@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1b94a55215e7d..97a009e007f95 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10625,7 +10625,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3;
+	ssize_t error, error2, error3, error4;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10648,8 +10648,16 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
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



