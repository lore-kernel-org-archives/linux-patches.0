Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA53B3D8114;
	Tue, 16 Jun 2026 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634274; cv=none; b=qY4jLUK43dQVBde83Ty+DaqAtUazYFzfx7mqykwTEbHbR4SPN8T1OyMZzd38z068lPRji2208iESCatJbOkh+So0ODe7J7L5hAOMNtukFUQ1LxN4ve/9S8qsUXUplGuLnLcDMErnSZDwNdSk6b+op/1yYIcH+x63+gsbbcUm1+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634274; c=relaxed/simple;
	bh=+HAXhjvS+g1gMBm/wsBj3IGv/GawbU8H5zKP19f+cQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgZ4kItqrC6eIocaMTBDc9PDARnaXzKWag0X23gkL05KG1QDoubRbRhb10ttzt3CHFC+I5QeTUWmZhMw3gkOY82jgPNCjzTggCWw7Wb83bv4vTMsOfz9YOOGTXnY4d3Vxce8xLgt8xsOAzhAHGgFMpTE3+Bi2oYEoibDyNZJho0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1lba9ON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1lba9ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A8C1F000E9;
	Tue, 16 Jun 2026 18:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634273;
	bh=qLCdJR1jXmZz+1ft7S6XB4yaO4eG1bh0PzphnI35mNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1lba9ONDDUupuIfz15uRQ97Q+QIU/6wGxq9Ik5qSfBto6y2CLs0Ni3672js/Fzza
	 lRVaXigUb5v3sEQiY3JpkqhCMB5K63r8Bhb3b39+TCeOwSlPtMj7p+Vpu7Qf12C7It
	 StEOwv8Umg69Nfwfn28eGNVVfFgSMUMx3E7/2Wgg=
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
Subject: [PATCH 5.15 235/411] sctp: diag: reject stale associations in dump_one path
Date: Tue, 16 Jun 2026 20:27:53 +0530
Message-ID: <20260616145113.326169303@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


