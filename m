Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC1D2EA46B;
	Thu,  3 Jul 2025 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555949; cv=none; b=g9t6Tgn9N0Vdbn9Qpbdgihov+cwAaxR1cPSdEwknoEVsIJ0PTmxIj8EiVwW2TuN9TmyXmaAf5Uleaoz+SnKklt01yMZz0/qHbz5xlT3PGutMRLJiItX047jQ6Zi7dgYP+WyY2If1mtPGLBE5DzlUe1JzVebUmpLvvtDRGpz5FnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555949; c=relaxed/simple;
	bh=QIvewqaeZp18IOrM8WgISCIuB39S95FMd5gD0/h66XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlabezAlrcfRgO9Gba6xV0QaDiIi+McHI2tAXoyAXIRJ2MW654kdd1o8xfmRLDsAS/i+iZ5cV54DSzi/0zrFrwpkouh9d4e3oPlZ/A1E44+IyR4OfJn8Ldu4dTQt/8twfM+aSFbP29I0wdEm3jiz/AotK0AU5wm9IQlG48mLv54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taQiBtE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taQiBtE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F07C4CEE3;
	Thu,  3 Jul 2025 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555948;
	bh=QIvewqaeZp18IOrM8WgISCIuB39S95FMd5gD0/h66XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taQiBtE6cJouqMi9eYZzUFtw+1cK4YzMYjdbnVutuMDv/R7sEjnF4eX5nUJlDfhtQ
	 pFDNB7hVFrcOnHBHssyiQbmJKjObiFeM0HDjbj9yWkRWnr3lAYUL54fhJqVwibv3mQ
	 frjHIINbcvcsI2sGldgkBBJzZ6Pvaat0Ue4L6qRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/132] NFSv4.2: fix listxattr to return selinux security label
Date: Thu,  3 Jul 2025 16:41:33 +0200
Message-ID: <20250703143939.557103925@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f28607c57473..2d94d1d7b0c62 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10630,7 +10630,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3;
+	ssize_t error, error2, error3, error4;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10653,8 +10653,16 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
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



