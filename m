Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF5B20FA90;
	Tue, 12 Nov 2024 10:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407249; cv=none; b=XxmW11bS2AmZj0V2tUb6wmI5OulSAvsMRyIclrUE446ENAKLAdUiASFHQcPkzuzlpdvE/3QlppQ7rAvcGOZi2geUhHYq2szL1YzsQj/vlFPUL7iIotvNHw/wLEpdtnAhHrhzWWfOWCXxYf4qyy2Wc5sljiQ+P2aX8Qi19+OCOho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407249; c=relaxed/simple;
	bh=m7iA3qT2Onb3S/8P8MHVWSnEoMUiAJWiZ/zHX2Vsl+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhVoevl1PZUGDhGUdVusPozfqKEKfon3p5FMULvmmkaTHZdSSN+ep/RAvEObBm/Vjm6ufgiLO8SwLjvXCS9ha2D8SPlz1ahf3zCP4tI+DhI1tnbgXdHrb13vKuwH24nhFX/rxIFcx+AZSB410kjdoAP+2I+2oa1u4yrGS2MrbkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11A5hCHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11A5hCHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E9CC4CECD;
	Tue, 12 Nov 2024 10:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407249;
	bh=m7iA3qT2Onb3S/8P8MHVWSnEoMUiAJWiZ/zHX2Vsl+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11A5hCHL4+BZSr8Cpb+t5WnqtqPwQFFYNJAzN7HoQ2Ioded1Rmjv2T0YH2jFMrv7p
	 xMj+8j2evhfrMl5NsP6V7TOwAEzV+g0/1Qg7r9ukAiASgQh9Na5X9MaqsCNjdbTJgw
	 N60zY3phaJT29jjpazh1y5hq6E7WW1kwL74wiq04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/98] NFSv3: only use NFS timeout for MOUNT when protocols are compatible
Date: Tue, 12 Nov 2024 11:20:34 +0100
Message-ID: <20241112101845.002235425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f7b4df29ac5f0..3dffeb1d17b9c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -866,7 +866,15 @@ static int nfs_request_mount(struct fs_context *fc,
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



