Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16120EA2D;
	Tue, 12 Nov 2024 10:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731406969; cv=none; b=rksKO8Hu7WIUS0pw0t+7xV2qokejhJSyJ4yPfZXtGEd4sM4jvtoH02XHczpu1/9vfzPN9HuKscPbQnM7c3uKVoo8zNHFqAxwGRUTH+Qa4PDHZ9IVmxqduS1S0X8RXooqgX3VaYD6vjnNEci1GmHJz0MNJi++qS4LVJFtuzQsZNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731406969; c=relaxed/simple;
	bh=OQkMxymv/loCSK+hDoXMsKU8Sss8XUcXH+JNijFsVG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkcddYVDSsArLfp16nt78o8gjaMCfVWPrAw1JVgEEZwk/UPZsQxgOxbUiceMxRxl1s1NawNJ/EWHnHE6aRo2tA5dexhK9kD+0nyblZeiWDyaUZQ2jx+p5sw+bT6u+HGDZ1d0/CmsBhCdNLqXbCUODwlvnfoKFFcL7WBYkE4vkAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9v/x/ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9v/x/ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A02C4CECD;
	Tue, 12 Nov 2024 10:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731406969;
	bh=OQkMxymv/loCSK+hDoXMsKU8Sss8XUcXH+JNijFsVG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9v/x/ae71lRKRzBurByQ58AyXLQ7cMsePQ6ePIaxMMSXtIfAr9FkTHI/DVStrjaC
	 YsM3B+ctkAXuWvHdGGK020Rr8xmJr+Zyksu7wBT5Frzy43+N2fNifzj1b9TQUx+I1d
	 zIbgSsJEfLdbl3f4bzh16sxpt5p7hAj86RJtsYX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/76] NFSv3: only use NFS timeout for MOUNT when protocols are compatible
Date: Tue, 12 Nov 2024 11:20:37 +0100
Message-ID: <20241112101840.249937146@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 6e2a10343ecb71c4457bc16be05758f9c7aae7d9 ]

If a timeout is specified in the mount options, it currently applies to
both the NFS protocol and (with v3) the MOUNT protocol.  This is
sensible when they both use the same underlying protocol, or those
protocols are compatible w.r.t timeouts as RDMA and TCP are.

However if, for example, NFS is using TCP and MOUNT is using UDP then
using the same timeout doesn't make much sense.

If you
   mount -o vers=3,proto=tcp,mountproto=udp,timeo=600,retrans=5 \
      server:/path /mountpoint

then the timeo=600 which was intended for the NFS/TCP request will
apply to the MOUNT/UDP requests with the result that there will only be
one request sent (because UDP has a maximum timeout of 60 seconds).
This is not what a reasonable person might expect.

This patch disables the sharing of timeout information in cases where
the underlying protocols are not compatible.

Fixes: c9301cb35b59 ("nfs: hornor timeo and retrans option when mounting NFSv3")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 9e672aed35901..f91cb1267b44e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -867,7 +867,15 @@ static int nfs_request_mount(struct fs_context *fc,
 	 * Now ask the mount server to map our export path
 	 * to a file handle.
 	 */
-	status = nfs_mount(&request, ctx->timeo, ctx->retrans);
+	if ((request.protocol == XPRT_TRANSPORT_UDP) ==
+	    !(ctx->flags & NFS_MOUNT_TCP))
+		/*
+		 * NFS protocol and mount protocol are both UDP or neither UDP
+		 * so timeouts are compatible.  Use NFS timeouts for MOUNT
+		 */
+		status = nfs_mount(&request, ctx->timeo, ctx->retrans);
+	else
+		status = nfs_mount(&request, NFS_UNSPEC_TIMEO, NFS_UNSPEC_RETRANS);
 	if (status != 0) {
 		dfprintk(MOUNT, "NFS: unable to mount server %s, error %d\n",
 				request.hostname, status);
-- 
2.43.0



