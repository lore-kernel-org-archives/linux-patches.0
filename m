Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041067BB1A;
	Mon,  8 Apr 2024 13:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584739; cv=none; b=tNPfRTCeDpsCj9KKxrJAUjN6yeWkcq1UTHMhX6pg5KnNAJ1+lY+PVea0wk7JRJzpYLJhb8Pyp43iFMK84ikp+IPSKRpDycOvDH++fzjsUy2/N01BRBUj5Y4eSqWMf0oZcA7pmaufw9Kl1sYc06GPrEe+bDERSM5vPOom6rSQI7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584739; c=relaxed/simple;
	bh=8AgHjP7NLWIsUT5I2UwBJKaL+dsDFZmPvGAweLNds9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLCIZlGGZ1oLvqagwTAt8ZsSSr78oupAjrPGUjtWnL6epGdzRXTIiJlG1T1ROsa0L7vxzJKWKYYdAbCtCdbleQS0VWiXNSDnH17iFDstByZiMxXS0hbXRyCsT8Hz0hB3V7dML7leaBT12cmnMBqxM1j17JpAiUgBKSf7l2bwpRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ag12LX79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ag12LX79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81156C433F1;
	Mon,  8 Apr 2024 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584738;
	bh=8AgHjP7NLWIsUT5I2UwBJKaL+dsDFZmPvGAweLNds9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ag12LX794MfDQ746oR6RhB4HWhq+DPXyFxISQ3Yq+47iPDU7wN9lSXG/t7whCcBvC
	 T8jtrzHAiWBKnyjgvtysk29e07S4fshxJfmWccI2tuPZE5Uwrxyduoos04mQ7ncGgQ
	 jN+QwU2t4F08dCrAbYmIcshe4P8mfBrPmuH2mXnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 540/690] nfsd: make a copy of struct iattr before calling notify_change
Date: Mon,  8 Apr 2024 14:56:46 +0200
Message-ID: <20240408125419.216970691@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/vfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 71788a5e4a55c..76ce19d42336f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -533,7 +533,15 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
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



