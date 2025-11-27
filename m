Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C77528CF42;
	Thu, 27 Nov 2025 14:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255117; cv=none; b=QFORWfL1XKwzypaZg5azy2yR/0l2wnMA/2TuLOM+xQNNd4THTdeGGbuOKKLAL/kRL70vdnLzm7dG41YmF5L4UiXStiTdU6fC3IOSbyecQdLk7mfnpoGtatrpHCdFSvNF310Sn7ob7mkDx6yCuDUsFcURVsx2Wmdq7bxRBt0JFcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255117; c=relaxed/simple;
	bh=Dic0wXHgDdKIbGm5PXOPJ543Vs1dP0oFmHMltCHdON0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BggxRDHr9nL1cNm1WqNH+QVvXSMtEmeW6HGs08QPbyER3vPQlUUunPwQvAIDy128F0TygZ7ResxIySYxhIfIDeskNdMHUcgcEb9YhyLyzwPVE3b2mN82BOkZaQmQsqHzr49hGoTT8pvQjDHghMSwJR1+i8nORVksn6zKJfPeWI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrgIb3sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrgIb3sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BC8C4CEF8;
	Thu, 27 Nov 2025 14:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255117;
	bh=Dic0wXHgDdKIbGm5PXOPJ543Vs1dP0oFmHMltCHdON0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrgIb3svnPigo15EoN9Q4++YurNvOc9dc31DAnyfhpKmvuUR4lEkA0SUJ1N11FGVL
	 rKJfTINOOFm9fpbnVMpQyfEAZtNK6UEen2g/8f5JKt28cQgQz7uu3sSNyf3MKuaATN
	 Rt3PMtf8luy5sXdIieXAHmci2b+ib/kM3zjhNDWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.12 014/112] mptcp: Disallow MPTCP subflows from sockmap
Date: Thu, 27 Nov 2025 15:45:16 +0100
Message-ID: <20251127144033.253356287@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

commit fbade4bd08ba52cbc74a71c4e86e736f059f99f7 upstream.

The sockmap feature allows bpf syscall from userspace, or based on bpf
sockops, replacing the sk_prot of sockets during protocol stack processing
with sockmap's custom read/write interfaces.
'''
tcp_rcv_state_process()
  subflow_syn_recv_sock()
    tcp_init_transfer(BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB)
      bpf_skops_established       <== sockops
        bpf_sock_map_update(sk)   <== call bpf helper
          tcp_bpf_update_proto()  <== update sk_prot
'''
Consider two scenarios:

1. When the server has MPTCP enabled and the client also requests MPTCP,
   the sk passed to the BPF program is a subflow sk. Since subflows only
   handle partial data, replacing their sk_prot is meaningless and will
   cause traffic disruption.

2. When the server has MPTCP enabled but the client sends a TCP SYN
   without MPTCP, subflow_syn_recv_sock() performs a fallback on the
   subflow, replacing the subflow sk's sk_prot with the native sk_prot.
   '''
   subflow_ulp_fallback()
    subflow_drop_ctx()
      mptcp_subflow_ops_undo_override()
   '''
   Subsequently, accept::mptcp_stream_accept::mptcp_fallback_tcp_ops()
   converts the subflow to plain TCP.

For the first case, we should prevent it from being combined with sockmap
by setting sk_prot->psock_update_sk_prot to NULL, which will be blocked by
sockmap's own flow.

For the second case, since subflow_syn_recv_sock() has already restored
sk_prot to native tcp_prot/tcpv6_prot, no further action is needed.

Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20251111060307.194196-2-jiayuan.chen@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -2150,6 +2150,10 @@ void __init mptcp_subflow_init(void)
 	tcp_prot_override = tcp_prot;
 	tcp_prot_override.release_cb = tcp_release_cb_override;
 	tcp_prot_override.diag_destroy = tcp_abort_override;
+#ifdef CONFIG_BPF_SYSCALL
+	/* Disable sockmap processing for subflows */
+	tcp_prot_override.psock_update_sk_prot = NULL;
+#endif
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	/* In struct mptcp_subflow_request_sock, we assume the TCP request sock
@@ -2186,6 +2190,10 @@ void __init mptcp_subflow_init(void)
 	tcpv6_prot_override = tcpv6_prot;
 	tcpv6_prot_override.release_cb = tcp_release_cb_override;
 	tcpv6_prot_override.diag_destroy = tcp_abort_override;
+#ifdef CONFIG_BPF_SYSCALL
+	/* Disable sockmap processing for subflows */
+	tcpv6_prot_override.psock_update_sk_prot = NULL;
+#endif
 #endif
 
 	mptcp_diag_subflow_init(&subflow_ulp_ops);


