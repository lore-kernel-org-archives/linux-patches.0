Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64264155736;
	Tue, 18 Jun 2024 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715870; cv=none; b=VmCMY9n6tUYv6yMHafVFSisB8xnYjLNHWbaUzYMoZNaQdJ0rhQSZSdQzGmivmdzG8B9s/rjRnw1omZMTo25V0gkorPw/V8+X6jGg3UQgsfmz9uQUln3jv1fyi23I1Gipy9R4OlZzrbjO64HS8enaNnli3TDoXRSJGKrgKO4sASg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715870; c=relaxed/simple;
	bh=xXEbCIe0GdPRuGeBgkvobtHY2auYR1ojDefAAO/L1lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blFN4sq4aeblQNmOdxhnjiueKd+K9njSRSmnq4aznDnCbybsYn8/irGKKOGhE8qkOetjhUc77doOhY+moxoYOdiJQ2q+BVfT0OBWINd5uUpYLY4PbN3yWo8ZNDK1Myu8JCkcqa0HVIkEqcAlFJ2xJyQKfSbztQQSGxVpQZxs00k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnNpwYjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnNpwYjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8C3C32786;
	Tue, 18 Jun 2024 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715870;
	bh=xXEbCIe0GdPRuGeBgkvobtHY2auYR1ojDefAAO/L1lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnNpwYjbg5ZEWuvwgJva37/guiOWGMfxDET9qs14eIStA8kB50MRs5PSarlpHUKEx
	 GDLU8FNTwr5jY/4C68D3dyYFIamrAa5fJB53yQQrnu/R5RJoG+6tpg00Guu7Cf0rYe
	 xUAzJMILmYIsUU2YnVUPEuXD4bqJ6hdWvXbmZdVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 455/770] NFSD: Write verifier might go backwards
Date: Tue, 18 Jun 2024 14:35:08 +0200
Message-ID: <20240618123424.864888392@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit cdc556600c0133575487cc69fb3128440b3c3e92 ]

When vfs_iter_write() starts to fail because a file system is full,
a bunch of writes can fail at once with ENOSPC. These writes
repeatedly invoke nfsd_reset_boot_verifier() in quick succession.

Ensure that the time it grabs doesn't go backwards due to an ntp
adjustment going on at the same time.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 8554bc7ff4322..4d1d8aa6d7f9d 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -363,7 +363,7 @@ void nfsd_copy_boot_verifier(__be32 verf[2], struct nfsd_net *nn)
 
 static void nfsd_reset_boot_verifier_locked(struct nfsd_net *nn)
 {
-	ktime_get_real_ts64(&nn->nfssvc_boot);
+	ktime_get_raw_ts64(&nn->nfssvc_boot);
 }
 
 void nfsd_reset_boot_verifier(struct nfsd_net *nn)
-- 
2.43.0



