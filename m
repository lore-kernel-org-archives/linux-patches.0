Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585383;
	b=yL3/bS90Av4FstvEBWvv9/aNStcVNNtUWRHLYSBlEmW2+UMcZGBbLW7jbqilxqDa6gA0
	 HTs0ujVHaTFTXjT8KriwrJPrTCdyf3kG3QuzHysjv7Sagoh0NNoECUkzc6h8kkhjyEnjy
	 48zWFi+UUcqlwNOIDg+aVYuuUsyI12HjxvMiTMCdVFsatVshHyvNpTtvwj391tlr+Tkcw
	 lqa0mYfykx/mFAfGVz7+sa6IdRpDkgl1hTyv5yvP1ZfLmrAks3ykbpGH12cV6IavNsmYr
	 6dvZ6lmAdAv6BGyAvNbBDmPzWtJ77vi+ueitZnJ/OGVY2+O8DEg+15Fn8GWq0mxCvdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l2rgG0I3AU6TyuTHegM3as5wgvnk+/D0JHF1MEvfERs=;
	b=rntHIPAjW6T0vgWbLyEd28jEbjuW66uXkGkQLVIfEFv7vpDrvKqVy/WhOxR0HNvEmI63
	 MLfYvg/WRGw0ybADnVsoi748VAm9YbdnApI4XUc3f4QwRs4NQ620xX8cXBZwO1TK/EOaB
	 QzKsFQ4FjWIEwuhjPxSncHjOb+ZkFKdeKs932lxwwebPyk5WbjpGbDhHSBTamuryIEend
	 0T8iEZjN11bStnbJAZXa9IIN9+EIPZ7MZynumMR51Y+ZvMGFrwSfpVX0SpjRIMHMNwPzi
	 z0mjYuwnOfFHBb/hVg/MPLpO4UXxxTX+d2oG7FIMoOVvrFsw/It4gZZFELmIUADxG7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OirfrNh3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE96560A2627;
	Fri, 13 Nov 2026 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OirfrNh3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E6F1F00931;
	Fri, 13 Nov 2026 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585383;
	bh=l2rgG0I3AU6TyuTHegM3as5wgvnk+/D0JHF1MEvfERs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OirfrNh3RJLt9lnf3IRwDZQvu4S0Rd5NKbN63jtyV/FUF+uROEKIKb+3x3rx+riDh
	 1RXVXEk+8gfQh5STML+S0VmdleBT7FlTW4MW7GO7kAoBEy4ZQ5GYEoO5SmJqA+uIOk
	 jqsp3cxe0U1EjVqTAoXvcF7I2ovQJOWjz1ZeLPwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+edbebd898142ee5e24ce@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 018/507] NFSD: Complete a cld upcall when the daemon closes the pipe
Date: Fri, 13 Nov 2026 10:45:22 -0500
Message-ID: <20261113153754.036422892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 2a83fcb50f3c25c493cc4389619340fefe9d6ac4 ]

Once nfsdcld has read a whole upcall, rpc_pipe_read() unlinks the
message from every pipe list, so the purges in rpc_pipe_release()
and rpc_close_pipes() no longer reach it. cld_upcall_ops supplies no
.release_pipe callback, and cld_pipe_destroy_msg() returns without
completing the upcall because a downcall is expected to follow. A
daemon that exits between the read and the write therefore strands
its waiter: the nfsd thread sleeps in TASK_UNINTERRUPTIBLE in
__cld_pipe_upcall() and never returns, hung task warnings follow,
and the server cannot be shut down.

Add a .release_pipe that completes every upcall the daemon has
consumed. cu_inflight distinguishes those from upcalls still queued
on the pipe, which the framework purges before it calls this
callback; cld_pipe_downcall() removes an upcall it accepts from
cn_list under the same lock. Neither can be completed twice.

Fail the stranded upcall with -EPIPE rather than the -EAGAIN that
makes cld_pipe_upcall() retry. The daemon consumed the request, so
whether it acted on it before exiting is unknown.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Reported-by: syzbot+edbebd898142ee5e24ce@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-nfs/6a99f6f0.2e567484.299ffc.000c.GAE@google.com/
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-7-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 6b0c51b8938b5..0b033688aa0b5 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -867,10 +867,34 @@ cld_pipe_destroy_msg(struct rpc_pipe_msg *msg)
 	complete(&cup->cu_done);
 }
 
+/*
+ * An upcall the daemon has consumed is off every pipe list, so the
+ * purge in rpc_pipe_release() and rpc_close_pipes() cannot reach it.
+ * Release its waiter here instead; no downcall can arrive now.
+ */
+static void
+cld_release_pipe(struct inode *inode)
+{
+	struct nfsd_net *nn = net_generic(inode->i_sb->s_fs_info, nfsd_net_id);
+	struct cld_net *cn = nn->cld_net;
+	struct cld_upcall *cup;
+
+	spin_lock(&cn->cn_lock);
+	list_for_each_entry(cup, &cn->cn_list, cu_list) {
+		if (!cup->cu_inflight)
+			continue;
+		cup->cu_inflight = false;
+		cup->cu_pipe_msg.errno = -EPIPE;
+		complete(&cup->cu_done);
+	}
+	spin_unlock(&cn->cn_lock);
+}
+
 static const struct rpc_pipe_ops cld_upcall_ops = {
 	.upcall		= rpc_pipe_generic_upcall,
 	.downcall	= cld_pipe_downcall,
 	.destroy_msg	= cld_pipe_destroy_msg,
+	.release_pipe	= cld_release_pipe,
 };
 
 static int
-- 
2.53.0



