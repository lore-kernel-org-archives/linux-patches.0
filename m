Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202C83793C2;
	Mon,  4 May 2026 14:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903201; cv=none; b=eSimvKPPZ1l2kTxwlmzMctxd66cv8etW+mVNl+l7QxbqUrCmed4tT/+rF/+bFEdEueu4BqhvUCuJDIlS7Td1vaH52Fh+YFMf6eFbPrpZkUY+AKyG5goUHC6CfSu6jk3L6bTExw7+/eBxbt/zh/8sckBd7S8JOPmqpiaV5DhIJ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903201; c=relaxed/simple;
	bh=rxSrvMGL8qOPwFWGCBiv2Ort2jZUV5SgmVSnvCEtKpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYnsui85OhYbBStwIA/80uKVcx9snkQ9pi9iV6lc8c9wzXVmh3/ZZg+1cRWgqLMGknyOmBuNSZoswBxr8E0/VG+cKNFFMFNVs1DOb65w8rjpU+GglNBQ3nZ0JrcrpJGxyPcbls0cA8dB/h8z4IUkAgjOAu/p+4GPvheZ6WKGLqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhEsO+72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhEsO+72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7FAC2BCB8;
	Mon,  4 May 2026 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903200;
	bh=rxSrvMGL8qOPwFWGCBiv2Ort2jZUV5SgmVSnvCEtKpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhEsO+72b2cMZrXEGGXVB3POR0tEirLECrisp7v3jS085UnzlsigYWDRukYF7hrqZ
	 C50SaxEAqoMWWI4jagCh/ZPfbWJKG2PSVZpY4r44bLKoQZ3cF8dWjx8dZHAoIO45kT
	 Obgjc781VYnP+OPN4No34SKyP0qKKreRL8HMtmqs=
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
Subject: [PATCH 7.0 143/307] net/smc: avoid early lgr access in smc_clc_wait_msg
Date: Mon,  4 May 2026 15:50:28 +0200
Message-ID: <20260504135148.159996015@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -788,8 +788,8 @@ int smc_clc_wait_msg(struct smc_sock *sm
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


