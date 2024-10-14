Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259FB4A24;
	Mon, 14 Oct 2024 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916555; cv=none; b=f+rHLG/z0Hkjs7pgWd+MTJFdcmE7wZPC84jHv36lchCfaioh7fmip45i9R/NWtgjugwL7wsDqxuQtuBPb9BNLkgb0D6yjdFb/40S+Wl7jQ5ysBW4r8V7+jEJCWTEUlNlVIg8trPFEzCy7XweXWXfPk0IEmgnCAs3dHXN8Sk//5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916555; c=relaxed/simple;
	bh=A9GbwNHcYboLi8gMKLwYDIcsaM3oDnEjL29z90F6u30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fz2woguBqZdSw3jEnlafkfsVCbbWXS6lVuYPxd7VTNUrNnaj7c4v1PvzgKt55JvMWFz4rrYmLhBm5wDZCQLDjwghtT1BUxdFDPdr/30hvvUt8d7nAuG+qrvhHvlKP4GmeaZvPOOJhldRwt89oY5Wy1RHahLlu1rzdlv7xBKWW60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wx12qeAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wx12qeAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AFAC4CEC3;
	Mon, 14 Oct 2024 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916555;
	bh=A9GbwNHcYboLi8gMKLwYDIcsaM3oDnEjL29z90F6u30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wx12qeAL1ciz+6+8nJhuvezNKuicO/We8qG9K8OyRnMs9jhnEkzv1AeWW2zBk74eU
	 tqRHNIeRs9wvVsKxzHXxJpdM6WYPVhvvvlAufPbqfFoGIMMSPuTy30SvR29zcOihj6
	 X9NcR1APH1HWtpP7rfAC37ExspkQ8PtOU+oTsPDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 198/214] mptcp: pm: do not remove closing subflows
Date: Mon, 14 Oct 2024 16:21:01 +0200
Message-ID: <20241014141052.703427469@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit db0a37b7ac27d8ca27d3dc676a16d081c16ec7b9 upstream.

In a previous fix, the in-kernel path-manager has been modified not to
retrigger the removal of a subflow if it was already closed, e.g. when
the initial subflow is removed, but kept in the subflows list.

To be complete, this fix should also skip the subflows that are in any
closing state: mptcp_close_ssk() will initiate the closure, but the
switch to the TCP_CLOSE state depends on the other peer.

Fixes: 58e1b66b4e4b ("mptcp: pm: do not remove already closed subflows")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241008-net-mptcp-fallback-fixes-v1-4-c6fb8e93e551@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -856,7 +856,8 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow_get_local_id(subflow);
 
-			if (inet_sk_state_load(ssk) == TCP_CLOSE)
+			if ((1 << inet_sk_state_load(ssk)) &
+			    (TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | TCPF_CLOSING | TCPF_CLOSE))
 				continue;
 			if (rm_type == MPTCP_MIB_RMADDR && remote_id != rm_id)
 				continue;


