Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E812309A4;
	Tue, 12 Nov 2024 10:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408019; cv=none; b=NTmVGhX61GrKCuhPRD9Ae3rqc3eXN2052/r0TisAVDBLuXVMc1V55zK96CywOb3i5djK/GgSvUnb8SkDObuS31EQc/tsJyoWKEuXL2fzNqYo6QkzpNReZ7Iyw5CXkaHM/qxvcNHqh48HgOg5XU1mJAyklE/FjN+2vjSw54vG+vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408019; c=relaxed/simple;
	bh=Sg3kU1RNErxA1PfXE/4A44WWaWHX5Uzh20H8LRodDVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LicmZAza9ZuoyokgEM9ZUG/wxXPDrJRhPLIwXP5xIBSys+jkFkd1/3i7cGLNvVUPDsb7EU7tmWTQ+M5Aa5n6nQxc++uFys1eBlFTPnOYQQ+n+kdKo+lVpIb6nD35GPz1KbHld7AyPvUYODqXW1JQXg3LY4/WpICtJzUCKCtXXK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2HZGeFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2HZGeFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB17C4CED4;
	Tue, 12 Nov 2024 10:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408019;
	bh=Sg3kU1RNErxA1PfXE/4A44WWaWHX5Uzh20H8LRodDVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2HZGeFGqUHqER/ekSKePvSnohs7NLvUVA+uxqn5NdQV/jpkkz2ZOyLnB3DtflxFF
	 Z690BtEZXw/zRIZ+zhvf6w7Wjg/A1XohT9SJ/S8Ojeml15UfaoKAJHiQsk8bENqboq
	 S0YwPEHCKAWcmX7fHfikhTOdpTwo6sd6xVG5TzIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 035/184] NFSv3: only use NFS timeout for MOUNT when protocols are compatible
Date: Tue, 12 Nov 2024 11:19:53 +0100
Message-ID: <20241112101902.214881887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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
index 97b386032b717..e17d80876cf07 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -882,7 +882,15 @@ static int nfs_request_mount(struct fs_context *fc,
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



