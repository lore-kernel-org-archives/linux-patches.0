Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2001914290C;
	Sun,  1 Sep 2024 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207909; cv=none; b=Di+D3vCA1NKxkDrJIASNIlsHueQnHSBx0X1u8q0lM2v7Ui85dV6ReY8FfB7EFsCijlFYkyKt9KEEsDAVrZ4n0thSYb0WY51CmIgQWmxr/Ck/oM9Hrlc22JS6g2TZI7M9SPBR+XwUWh3DTkCHChJyx8YgvcDFD6UUxWL2xNG4TbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207909; c=relaxed/simple;
	bh=sSdNlcAVUjAP60cIr8hikHEZfyaoPY/yCXMSleQw008=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m93AqM+cGbrtT2ly0agFsNoZcf7rI3LGhZFrphoo61ws4gxVGVJqXEXDEGkP5/wRkO/NgrU+u1/siPEN4Dv/3MecKfqRO2T9mWr45zI7lTyEW07vetqnvTMl61SX3Hp9CkvQvm2QNFMxaEfkC/UR4vC9NZgORkArNPSbFuqF+IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBtlZ45G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBtlZ45G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC4DC4CEC8;
	Sun,  1 Sep 2024 16:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207908;
	bh=sSdNlcAVUjAP60cIr8hikHEZfyaoPY/yCXMSleQw008=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBtlZ45GHg+qUHIXUZC6hv4a5DzNNkIOdo8bRknKgZP7OUHD5yZ9R0Ctz31xn035y
	 YcvkBd8adIHwODhsopX7haMSihp2/VEmLWSclthrgzSNGLNIaN75UmwoiBkXq4qhMS
	 +TRS3whsNQfmYGiDQBj9436Pw/uG9QzU1YQlAxhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 15/93] mptcp: pm: skip connecting to already established sf
Date: Sun,  1 Sep 2024 18:16:02 +0200
Message-ID: <20240901160807.933845232@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit bc19ff57637ff563d2bdf2b385b48c41e6509e0d upstream.

The lookup_subflow_by_daddr() helper checks if there is already a
subflow connected to this address. But there could be a subflow that is
closing, but taking time due to some reasons: latency, losses, data to
process, etc.

If an ADD_ADDR is received while the endpoint is being closed, it is
better to try connecting to it, instead of rejecting it: the peer which
has sent the ADD_ADDR will not be notified that the ADD_ADDR has been
rejected for this reason, and the expected subflow will not be created
at the end.

This helper should then only look for subflows that are established, or
going to be, but not the ones being closed.

Fixes: d84ad04941c3 ("mptcp: skip connecting the connected address")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -135,12 +135,15 @@ static bool lookup_subflow_by_daddr(cons
 {
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_addr_info cur;
-	struct sock_common *skc;
 
 	list_for_each_entry(subflow, list, node) {
-		skc = (struct sock_common *)mptcp_subflow_tcp_sock(subflow);
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		remote_address(skc, &cur);
+		if (!((1 << inet_sk_state_load(ssk)) &
+		      (TCPF_ESTABLISHED | TCPF_SYN_SENT | TCPF_SYN_RECV)))
+			continue;
+
+		remote_address((struct sock_common *)ssk, &cur);
 		if (mptcp_addresses_equal(&cur, daddr, daddr->port))
 			return true;
 	}


