Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E483412D74D;
	Tue, 18 Jun 2024 13:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716816; cv=none; b=qzhq4wMZ7m3NGtxbzouu1TzY9tNXENI4T4fNNBKetLuOMGq75brS2NTXjMT7P8WhUX7kDMTnFt2wIbqKynbUHph+XUXlB6xfwN9XelcrXCC4nPDoyZOmJQtu30hN3s2htQ6qDn4tqOV/1Z65QEzJ6VYJhkDR4DakcBOJ22mG07U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716816; c=relaxed/simple;
	bh=Ez3ezxK+rYLmxOypZk1HnEZEZmR1kUJcUp6tTNYoPnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP+n8yLXk2GM6LClYgrnWstudRbrUyxuhiVU6dodVm3jNPCrD7pL1iUiBeMKWLx8HcUuYzETpienXcLSNmzl97pbBZfVa4J9Q+rJfyoAorDGPgObaCVF7fw033o2s4hldlKEvTPotyadfM2KzlVctiVnJ25XjkKumcty1FbWtu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lka/F6Ro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lka/F6Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690AFC3277B;
	Tue, 18 Jun 2024 13:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716815;
	bh=Ez3ezxK+rYLmxOypZk1HnEZEZmR1kUJcUp6tTNYoPnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lka/F6RoZotYc6aNkolODIB2G1I/uk2bYkMFCcfrBQxmEUgF4Kfb4F00cQIcM0uWw
	 dPVdkcFhX+NwtPPiNyQXFslKpmkfQQ4L6h/2Z0vPTds0gjgd3fi6ONPa8iaOMYOCDg
	 S/CR/XR+Pn3iBVgNgDFnkQgne7VGGZOpk6fxCH7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 755/770] nfsd: make a copy of struct iattr before calling notify_change
Date: Tue, 18 Jun 2024 14:40:08 +0200
Message-ID: <20240618123436.411762914@linuxfoundation.org>
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
index abc682854507b..542a1adbbf2a1 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -545,7 +545,15 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
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
2.43.0



