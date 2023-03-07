Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6FDBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BBFC433EF;
	Tue,  7 Mar 2023 17:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210155;
	bh=FSilbv4HR4QbEzADYQTTDeWnD1rrzZH60lJiXJawpoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ys5A6FekhWPw4z5mQSSm+U7iGiCyaxNw5orTHbxkPixXLZx3lye3tu/jhNZGOt6yF
	 0FK+FkzrC45eEJYK6XS7893FBqTLFWHMvmCK0TFb0qngef6HmYbg7CUXAp0KBCQyxf
	 rYgbU7j/ISfrhym5yyRTxZHCv8mZBn1bUs+8gVW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0450/1001] NFSD: fix leaked reference count of nfsd4_ssc_umount_item
Date: Tue,  7 Mar 2023 17:53:42 +0100
Message-Id: <20230307170040.874749808@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 34e8f9ec4c9ac235f917747b23a200a5e0ec857b ]

The reference count of nfsd4_ssc_umount_item is not decremented
on error conditions. This prevents the laundromat from unmounting
the vfsmount of the source file.

This patch decrements the reference count of nfsd4_ssc_umount_item
on error.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index dbaf33398c827..e2dde8a1837be 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1814,13 +1814,17 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 out:
 	return status;
 out_err:
+	if (nfsd4_ssc_is_inter(copy)) {
+		/*
+		 * Source's vfsmount of inter-copy will be unmounted
+		 * by the laundromat. Use copy instead of async_copy
+		 * since async_copy->ss_nsui might not be set yet.
+		 */
+		refcount_dec(&copy->ss_nsui->nsui_refcnt);
+	}
 	if (async_copy)
 		cleanup_async_copy(async_copy);
 	status = nfserrno(-ENOMEM);
-	/*
-	 * source's vfsmount of inter-copy will be unmounted
-	 * by the laundromat
-	 */
 	goto out;
 }
 
-- 
2.39.2



