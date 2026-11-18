Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037184;
	b=1cdIOnBEFIFe5TW/Z+JZWETwNJWuvH027I+pURudJHpKJtFdwafVRUDYvN8Kc8r2ZBow
	 7HQMvZ+iLrdMhZ7S/PcGxLXrippRG18wN9w0Dy7ic+kbryBfCqU6CQ6Zy2gSufVVYroet
	 8OCcAfH8+zKlhKkAFXmP2cFMdH4+el+2FmfzpPunMJEPZZpquZBxfilOKYcKD+ozx58Ry
	 s1J2s2JwM4fahHHM//nmxt0KAzVIqo8UGK3zdp9laR1MEivGQ37L+aAJByF1j16ueuLA1
	 OQ3lA/s2PVqGYp5OKaiUqeuhYnH68YKMd0qXXqf4VIUNOYby7e1wxn/RgCkrLozchCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YU+/wymMl/rCHsCbk/EX7GQp3Z/FTRYqzCOcd633d/4=;
	b=RsT+yByyvktbAUHM9uF0UGYlfA1xFIKUtni/j5R9UpALn1D69z+Y6iJ6p5ce1JIZq6ut
	 wGjQWznUlG3Hau00UOQQ2TbXn+zjOPuuhIF7q5/7Sh/P7i6zdkV0LAvSgx+odON1GT//m
	 u+T/6tt9T5KaltKWtsIy/hDKTc00dOiLIVZ46reswRLhkge5+YW4sV0ge/0caX/zFlvzu
	 69gl1LsS1T8z163ozgwNT1+dVsEuQZGPy/QwgMFWvCRx/tYYT7QvG56W1Wf/fwNeRowPd
	 xBMaMjCES4onxl1D+2SFPH9H+ZnssvV6jXiUCgL1oAjPInhNwMUVD1ZAHOkY1Fo4t+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hsnd1x/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE38606A320;
	Wed, 18 Nov 2026 21:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hsnd1x/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9931F000C4;
	Wed, 18 Nov 2026 21:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037184;
	bh=YU+/wymMl/rCHsCbk/EX7GQp3Z/FTRYqzCOcd633d/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hsnd1x/TvrdKx0YGJpoWsNAompcgrZJDdhEfljxXCE+Sza3wP+wZcWHvTiH6feXzy
	 Al7eKjIiMV3SBLd2UmQw3w66HW7V7JQY9VR3j7zt/9Q79u3/GMt0zBGm3GxN+fRku9
	 Hre3cqs7xLbm7reVlbq3jF4ywmuXJ462vU4Mi9OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+edbebd898142ee5e24ce@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1322/3318] NFSD: Complete a cld upcall when the daemon closes the pipe
Date: Wed, 18 Nov 2026 15:32:24 +0100
Message-ID: <20261118150359.978782483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ba50a7764ebc9..c7031c61299ec 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -943,10 +943,34 @@ cld_pipe_destroy_msg(struct rpc_pipe_msg *msg)
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
 
 static struct dentry *
-- 
2.53.0



