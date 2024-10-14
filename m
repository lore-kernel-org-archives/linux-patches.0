Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1FE80027;
	Mon, 14 Oct 2024 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917268; cv=none; b=KsyHqgna8GNFQr3++E/K4iCSdgDKm6HJwEVwS5+rrgaYlWXMJ9QnGYt806DQi8gPqNgDwnkoy+lG3EHMviQc2HUdj9bbw2Pe3i0ZFy+t7dtFqsz9F0VOiR2lZ/O8ziIgXyF1COqjk8ZjCVd52fmT0vaR2av6oPzwFGI7wjSpNzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917268; c=relaxed/simple;
	bh=kogjiN/gmcxhlyZyDFIsUrVmfcLiDvJi9y4xF1UJU+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQh5tDtCv4yb+uJltWV1iZIbF7OsA0RiUPLG1ZEhiTlwQ3vBit2mX3xsYSRgRR7PcOXxpRCfcduk+yPSGGa2VFGlq5BOL4v5+T+DQy/Ud77H8jav52PmXZaM1tuZqV6VGSQa0Dpo4ZMwJU6qvrFNHSUY1TPg4RNB9rVsX/kCf10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uB8kEQbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uB8kEQbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2E9C4CEC3;
	Mon, 14 Oct 2024 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917268;
	bh=kogjiN/gmcxhlyZyDFIsUrVmfcLiDvJi9y4xF1UJU+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uB8kEQbK9tmpxkgIhVhznRv7hEp1/QDmufaH9ruVeZ2PoFrHZjng5gp/ges5SmXV3
	 iko5bOAPMMCv3EEWaGOpQinRf15OjsZoLfmOUJMs4nW6hYoYAfOzv+FIoSP9e3TgHN
	 XCcCFAcf1dOaQFw+So+BddAhjgrw4CVbsC1Zwjzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 201/213] mptcp: pm: do not remove closing subflows
Date: Mon, 14 Oct 2024 16:21:47 +0200
Message-ID: <20241014141050.804526777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
@@ -864,7 +864,8 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow_get_local_id(subflow);
 
-			if (inet_sk_state_load(ssk) == TCP_CLOSE)
+			if ((1 << inet_sk_state_load(ssk)) &
+			    (TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | TCPF_CLOSING | TCPF_CLOSE))
 				continue;
 			if (rm_type == MPTCP_MIB_RMADDR && remote_id != rm_id)
 				continue;


