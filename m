Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7F41A619B;
	Tue, 30 Jul 2024 16:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357535; cv=none; b=cD/MA2hb0Jx3nnGeLu9TL5Wj+fZ4S14ABAe7etg9Wf18+MfDDWVT3jZyY71jxyC6ca0zmzHXb+35aOcUjjWlI4Ilf7N7KAMMsr+Dt9+vb2k6NS5Ifk8TZogZ0E1YURTE5I5A8ad9VkaTqvpah6FM3zUeVBeVAZgi7HJy/STKdtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357535; c=relaxed/simple;
	bh=elQof+Dq+bsCyK3OVGXsEPM7uSJLav4vgVcwlbd7LtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuoZTLaKqadaGBnNUfoK8oZtS/m0NW7Dv6e3P+ZgmCuOYNNDnrBBBPBDryPlq+9ttaafqI4qxsnPjtg/B5s3jzac3KAx67ake35MBWbzo9rY8AOCp+Z/gSk1ymD1ZkBTfY+4DwIYVdjNLouDWsmWX/idIA1ozjHexX+slLRyvVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+/o5YHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+/o5YHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57720C4AF15;
	Tue, 30 Jul 2024 16:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357535;
	bh=elQof+Dq+bsCyK3OVGXsEPM7uSJLav4vgVcwlbd7LtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+/o5YHIBEv3mquN8oR747Iba8ZX9r8AltOtGETN2Q71MbuaW+Y0dve1qSx6ihcAI
	 whrCqklrP4+2cAJtyTc3Vd37rPlg5jclqMf2bTal61P3htVw84gQhoqr4Jd4oc0Nvv
	 3bvUuJZ+jjFn1rgKIbe0j6IOeCmTVB7DzQ2/iVUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/568] SUNRPC: avoid soft lockup when transmitting UDP to reachable server.
Date: Tue, 30 Jul 2024 17:45:47 +0200
Message-ID: <20240730151649.262010414@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 6258cf25d5e3155c3219ab5a79b970eef7996356 ]

Prior to the commit identified below, call_transmit_status() would
handle -EPERM and other errors related to an unreachable server by
falling through to call_status() which added a 3-second delay and
handled the failure as a timeout.

Since that commit, call_transmit_status() falls through to
handle_bind().  For UDP this moves straight on to handle_connect() and
handle_transmit() so we immediately retransmit - and likely get the same
error.

This results in an indefinite loop in __rpc_execute() which triggers a
soft-lockup warning.

For the errors that indicate an unreachable server,
call_transmit_status() should fall back to call_status() as it did
before.  This cannot cause the thundering herd that the previous patch
was avoiding, as the call_status() will insert a delay.

Fixes: ed7dc973bd91 ("SUNRPC: Prevent thundering herd when the socket is not connected")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index d3c917c0c8d59..142ee6554848a 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2310,12 +2310,13 @@ call_transmit_status(struct rpc_task *task)
 		task->tk_action = call_transmit;
 		task->tk_status = 0;
 		break;
-	case -ECONNREFUSED:
 	case -EHOSTDOWN:
 	case -ENETDOWN:
 	case -EHOSTUNREACH:
 	case -ENETUNREACH:
 	case -EPERM:
+		break;
+	case -ECONNREFUSED:
 		if (RPC_IS_SOFTCONN(task)) {
 			if (!task->tk_msg.rpc_proc->p_proc)
 				trace_xprt_ping(task->tk_xprt,
-- 
2.43.0



