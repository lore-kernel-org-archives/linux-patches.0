Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C144156F37;
	Tue, 23 Jul 2024 18:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759205; cv=none; b=m/WwJGAYsE1MPmx6i0+tUUo4vHzo9Jn4DmTFH8he5V5qI6xHAVLNMxMBTssoLVjxYlQ4rf27R0LiwV3C0ElCUJTgY4okgvUWNA2jYhEtXSWx4eRLg4mSmm8K8Hy1uE+wrgt6JnMK/nZB3Qcab0jLW7NtMkuRnIakII6MztovETo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759205; c=relaxed/simple;
	bh=lQkQpaFvf3gTSjN6+pwRL7GYknuYE3CH2txS7uq3YsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNUpqCWk3d1oE93pVHpQ9H8hkb7IoQV1QISKvw0hEEghIA41n7jzNlbparEi/ZeOFBk+631ipYS6T7ZvTI29iCPUDViIFFWmENT34UrtVheSiywIq1SH6v3uj/GL71pUvN/SGD8HUCNBl0XY973NTUK5gS4FIwwcjAOqPqRDEY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAq24agO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAq24agO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A9DC4AF09;
	Tue, 23 Jul 2024 18:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759205;
	bh=lQkQpaFvf3gTSjN6+pwRL7GYknuYE3CH2txS7uq3YsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAq24agO7K7fTR4kjKV6tAFTx9Rgs8FUm/nV8O8y7Ym6e2/b62p17aqkAXe+NZcBe
	 Z+AIUCgVavMxbZGmZPejBRa6u1IsJo0EeHqTjffm0ASZ9JEGL3Kro3fbAWeGLDtpzl
	 wIvPftP93u+mDz7tG3RcMGyyBX3SkWE5J5kta90Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/105] nfs: propagate readlink errors in nfs_symlink_filler
Date: Tue, 23 Jul 2024 20:23:15 +0200
Message-ID: <20240723180404.709185716@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 134d0b3f2440cdddd12fc3444c9c0f62331ce6fc ]

There is an inherent race where a symlink file may have been overriden
(by a different client) between lookup and readlink, resulting in a
spurious EIO error returned to userspace. Fix this by propagating back
ESTALE errors such that the vfs will retry the lookup/get_link (similar
to nfs4_file_open) at least once.

Cc: Dan Aloni <dan.aloni@vastdata.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/symlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/symlink.c b/fs/nfs/symlink.c
index 0e27a2e4e68b8..13818129d268f 100644
--- a/fs/nfs/symlink.c
+++ b/fs/nfs/symlink.c
@@ -41,7 +41,7 @@ static int nfs_symlink_filler(struct file *file, struct folio *folio)
 error:
 	folio_set_error(folio);
 	folio_unlock(folio);
-	return -EIO;
+	return error;
 }
 
 static const char *nfs_get_link(struct dentry *dentry,
-- 
2.43.0



