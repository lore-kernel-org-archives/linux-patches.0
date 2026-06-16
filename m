Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5FD3D810C;
	Tue, 16 Jun 2026 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636263; cv=none; b=ss0eTJ7lO5jK37q6OIRprC8HISZj3SyyUHNpVOAisBRaAt0pqMx97u2Xgb1lFSWh8T2CUVNCmwMKOSZV/iouE95NTtLwk1s/You3f8CF+zVxdzUPQM3fNDu17LkvPQZ2enRc3LnJbf3vnfVm6rS85yHl9o/HkjCYMqzWwkv+RAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636263; c=relaxed/simple;
	bh=A79wyt1sFsTayb+Y6a5anQ5XbfJ7TQqct9Z4knlwJXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/hMK+byRd/nnaefbSxbKvRY1Fu1upmC24MhdRUKdsnnyoHzkEHrPevUl0v+6c0g6jYIPQu8DAPy9ma4MQZQGrhBJmAs5xfzeodV2chqU5Z/YMGWFSFtPI8RhHnCZt7YqX72zYLrM96JXobHLSs2moUBUKtxQOUHaHskqTkrmDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0H1u2lEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0H1u2lEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D691F000E9;
	Tue, 16 Jun 2026 18:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636262;
	bh=St4KQZRRvQNATfiASgfiBdU2ZU3pwbTVyPYaS5VqEQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0H1u2lEbNCsylOfuWinS3X5IRzu2syKYSlp1dJyb7khcJbfhZJf8aa6roex2ZkIEi
	 0UYiV5iJofnZUSRD0FUi/8U4PGhMXGSgvmZPnt2IRQ6NRJZ+j+CdqFzQgOxnuBnaNE
	 iefwTe6ie8dSeN9MZ1Lj6Z+KdGA5Lm8A3lTTYBgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhao Zhang <zzhan461@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 205/342] sctp: diag: reject stale associations in dump_one path
Date: Tue, 16 Jun 2026 20:28:21 +0530
Message-ID: <20260616145057.738342430@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Zhang <zzhan461@ucr.edu>

commit 5eba3e48d78edd7551b992cb7ba687019b3a78da upstream.

The SCTP exact sock_diag lookup can hold a transport reference, block on
lock_sock(sk), and then resume after sctp_association_free() has marked
the association dead and freed its bind address list.

When that happens, inet_assoc_attr_size() and
inet_diag_msg_sctpasoc_fill() can still dereference association state
that is no longer valid for reporting. In particular,
inet_diag_msg_sctpasoc_fill() may read an empty bind-address list as a
real sctp_sockaddr_entry and trigger an out-of-bounds read from
unrelated association memory.

Reject the association after taking the socket lock if it has been
reaped or detached from the endpoint, and report the lookup as stale.
This keeps the exact dump-one path from formatting torn association
state.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/fac6043fa20a2ff68e12958c431836f692c51268.1780113823.git.zzhan461@ucr.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/diag.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -266,15 +266,15 @@ static int sctp_sock_dump_one(struct sct
 
 	lock_sock(sk);
 
-	rep = nlmsg_new(inet_assoc_attr_size(sk, assoc), GFP_KERNEL);
-	if (!rep) {
-		release_sock(sk);
-		return -ENOMEM;
+	if (ep != assoc->ep || assoc->base.dead) {
+		err = -ESTALE;
+		goto out_unlock;
 	}
 
-	if (ep != assoc->ep) {
-		err = -EAGAIN;
-		goto out;
+	rep = nlmsg_new(inet_assoc_attr_size(sk, assoc), GFP_KERNEL);
+	if (!rep) {
+		err = -ENOMEM;
+		goto out_unlock;
 	}
 
 	err = inet_sctp_diag_fill(sk, assoc, rep, req, sk_user_ns(NETLINK_CB(skb).sk),
@@ -289,8 +289,9 @@ static int sctp_sock_dump_one(struct sct
 	return nlmsg_unicast(sock_net(skb->sk)->diag_nlsk, rep, NETLINK_CB(skb).portid);
 
 out:
-	release_sock(sk);
 	kfree_skb(rep);
+out_unlock:
+	release_sock(sk);
 	return err;
 }
 


