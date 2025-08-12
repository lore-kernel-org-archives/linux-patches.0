Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27B2C21E3;
	Tue, 12 Aug 2025 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024906; cv=none; b=Xkt9j7s8iLjarRXeaEUvUtHwV5pkIEanBGYSnTXfes/j+I6p00Cglj/cTIoXcCWcabE9FG+ZI6DEH8uf1d3OJfm0Pa9GaiCKr2pfwZ8SsGNoFOoCUCAByNRui2+xQM27wMPbBSUu4RtHRhbUpUbB+KlJF1HoWUUv8QZuem1EU1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024906; c=relaxed/simple;
	bh=Up4ev/schYc9AWAzJWrMoOGyqaqmyPZJgDyHopaJ9Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP24UHPpthOZEPAVLsMLncNRS+itvfnE2oQnYAhVgjAOlnPPU+E0RgTPXzsOtV6K1XCNI5wWsQJ3acclQLfju46TJQ+xwTSYRqf2oInjRHw9lCLQuPAIxVaasdFJqYy8Pqq255Evuwevt8DYwmTnQekeJKWg7cje9Mb0Jv4ifWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DpZaDoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DpZaDoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D62C4CEF0;
	Tue, 12 Aug 2025 18:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024906;
	bh=Up4ev/schYc9AWAzJWrMoOGyqaqmyPZJgDyHopaJ9Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DpZaDoanKbCEi8AMKLtaZZLE4jNIuHN+O3tkJdJ523GxaSxhDeks4tL+KhGY9bsT
	 8VQfb7UP77igK3YdE/+Ftt0Av4q0PFdVpHgLgVLxAdWkpWcn2LDBanK5l6QOLBYu4W
	 mup6y4G0b+WSH66qFnNzy42TxcOuttEL28jqVJnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 511/627] NFSv4.2: another fix for listxattr
Date: Tue, 12 Aug 2025 19:33:26 +0200
Message-ID: <20250812173449.210186206@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 9acb237deff7667b0f6b10fe6b1b70c4429ea049 ]

Currently, when the server supports NFS4.1 security labels then
security.selinux label in included twice. Instead, only add it
when the server doesn't possess security label support.

Fixes: 243fea134633 ("NFSv4.2: fix listxattr to return selinux security label")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Link: https://lore.kernel.org/r/20250722205641.79394-1-okorniev@redhat.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 341740fa293d..811892cdb5a3 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10867,7 +10867,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3, error4;
+	ssize_t error, error2, error3, error4 = 0;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10895,9 +10895,11 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 		left -= error3;
 	}
 
-	error4 = security_inode_listsecurity(d_inode(dentry), list, left);
-	if (error4 < 0)
-		return error4;
+	if (!nfs_server_capable(d_inode(dentry), NFS_CAP_SECURITY_LABEL)) {
+		error4 = security_inode_listsecurity(d_inode(dentry), list, left);
+		if (error4 < 0)
+			return error4;
+	}
 
 	error += error2 + error3 + error4;
 	if (size && error > size)
-- 
2.39.5



