Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AC5BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D481FC433D2;
	Tue,  7 Mar 2023 18:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213128;
	bh=FtQc7/bp6H2SNORO5frNQ3uCUR3TdaSYxo+DK1aSSYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/r2YzO3XCQbajthKqDv+atH980KpZK17BUl4QFJjLS8Inn63T9zXZs3YpGBngr9b
	 aKe/9i+DNRY02WDLcymRQFyMnhdZysHyTVVpOTNGUhiIbHmZBGGk27cHYIpq6MnArN
	 iucBJTR0aj+zkLSIX+CPmBKIKNbaQ38Cnp63IQuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=BC=B5=E6=99=BA=E8=AB=BA?= <cc85nod@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 378/885] nfsd: fix courtesy client with deny mode handling in nfs4_upgrade_open
Date: Tue,  7 Mar 2023 17:55:12 +0100
Message-Id: <20230307170018.750949185@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 7c1b1247dc407..a768b8701b44e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5258,16 +5258,17 @@ nfs4_upgrade_open(struct svc_rqst *rqstp, struct nfs4_file *fp,
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
2.39.2



