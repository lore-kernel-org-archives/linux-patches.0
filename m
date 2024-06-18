Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350C16B3B7;
	Tue, 18 Jun 2024 12:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715307; cv=none; b=N/NHldUqJH11Fowm+n1OnzooZwe1rRAWhGfqdw7yfBD6KELWGwtV/GYDLgdVgLYy9uoahbcSYpXmbK1ATdVYwYpB+F9THEFolNYQYCtjXgxsCS1rOLDCDkwXX0Nj26Wm34rLrdIBgIt58ZxDexZ/ayeTqDsky2PBZwCcKecxfl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715307; c=relaxed/simple;
	bh=AwKf2XxGZKEIgQpYH/UjSTLFFCPJhf+0+cn5VS2g9Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tICmpP5a9HXw0dVG4+7v+yVQ649+9hiotCAn/sOjl8HDVtz7RkEW8gl379Q2axL7lTiG/XwOBC0+osF4TwBZ9AVjT1Hexc7086R7lv3dAI0xtE04keQrFI7IDD2HzjbguasG3puTjKXd87NEP7bMAvtku3wFTbuJK/orFvWTIYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1jR014H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1jR014H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32887C3277B;
	Tue, 18 Jun 2024 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715307;
	bh=AwKf2XxGZKEIgQpYH/UjSTLFFCPJhf+0+cn5VS2g9Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1jR014HhMLIkQ4/A85yaUtqrDUNR6pSY+Pqg8F6fvakJwOigrO/IU6CkOVLkoWUg
	 AYBAcNmEHV5eOJCi6LxDWlXTKkCDF/lyNfT5yfQ2QW2V507rLmeIJ59it0oSXS7eWP
	 cS0iOdsBM4kb7DfVrPyxAyAMGi+riIVk49DzKrDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/770] nfsd: Fix fall-through warnings for Clang
Date: Tue, 18 Jun 2024 14:31:57 +0200
Message-ID: <20240618123417.463372150@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 76c50eb70d8e1133eaada0013845619c36345fbc ]

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding a couple of break statements instead of
just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 +
 fs/nfsd/nfsctl.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fd0d6e81a2272..ea68dc157ada1 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3161,6 +3161,7 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			goto out_nolock;
 		}
 		new->cl_mach_cred = true;
+		break;
 	case SP4_NONE:
 		break;
 	default:				/* checked by xdr code */
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 147ed8995a79f..cb73c12925629 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1169,6 +1169,7 @@ static struct inode *nfsd_get_inode(struct super_block *sb, umode_t mode)
 		inode->i_fop = &simple_dir_operations;
 		inode->i_op = &simple_dir_inode_operations;
 		inc_nlink(inode);
+		break;
 	default:
 		break;
 	}
-- 
2.43.0



