Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2593A6EB72;
	Mon,  8 Apr 2024 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584416; cv=none; b=Ln3E3En4hhraipKcAhFzuVfZbBnKJxecmDN6sBFyasFXCmDNX8i1+glt8YEvLwCi9zBhhB9YmYjZBeP83S8FKmyL8JpPRSn/dp/2YD/e7zHdUgLFj7c3o6V0hFu+OWSmk6lTZd5u/U8LDrErGDMF/ocbp3NJPkGqC0m1IC/xHps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584416; c=relaxed/simple;
	bh=dUNpndwjDwfxrI9eWpakEHH7zjmKm4dwFVgwAZU0YPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtEG899aRvWGRXXUGYx23t0tAr6XDQSHzb85+cte89A/8V7pPUM+T2CLXj16VSfTY46MnqQfXuaVsSN2ngGOcjBjLmQxx53KEJLiuF1RYOvPL+khq3oO7/X6rwUUjH/kZ0u5wpnJbQPtyCcUb6QnN2Sc+HWCujTmYpwJNHh938I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wb1ElPzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wb1ElPzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E5EC433F1;
	Mon,  8 Apr 2024 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584416;
	bh=dUNpndwjDwfxrI9eWpakEHH7zjmKm4dwFVgwAZU0YPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wb1ElPzuT9Smc2sawzHmAVYG2yPuFyFfiDDZtAN3AjRZ1vkmNBgj2DvxXU9Fz7Nhw
	 ziEQTaKEykj1muJtXRRgH+Pob05D8JiFstWysMKaK3u9KdIvKju9h67XyuRhDPylE7
	 RnGi6h6muNQyRcqbC4xWf2EiGRFs873E6JSm4S1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 431/690] NFSD: Make nfsd4_setattr() wait before returning NFS4ERR_DELAY
Date: Mon,  8 Apr 2024 14:54:57 +0200
Message-ID: <20240408125415.218787502@linuxfoundation.org>
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

[ Upstream commit 34b91dda7124fc3259e4b2ae53e0c933dedfec01 ]

nfsd_setattr() can kick off a CB_RECALL (via
notify_change() -> break_lease()) if a delegation is present. Before
returning NFS4ERR_DELAY, give the client holding that delegation a
chance to return it and then retry the nfsd_setattr() again, once.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=354
Tested-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 392df2353556e..e8329051dde01 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -414,6 +414,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	int		host_err;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
+	int		retries;
 
 	if (iap->ia_valid & ATTR_SIZE) {
 		accmode |= NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
@@ -468,7 +469,13 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
 	inode_lock(inode);
-	host_err = __nfsd_setattr(dentry, iap);
+	for (retries = 1;;) {
+		host_err = __nfsd_setattr(dentry, iap);
+		if (host_err != -EAGAIN || !retries--)
+			break;
+		if (!nfsd_wait_for_delegreturn(rqstp, inode))
+			break;
+	}
 	if (attr->na_seclabel && attr->na_seclabel->len)
 		attr->na_labelerr = security_inode_setsecctx(dentry,
 			attr->na_seclabel->data, attr->na_seclabel->len);
-- 
2.43.0



