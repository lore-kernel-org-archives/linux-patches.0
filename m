Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1D73C199A;
	Sat, 30 May 2026 18:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165754; cv=none; b=SD2xDgMQhmrDWtsU7GYooA1V8oed/C2mhY46CFAFJiHefuthpebCYZttAgR6JD1vR7Ckoi+SrDJg7cWp3XoChRPq9Q12dp0uyFztqLGJ1jR4hiU39HSyf/BRgecO5lwGaiVVOWSIlvdh7bnSowlN5/0s76lwp/i4WLnP4R8xe+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165754; c=relaxed/simple;
	bh=YLYNJoO2BtxQfI1Gfs28/yO8jnViWlJdFbO5nH2Sm3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO1W4Q1orP7+rgQqQX3Ds0tiSN9SN73b/tSz7LITaa27HDaehQ/hXn57QOIyp/IqoW5Ak35dmGXQ66kYzgNQYJOLyUzgrsl1w24EFzhZzuUGjFY/Y2OEnacE1RlaGiR1VTEOiEi6hbXq5tUwEp7dC9pjsdMCjLU3Kpi1LZKaWEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piad7gs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piad7gs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3041F00893;
	Sat, 30 May 2026 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165752;
	bh=vuZ1fE1UWQ+B+l3GopNYAiuJsN1vcEPc/dtDaQTlJPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piad7gs1O74rJn77StpMaCFJrBxqWj94lLBg6ioEotzDWRiX+QxjrHgg0ISqKTAXr
	 4Y/FC+GJdq9Ti+DKKmGPC81FcTBw8dRNcspFFJRIQb6tsyfFdhSBChDENNz5XPvxcX
	 45m/HZkBEP/lwdOxgkaZv6E24FpvCSemKHFkPv1U=
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
Subject: [PATCH 5.10 170/589] net/smc: avoid early lgr access in smc_clc_wait_msg
Date: Sat, 30 May 2026 18:00:51 +0200
Message-ID: <20260530160229.266141571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -440,8 +440,8 @@ int smc_clc_wait_msg(struct smc_sock *sm
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


