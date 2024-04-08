Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E983A6EB72;
	Mon,  8 Apr 2024 13:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584422; cv=none; b=ugG79SWQ1U7OsJ8g8h4SDG0I/svk/d2qjndRLuf++efQPSA84ImecTPZELnxtA8IDgEY1lVSUWVyN4n647y0JPlpTPCq/nU2EcKVzsbowKcnczlriGBq8OCORN+2XY4zpstrgQWXIa5WdL4s6DJDUVc0NEVy8a0V8KJ7yfE2af0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584422; c=relaxed/simple;
	bh=+E/GFfYcFiPiQaZSRiELOxVFpEnvFWn6WwgzIDPqtFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqUYrkhB1Qk15InlrwFKpFkctJqiaAXZAYV9m7btyualwXVYRbuX67+WPu3PuvO27DpJERVTqgOWQRjlBjeoh+fnNWq1L1k5O7lP6Jvykb0TFNa/UvP6+Mr+nY0uuB3kTZs39bpsBFVvSdED4Kax8000EcutJs5fbWFNwOIoc/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8ZosuWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8ZosuWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739DFC433F1;
	Mon,  8 Apr 2024 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584421;
	bh=+E/GFfYcFiPiQaZSRiELOxVFpEnvFWn6WwgzIDPqtFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8ZosuWiTHV4v22sZAwKzUuwRx3qCui4NjsEc3r1uwld6KOIAj/Ui6NajFoR6qzvM
	 YvkDdQSIVT1A9GlX0TybviDyJpDiPHyhcNw25zyvTv1B50r5Nk/TRv3GDrJH+S+M/G
	 DSE51jTBh6dXkdePRLGfRBLLi7Q/eCW0jsNDZl3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 433/690] NFSD: Make nfsd4_remove() wait before returning NFS4ERR_DELAY
Date: Mon,  8 Apr 2024 14:54:59 +0200
Message-ID: <20240408125415.296623106@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5f5f8b6d655fd947e899b1771c2f7cb581a06764 ]

nfsd_unlink() can kick off a CB_RECALL (via
vfs_unlink() -> leases_conflict()) if a delegation is present.
Before returning NFS4ERR_DELAY, give the client holding that
delegation a chance to return it and then retry the nfsd_unlink()
again, once.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=354
Tested-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 4c5cc142562b2..d17377148b669 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1790,9 +1790,18 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 
 	fh_fill_pre_attrs(fhp);
 	if (type != S_IFDIR) {
+		int retries;
+
 		if (rdentry->d_sb->s_export_op->flags & EXPORT_OP_CLOSE_BEFORE_UNLINK)
 			nfsd_close_cached_files(rdentry);
-		host_err = vfs_unlink(&init_user_ns, dirp, rdentry, NULL);
+
+		for (retries = 1;;) {
+			host_err = vfs_unlink(&init_user_ns, dirp, rdentry, NULL);
+			if (host_err != -EAGAIN || !retries--)
+				break;
+			if (!nfsd_wait_for_delegreturn(rqstp, rinode))
+				break;
+		}
 	} else {
 		host_err = vfs_rmdir(&init_user_ns, dirp, rdentry);
 	}
-- 
2.43.0



