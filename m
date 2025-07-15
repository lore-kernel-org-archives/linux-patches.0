Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333FF2E3AE1;
	Tue, 15 Jul 2025 13:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587458; cv=none; b=SrtAndy77oSUPx24YfXkD8150crPJvHB10hbWmfHaD31/aJvu2EmBMCIHo3wksXuF9AHvTpqZUsvMGh7d8wSIAucxpNUB35J3Da4LGS6g7SsGtVvGFn+uUhQVR02/AU3rCzeVFKuLdcNpKgk2VURHnqa9sR4NCbr6bykAF2+J2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587458; c=relaxed/simple;
	bh=YER0xUEPTE5LGhvK+AAcZd2ugifezz6EMBcpMRKXuig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHaZMdbp77T60SYe/Zq4E5V4FuJLd0mCIos27wR6h3N0wt3qzVfUUO3ytCJ82t6rnsqIh6ZOVK6x8wfV9b+/1lqO42jmKk/cOakPMQVRtBav/ifeXhxwzBwb0qfJaSqXAIu5W6Xcl/Yh46T6goqjH6F+8EDYg+JqfaFche5tCA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgDLbWr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgDLbWr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA172C4CEE3;
	Tue, 15 Jul 2025 13:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587458;
	bh=YER0xUEPTE5LGhvK+AAcZd2ugifezz6EMBcpMRKXuig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgDLbWr9tzoacAaAKzjekzrUgaWw8PqD6Yk/4+88Ir6VwvgLWRBh9gsqSgFdU1AZ9
	 4n+vIIVFBHSWS0TqawHnxqytn0CaA60kLYTF02vYAuyfpmycYHUc7W8vmsXVFHqev7
	 5fK2LzjilcfAsAaCC2SMxFk0lPrCm4XPTp3SI30Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/208] NFSv4.2: fix listxattr to return selinux security label
Date: Tue, 15 Jul 2025 15:11:51 +0200
Message-ID: <20250715130810.932383721@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1005ecf7c250b..77cc1c4219e15 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10378,7 +10378,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3;
+	ssize_t error, error2, error3, error4;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10401,8 +10401,16 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
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



