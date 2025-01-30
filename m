Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2070E1E522;
	Thu, 30 Jan 2025 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247145; cv=none; b=NiPPH3cSkhj0PT57o0JIUNfZZRz72FkM9UcBwsoib8x+173UimBNYjG7k1okXXOCbCHiOt/dBmdKMIrxBtnOOI8Nx+I9HqTrDpU5ioaoy8IQ2RWRYNIG6hgF5IYigU0eQ7pEh+EiQPWszn2zfZ5AO3SD0QYwfRU3DEvkP13c4fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247145; c=relaxed/simple;
	bh=bboYFjkZ6wCECpog+seGstMumN4izbkCR/Og4PYF+wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJsEBCFVqtgPW9mQOSrZIxzP1qpT+mDl9bv+dr/nJfMnIkkJFeMXRY/qSeAZ1vz9RVoUA+8GF126gCCwItdlleJtTy5ymrP6CB8TeYV125PIzeTPLAL1dt881FCahfUvRZOkSFK2U0moNIZ+QCTK28+MfEv0jx/N78O2pxcGdrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfrdiAC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfrdiAC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991A3C4CED2;
	Thu, 30 Jan 2025 14:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247145;
	bh=bboYFjkZ6wCECpog+seGstMumN4izbkCR/Og4PYF+wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfrdiAC8t6U8GbNBsWpHV/qgtZUd7XZcdAA2RWzrOJy5PzQAlPRdIiTuXwtDArsl+
	 /Cx1mhrRjx+jj07KnpizfAAwNei0EYOzguOFhphURQOD6DZ6fWlEso0oaMIEiYUm7G
	 U34U6DK1FoN9bAy5JlyU+CQVWwtFP2x87TFJ4a2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/133] sctp: sysctl: rto_min/max: avoid using current->nsproxy
Date: Thu, 30 Jan 2025 15:00:57 +0100
Message-ID: <20250130140145.254801662@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 9fc17b76fc70763780aa78b38fcf4742384044a5 ]

As mentioned in a previous commit of this series, using the 'net'
structure via 'current' is not recommended for different reasons:

- Inconsistency: getting info from the reader's/writer's netns vs only
  from the opener's netns.

- current->nsproxy can be NULL in some cases, resulting in an 'Oops'
  (null-ptr-deref), e.g. when the current task is exiting, as spotted by
  syzbot [1] using acct(2).

The 'net' structure can be obtained from the table->data using
container_of().

Note that table->data could also be used directly, as this is the only
member needed from the 'net' structure, but that would increase the size
of this fix, to use '*data' everywhere 'net->sctp.rto_min/max' is used.

Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-5-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 8be80096fbb6..82b736843c9d 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -396,7 +396,7 @@ static int proc_sctp_do_hmac_alg(struct ctl_table *ctl, int write,
 static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_min);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;
@@ -424,7 +424,7 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_max);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;
-- 
2.39.5



