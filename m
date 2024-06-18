Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D31815A848;
	Tue, 18 Jun 2024 13:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716707; cv=none; b=FKMSlpDWhxKMH1p7ped8vG+CC+8taRUasVG4KaXMkXEIzgW05uEFzm67m7Lov1fALB4bptjY7g0e3fO6V+4j5vXzIc0SVI5cDqpvCbjviHCMK71eknooqtRF8Gi46P/81XGsbIoM6+F4379PtX8sJFwRVVED5V1H01+5xOjWL0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716707; c=relaxed/simple;
	bh=5m0bk1TsbE6lTgFu5h1gynX2v2AleSoBiKAvHARy8VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ruCn3nRWCyaiQuoe+fFtniOXxU88f/xSA5U/7MVR8OEDyTZs94IT5WHLxQKZSCDLh/seH9zdCa07j0I+7TR71f9+6WV3I2ynNMLPfq+VYoVC9sS45PFVCZwiScucxWPhx5hGcbfx1wmYc3FJj5+gDggqwHrsVvRU+lvBeLu7pxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qSjvTj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qSjvTj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6480C3277B;
	Tue, 18 Jun 2024 13:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716706;
	bh=5m0bk1TsbE6lTgFu5h1gynX2v2AleSoBiKAvHARy8VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qSjvTj7J1bVynCxGYqZDUEOk+6AvBjkEG/6MFW3OJRGKaEYzRkw0zUpDNgjc0Skx
	 44CMpNYJLcDcsIdY7uJJV7a2x6X9INzE14YpC3UwOQQIaYB1xjPNCrWKWhO0C5Ht/g
	 ZmKNq+cQ5kIGDvIQpeLnSXL1VTlKJ/x3Z993W5Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=BC=B5=E6=99=BA=E8=AB=BA?= <cc85nod@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 736/770] nfsd: fix courtesy client with deny mode handling in nfs4_upgrade_open
Date: Tue, 18 Jun 2024 14:39:49 +0200
Message-ID: <20240618123435.676731398@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 507dd2b11856b..e8e642e5ec8f1 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5296,16 +5296,17 @@ nfs4_upgrade_open(struct svc_rqst *rqstp, struct nfs4_file *fp,
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



