Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3063B30DD1D;
	Fri, 15 May 2026 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860880; cv=none; b=aWsljmxpwBT19oGME43bjZ0h6EODhSjBUbt/iEUM93N8IXzIrv8fOgeYqtaoYNalqVsiG5zgmEydWDiukgIChiPe7BJ1BgNBC4YdpQKj4zBgTsd5H7WaTxeZUcRMQYniuC7hn7fSCLr4kptBcSlBTBCRKyi/SEy9HKDNTLnBECM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860880; c=relaxed/simple;
	bh=vVlNPkpmjpLc5BAtUdgogrXN5Y+oVN7FQp6rgqPkdJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaR97M4lxrsDGhQkdQeQ1x9OM8rFPmZeCFYDkV6u7hyu22fmmym5OligpK1A7RYxLCwqp+NYuq6MTdAmoDFuGkhumYzBiLJnT+QBwVPcP5Dqhe5PL7gqAfJuLhQDUyO+fBC6/BSBLQ81rTJle1qaRLnEe/7BXSswKl1AI19rChw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIojuIUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIojuIUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B336AC2BCB3;
	Fri, 15 May 2026 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860880;
	bh=vVlNPkpmjpLc5BAtUdgogrXN5Y+oVN7FQp6rgqPkdJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIojuIUCxivXa9oZZb+Jj5J0gzMNWeKXhtgWD90UjTRgEDrRKoCYqL91TyzhsU+9R
	 SA9jnzNVjttVlpBtkMp0R7q9at0T/fEAMEsUcHzKycFaPrDt2LxY5/GSkwr+g+E+KR
	 vwmDGUDvHSJzyiY0/l0LDPEGlfGeiY+UsOpCBVqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruijie Li <ruijieli51@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 072/474] net/smc: avoid early lgr access in smc_clc_wait_msg
Date: Fri, 15 May 2026 17:43:01 +0200
Message-ID: <20260515154716.599899165@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruijie Li <ruijieli51@gmail.com>

commit 5a8db80f721deee8e916c2cfdee78decda02ce4f upstream.

A CLC decline can be received while the handshake is still in an early
stage, before the connection has been associated with a link group.

The decline handling in smc_clc_wait_msg() updates link-group level sync
state for first-contact declines, but that state only exists after link
group setup has completed. Guard the link-group update accordingly and
keep the per-socket peer diagnosis handling unchanged.

This preserves the existing sync_err handling for established link-group
contexts and avoids touching link-group state before it is available.

Fixes: 0cfdd8f92cac ("smc: connection and link group creation")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ruijie Li <ruijieli51@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/08c68a5c817acf198cce63d22517e232e8d60718.1776850759.git.ruijieli51@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_clc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -784,8 +784,8 @@ int smc_clc_wait_msg(struct smc_sock *sm
 		dclc = (struct smc_clc_msg_decline *)clcm;
 		reason_code = SMC_CLC_DECL_PEERDECL;
 		smc->peer_diagnosis = ntohl(dclc->peer_diagnosis);
-		if (((struct smc_clc_msg_decline *)buf)->hdr.typev2 &
-						SMC_FIRST_CONTACT_MASK) {
+		if ((dclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK) &&
+		    smc->conn.lgr) {
 			smc->conn.lgr->sync_err = 1;
 			smc_lgr_terminate_sched(smc->conn.lgr);
 		}


