Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2A919E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6148DC433EF;
	Wed,  7 Jun 2023 20:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170250;
	bh=9O52STw91Qes7fHXzPstmLWa9SeUhbccnBvK9mqA6TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDdFKiSEdhpxbqw+ojbJ6L/TY1ZnsSWMXEsMMKy7BQbJzVHk9uXpsgqGiB25qhU23
	 Y+7h/skHQi7ahMieRlK7xBKyhc/v3uKp3iAj7AK0esYTLQL/OEjsbkJ73zNV5Bptab
	 7l2T8bXVZJxxpcqNlMGxQPDqY9fNKdt9O12xrXKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/225] nfsd: make a copy of struct iattr before calling notify_change
Date: Wed,  7 Jun 2023 22:13:27 +0200
Message-ID: <20230607200913.809096138@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
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

[ Upstream commit d53d70084d27f56bcdf5074328f2c9ec861be596 ]

notify_change can modify the iattr structure. In particular it can
end up setting ATTR_MODE when ATTR_KILL_SUID is already set, causing
a BUG() if the same iattr is passed to notify_change more than once.

Make a copy of the struct iattr before calling notify_change.

Reported-by: Zhi Li <yieli@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2207969
Tested-by: Zhi Li <yieli@redhat.com>
Fixes: 34b91dda7124 ("NFSD: Make nfsd4_setattr() wait before returning NFS4ERR_DELAY")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index dc3ba13546dd6..155b34c4683c2 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -469,7 +469,15 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	inode_lock(inode);
 	for (retries = 1;;) {
-		host_err = __nfsd_setattr(dentry, iap);
+		struct iattr attrs;
+
+		/*
+		 * notify_change() can alter its iattr argument, making
+		 * @iap unsuitable for submission multiple times. Make a
+		 * copy for every loop iteration.
+		 */
+		attrs = *iap;
+		host_err = __nfsd_setattr(dentry, &attrs);
 		if (host_err != -EAGAIN || !retries--)
 			break;
 		if (!nfsd_wait_for_delegreturn(rqstp, inode))
-- 
2.39.2



