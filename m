Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4233C3BF4;
	Tue, 10 Mar 2026 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142138; cv=none; b=IMzohH4YlQf2DAGr4JSOtI7EI6zDpiuR/gdEkNPP0hwBFzRHJVO3lBqNhEl0lQalgp7/8yvoydB3FS1BgPfYDaHVLmypwYKeyBcBh2RpG1QsEeOPyqJyU7LtqjYHJz0PaWea7as2q1605Vshc8GbvDRJnsP1JJg0rvKfd6YYoQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142138; c=relaxed/simple;
	bh=FsVwqOhUn9q+gkN2PQNnZqu7c9ufkMJhdbVu6B7dass=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSJTvaA4k/IfAaKCt5ekp5ZI+Ab79jUN14KMkFrZfAt8MKVQl5JDRnF6vp6poNeCgg/+YbvP/hO/c1s3MRzc3A+mbRkL4UXZ0y28HX2cLQsZSAzHJR1Dg+L7YoW48z4xi5ysxYsKeVpKMyzGTW/a8i6CdmgwtD+J23kdTjX09U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcIKWbcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcIKWbcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55D6C19423;
	Tue, 10 Mar 2026 11:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142138;
	bh=FsVwqOhUn9q+gkN2PQNnZqu7c9ufkMJhdbVu6B7dass=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcIKWbcZxqk/dFWuueK5oLD3pSVLp8mKK/6oEnixxAqxLk1MZ4kOOlMw0p8wxnZBv
	 k+6OXb1slVHtv+1OuOLsTAxxxASdEb8NMcmNMAn7X941+eEQSA+sq5U3r/3f4JlYRt
	 J15RLpqYI9na/HD9ngNhuto5Wrx/dz04e+CPJTz4VIMQiqOUgePZiDFPSWlt+2Vrhg
	 jpHR0Cb6jBLThZtSkBTo4IEnFDfp+xoukNgIoNXMTLYdGjGKmlc4aZt2PcLXwNslNW
	 LM8mvknZ5GdcgxZgHuNCm5XRNMIDvdBvgXAwGU1ITRUCC+1sJoxvVYDWW/54KV615v
	 U4NQnZmjFjzIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justintee8345@gmail.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Aristeu Rozanski <aris@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 226/314] nvmet-fcloop: Check remoteport port_state before calling done callback
Date: Tue, 10 Mar 2026 07:18:05 -0400
Message-ID: <5070ce5aca0be81db2eb04102830fc81f27842f3.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Justin Tee <justintee8345@gmail.com>

[ Upstream commit dd677d0598387ea623820ab2bd0e029c377445a3 ]

In nvme_fc_handle_ls_rqst_work, the lsrsp->done callback is only set when
remoteport->port_state is FC_OBJSTATE_ONLINE.  Otherwise, the
nvme_fc_xmt_ls_rsp's LLDD call to lport->ops->xmt_ls_rsp is expected to
fail and the nvme-fc transport layer itself will directly call
nvme_fc_xmt_ls_rsp_free instead of relying on LLDD's done callback to free
the lsrsp resources.

Update the fcloop_t2h_xmt_ls_rsp routine to check remoteport->port_state.
If online, then lsrsp->done callback will free the lsrsp.  Else, return
-ENODEV to signal the nvme-fc transport to handle freeing lsrsp.

Cc: Ewan D. Milne <emilne@redhat.com>
Tested-by: Aristeu Rozanski <aris@redhat.com>
Acked-by: Aristeu Rozanski <aris@redhat.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Closes: https://lore.kernel.org/linux-nvme/21255200-a271-4fa0-b099-97755c8acd4c@work/
Fixes: 10c165af35d2 ("nvmet-fcloop: call done callback even when remote port is gone")
Signed-off-by: Justin Tee <justintee8345@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 5dffcc5becae8..305ab7ee6e760 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -492,6 +492,7 @@ fcloop_t2h_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 	struct fcloop_rport *rport = remoteport->private;
 	struct nvmet_fc_target_port *targetport = rport->targetport;
 	struct fcloop_tport *tport;
+	int ret = 0;
 
 	if (!targetport) {
 		/*
@@ -501,12 +502,18 @@ fcloop_t2h_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 		 * We end up here from delete association exchange:
 		 * nvmet_fc_xmt_disconnect_assoc sends an async request.
 		 *
-		 * Return success because this is what LLDDs do; silently
-		 * drop the response.
+		 * Return success when remoteport is still online because this
+		 * is what LLDDs do and silently drop the response.  Otherwise,
+		 * return with error to signal upper layer to perform the lsrsp
+		 * resource cleanup.
 		 */
-		lsrsp->done(lsrsp);
+		if (remoteport->port_state == FC_OBJSTATE_ONLINE)
+			lsrsp->done(lsrsp);
+		else
+			ret = -ENODEV;
+
 		kmem_cache_free(lsreq_cache, tls_req);
-		return 0;
+		return ret;
 	}
 
 	memcpy(lsreq->rspaddr, lsrsp->rspbuf,
-- 
2.51.0

