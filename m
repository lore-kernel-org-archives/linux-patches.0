Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3747200CD;
	Mon,  4 Mar 2024 21:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588806; cv=none; b=i45LaRZ7JSeyrXsd3TxwHKJDFJMUGlOtROliYXWACUtO6Mc9k0k7a0xoNAINROyY/l8U3U+pyXO7riZI6KZrmyf847Oyb/ikWNoR267cfgLMOUglrtLQ2D1+wrY22VT8EG43ZfO076CdkKR/rp1IXEe73c+AAkMi2s9oF1gVaXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588806; c=relaxed/simple;
	bh=mkXqU62BwGkzjny9KfWZPBJPggdWD7gmAg1z3PFln2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpiuC95Uuxcffi//tcExFiUsC71bAII9JpChbmue7KOPRtKOMhSWvIVS2iHk+4UCaPI+9kb+6diVCh4q/7/L7/YXqXnBNXwscs+WvDm+ssx4F+jb2bOFrjkhm2vTEvgxYozW7BgWWUD8vAf79R3q6am229UWjFYVqmoPbkNn1pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLyCk0qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLyCk0qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651EFC43390;
	Mon,  4 Mar 2024 21:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588805;
	bh=mkXqU62BwGkzjny9KfWZPBJPggdWD7gmAg1z3PFln2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLyCk0qwv6MCSU0Q2Cq0Oge1l7f6SMmfX9EA4VaYy8shajuES8x8aSizM1dru7Tk+
	 wjTc+CXdlqfLZytOOy1wdaQUrPInVnZ99Vx/9OAb53J44Nq+BDue7zCD/Xc9p8bJFZ
	 f6JUN8yqr+zebls0p6RxMYusph/mIOV2yulmLwbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 104/215] mptcp: fix snd_wnd initialization for passive socket
Date: Mon,  4 Mar 2024 21:22:47 +0000
Message-ID: <20240304211600.333733886@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit adf1bb78dab55e36d4d557aa2fb446ebcfe9e5ce upstream.

Such value should be inherited from the first subflow, but
passive sockets always used 'rsk_rcv_wnd'.

Fixes: 6f8a612a33e4 ("mptcp: keep track of advertised windows right edge")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-5-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3203,7 +3203,7 @@ struct sock *mptcp_sk_clone_init(const s
 	msk->write_seq = subflow_req->idsn + 1;
 	msk->snd_nxt = msk->write_seq;
 	msk->snd_una = msk->write_seq;
-	msk->wnd_end = msk->snd_nxt + req->rsk_rcv_wnd;
+	msk->wnd_end = msk->snd_nxt + tcp_sk(ssk)->snd_wnd;
 	msk->setsockopt_seq = mptcp_sk(sk)->setsockopt_seq;
 
 	if (mp_opt->suboptions & OPTIONS_MPTCP_MPC) {


