Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5BD4EF144;
	Thu, 17 Sep 2026 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667593; cv=none; b=HhQIrS3Li+e9u45xvWVFRKYKobhjn55bwu/SZgHUVNASdvWqQPJmYp4u//fNARE9XklK+3b0eXRyigs3RW7DFpAWZltMvKV8isgEl47+nfjzkrKb5v8k/DYAcwDUza9uZFbC6rRHuJ0vE+XnetPGoOD0cCyDhdTLbceTLqMFOcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667593; c=relaxed/simple;
	bh=ccSVko4r+2s68x9mEtHmz/DXoQVhm7iLp2i7eAkETIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G4bndCJyu1O8vIv9DohUFhBZA1ELqg4+ZEkG2MJtd4zckB3humuzprsyxccbCL7xu9R1ogrrNZj4gDZUNdtlhsxfnw3uSK+0eYugtwVXL1dEWlsmPrkGZ/Cqy1fLAvQ/+R4/v2F/oTlcCauc29y+NYpZDDComIoF95GVPGWdc/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIczcbHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIczcbHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36BE1F000FF;
	Thu, 17 Sep 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667592;
	bh=XPtJpUslZPxwzeTOeh941+ud5I5XMtOh+QrvgBnvl4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zIczcbHXwba6w4lSIYyQ4AZjNPReLM/yKGul9anH3CMFN+kotNQnakjpEIDjMpIug
	 TuelOVr4Orw1nHmQo1ofDq52A30T1Jtlq3cavvBhw0XtVAOBW2CsyOeZmSgUmycAW6
	 XBEhWT3IoGCXAO43Ini5qcbaSkbvau9a4vT5bFXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fbf3648ae7f5bdb05c59@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0145/1102] rds: annotate data-race around rs_seen_congestion
Date: Thu, 17 Sep 2026 16:01:28 +0100
Message-ID: <20260917151543.165304374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 67636cab273ed0c0b0f2adab6c9369a471cb7966 ]

rs_seen_congestion is read in rds_poll() and written in rds_sendmsg()
and rds_poll() without any lock.  Use READ_ONCE()/WRITE_ONCE() to
annotate these lockless accesses and silence KCSAN.

Reported-by: syzbot+fbf3648ae7f5bdb05c59@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a0f8d94.050a0220.6b33c.0000.GAE@google.com/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Allison Henderson <achender@kernel.org> 
Tested-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260522011621.304470-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c | 4 ++--
 net/rds/send.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 528336ac1cb11..85f6471ee6543 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -217,7 +217,7 @@ static __poll_t rds_poll(struct file *file, struct socket *sock,
 
 	poll_wait(file, sk_sleep(sk), wait);
 
-	if (rs->rs_seen_congestion)
+	if (READ_ONCE(rs->rs_seen_congestion))
 		poll_wait(file, &rds_poll_waitq, wait);
 
 	read_lock_irqsave(&rs->rs_recv_lock, flags);
@@ -245,7 +245,7 @@ static __poll_t rds_poll(struct file *file, struct socket *sock,
 
 	/* clear state any time we wake a seen-congested socket */
 	if (mask)
-		rs->rs_seen_congestion = 0;
+		WRITE_ONCE(rs->rs_seen_congestion, 0);
 
 	return mask;
 }
diff --git a/net/rds/send.c b/net/rds/send.c
index 4a24ee9c22d7c..1fc84bd899534 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1339,7 +1339,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 
 	ret = rds_cong_wait(conn->c_fcong, dport, nonblock, rs);
 	if (ret) {
-		rs->rs_seen_congestion = 1;
+		WRITE_ONCE(rs->rs_seen_congestion, 1);
 		goto out;
 	}
 	while (!rds_send_queue_rm(rs, conn, cpath, rm, rs->rs_bound_port,
-- 
2.53.0



