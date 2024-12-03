Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1E01F754A;
	Tue,  3 Dec 2024 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240013; cv=none; b=p0quO+GV7k7zeSeZinu14UInjOKfbVrj+zCjuuzE1pkbqbEI4eEB+phZTukQdBpEagwHs10/0FEyvdqimRVJVtWNfeDr4p/sQLhN1c5Yp02O1c7pl+TlVk0SlTVhtCZLSqVL0VD/NOGGPVmxCdhhIoBnEwtEuhvjXZHdX0l0v8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240013; c=relaxed/simple;
	bh=HMrgQSSBpCT/A6no28pVBK9BfX0NB2ad2BevloRquJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmRsrIm47aUKECoBye0dKYZDsGlmB5ovLWSv5W+uaXqn1nSrG7QjpnBKoXSbslv3sA4ChB4Wkxpl6NH/Kp5PT31UAr73z4AQROoKipR8rhXFQKvjcWdnGvvly/mJmdFuq7Hb4djML+ersyhhKgiaQlEXtThzUbXCJch88q5p4K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MviLk6pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MviLk6pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B2DC4CECF;
	Tue,  3 Dec 2024 15:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240012;
	bh=HMrgQSSBpCT/A6no28pVBK9BfX0NB2ad2BevloRquJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MviLk6pXXC6EXVXzjaF4zVGA1rvZ64O4BIpA+TDfpseCVnDswiiTWgQYQhOYvZDUl
	 ls0mOhns1DPqMyNgqaTnKLKnerZGCOB01Jg+D5NyS63g+USbX9ZCODRQ0rakOKkquJ
	 bMoOJH603WYcoDR5FbiEEfR9bwaEyFsqB9G85FRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 810/817] nfs/blocklayout: Limit repeat device registration on failure
Date: Tue,  3 Dec 2024 15:46:22 +0100
Message-ID: <20241203144028.070920557@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 614733f9441ed53bb442d4734112ec1e24bd6da7 ]

Every pNFS SCSI IO wants to do LAYOUTGET, then within the layout find the
device which can drive GETDEVINFO, then finally may need to prep the device
with a reservation.  This slow work makes a mess of IO latencies if one of
the later steps is going to fail for awhile.

If we're unable to register a SCSI device, ensure we mark the device as
unavailable so that it will timeout and be re-added via GETDEVINFO.  This
avoids repeated doomed attempts to register a device in the IO path.

Add some clarifying comments as well.

Fixes: d869da91cccb ("nfs/blocklayout: Fix premature PR key unregistration")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/blocklayout.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 0becdec129704..47189476b5538 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -571,19 +571,32 @@ bl_find_get_deviceid(struct nfs_server *server,
 	if (!node)
 		return ERR_PTR(-ENODEV);
 
+	/*
+	 * Devices that are marked unavailable are left in the cache with a
+	 * timeout to avoid sending GETDEVINFO after every LAYOUTGET, or
+	 * constantly attempting to register the device.  Once marked as
+	 * unavailable they must be deleted and never reused.
+	 */
 	if (test_bit(NFS_DEVICEID_UNAVAILABLE, &node->flags)) {
 		unsigned long end = jiffies;
 		unsigned long start = end - PNFS_DEVICE_RETRY_TIMEOUT;
 
 		if (!time_in_range(node->timestamp_unavailable, start, end)) {
+			/* Uncork subsequent GETDEVINFO operations for this device */
 			nfs4_delete_deviceid(node->ld, node->nfs_client, id);
 			goto retry;
 		}
 		goto out_put;
 	}
 
-	if (!bl_register_dev(container_of(node, struct pnfs_block_dev, node)))
+	if (!bl_register_dev(container_of(node, struct pnfs_block_dev, node))) {
+		/*
+		 * If we cannot register, treat this device as transient:
+		 * Make a negative cache entry for the device
+		 */
+		nfs4_mark_deviceid_unavailable(node);
 		goto out_put;
+	}
 
 	return node;
 
-- 
2.43.0



