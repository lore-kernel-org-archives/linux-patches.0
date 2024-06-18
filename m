Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BB41A00FC;
	Tue, 18 Jun 2024 13:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716150; cv=none; b=dCmNAKaR7qShaB0+RBr5R/SMQlpis00JF7hB4VvgKqhxc967vjg6bFIxnGBHGWH/e1A+o4Ufx5/cWdMHxh1p03H9kklT2LwYSuBWw4Zs6U6C6KlI6BiMjD7XvDQQCoY5NupSJPbQqlHPLNHhPRUmjqyP9GszE4dwvp/RGtt4zoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716150; c=relaxed/simple;
	bh=09zjl6coUxzXg6iixpUDWWwHPqJdxCCt3nK557DRpJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDxsoQ/ImzsTjVGayxQfUfSeDskf2FoDHGT8zPkGbi/3tNy4nPGbPVEh9g4G23WzR/WYWucFYWb+wNtpuIE2o8U0p4A6dAHKRKyF1/TCCM24i+Wx2NRkPnn5V/gPF3WunikbR37G5W+u6sTiqZtgBmm+0a7eO2O3HvDPuWm5VIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3bH7hlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3bH7hlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC03CC3277B;
	Tue, 18 Jun 2024 13:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716150;
	bh=09zjl6coUxzXg6iixpUDWWwHPqJdxCCt3nK557DRpJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3bH7hlOBzMUecLNa9jmDIWHYm9skJN69hqRaizX2xtGCCVC+q0vKWP+kIcsddbG+
	 oov10Aj73Spw7AJSmqhFUCLffyeLhRhn/RYmdOQsXwyRh8IrahY/x2Afq9LRTMC0NG
	 MVfriGikwbEtfXjyTZwhlMYsigkkACuJlHdv/A5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 518/770] NFSD: Avoid calling fh_drop_write() twice in do_nfsd_create()
Date: Tue, 18 Jun 2024 14:36:11 +0200
Message-ID: <20240618123427.308631719@linuxfoundation.org>
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

[ Upstream commit 14ee45b70dd0d9ae76fb066cd8c0652d657353f6 ]

Clean up: The "out" label already invokes fh_drop_write().

Note that fh_drop_write() is already careful not to invoke
mnt_drop_write() if either it has already been done or there is
nothing to drop. Therefore no change in behavior is expected.

[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 0968eaf735c85..cdeba19db16df 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1504,7 +1504,6 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		case NFS3_CREATE_GUARDED:
 			err = nfserr_exist;
 		}
-		fh_drop_write(fhp);
 		goto out;
 	}
 
@@ -1512,10 +1511,8 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		iap->ia_mode &= ~current_umask();
 
 	host_err = vfs_create(dirp, dchild, iap->ia_mode, true);
-	if (host_err < 0) {
-		fh_drop_write(fhp);
+	if (host_err < 0)
 		goto out_nfserr;
-	}
 	if (created)
 		*created = true;
 
-- 
2.43.0



