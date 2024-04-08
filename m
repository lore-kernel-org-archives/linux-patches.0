Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054AE79F0;
	Mon,  8 Apr 2024 13:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584686; cv=none; b=ua1qZhvvT5x4W675w+sJzytspJSz/2W+qxOmF1TeQH2MGUIjpGsMOlqvAWvm1crTjWfFGA5oymeZQ3CXfqyyqDS2tMMpYMPaQb0XsKZ7/pRfND1Nx7OqA9LWlh/991Roy9DEwDkWYp/mtOPXS9+SYEhrPAlJ3M2EusnRCoC/b2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584686; c=relaxed/simple;
	bh=//dVmfkLb0H6/WiA0WDwH9/cvZfhOLbSuDLndDDA6gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDB6mMxEcJXh4QFhymWPR+6K8Kx5fvPFTWxG+Iuv+CVpgB8hwtTykjwBF6IHdyHhc7e/AnvZ/NzYZBmBQB7ZcsYFuJKjAd4PVX36LS3LLjYCVt+HQ7OjSJt/RDAUtU9jrTtYKlfVIP/lzmNoEGfB17dL41/pilmYutvXmr1S/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOhdFX8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOhdFX8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BFEC433F1;
	Mon,  8 Apr 2024 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584685;
	bh=//dVmfkLb0H6/WiA0WDwH9/cvZfhOLbSuDLndDDA6gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOhdFX8pM6KKS7tBqf1ISRU9sDxdf/YZl07hG2/5cwH0Xmz+tRVnIgKkrjfTX8Uje
	 i8H9ryQj0pFciLkLx6nnFBIS8GKfBQG4LHi3wm/sjeLqADVgS7TdDQAeG8h1rbEb0m
	 JoubE4pSQ7j7trykfqZa+SGbFEFVi2k2uv9WMly8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=BC=B5=E6=99=BA=E8=AB=BA?= <cc85nod@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 523/690] nfsd: fix courtesy client with deny mode handling in nfs4_upgrade_open
Date: Mon,  8 Apr 2024 14:56:29 +0200
Message-ID: <20240408125418.585982298@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit dcd779dc46540e174a6ac8d52fbed23593407317 ]

The nested if statements here make no sense, as you can never reach
"else" branch in the nested statement. Fix the error handling for
when there is a courtesy client that holds a conflicting deny mode.

Fixes: 3d6942715180 ("NFSD: add support for share reservation conflict to courteous server")
Reported-by: 張智諺 <cc85nod@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fab5805b3ca74..69bc4622a95a4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5300,16 +5300,17 @@ nfs4_upgrade_open(struct svc_rqst *rqstp, struct nfs4_file *fp,
 	/* test and set deny mode */
 	spin_lock(&fp->fi_lock);
 	status = nfs4_file_check_deny(fp, open->op_share_deny);
-	if (status == nfs_ok) {
-		if (status != nfserr_share_denied) {
-			set_deny(open->op_share_deny, stp);
-			fp->fi_share_deny |=
-				(open->op_share_deny & NFS4_SHARE_DENY_BOTH);
-		} else {
-			if (nfs4_resolve_deny_conflicts_locked(fp, false,
-					stp, open->op_share_deny, false))
-				status = nfserr_jukebox;
-		}
+	switch (status) {
+	case nfs_ok:
+		set_deny(open->op_share_deny, stp);
+		fp->fi_share_deny |=
+			(open->op_share_deny & NFS4_SHARE_DENY_BOTH);
+		break;
+	case nfserr_share_denied:
+		if (nfs4_resolve_deny_conflicts_locked(fp, false,
+				stp, open->op_share_deny, false))
+			status = nfserr_jukebox;
+		break;
 	}
 	spin_unlock(&fp->fi_lock);
 
-- 
2.43.0



