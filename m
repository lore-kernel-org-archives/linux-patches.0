Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784983C17;
	Fri, 31 Oct 2025 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919336; cv=none; b=WdNbf7a/HboFRXAt0TppnwF4VMzUVnp5YTmjhhUJMgZkWB6uR6gcuW1DF4Qxz53wAMzavzPNlAxBUjHs68lWVzR1pCBp9jw5UGhMIT/dt2xVbJou6RGZQtLvg7ecPxlqxcpJVv5CTIvVxHG0LwG60twjW5VTGaW0k+gFMLywEvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919336; c=relaxed/simple;
	bh=c35Dr+s4m9Ch6l9OcRR1Z/hjeEUfSyvC/u3X7UaSD6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP8c3bAaN42ETQyVVy67sh3uP2izp8M9iVlqbaNUkiZaaQE36LBpaLVVjIuJOU5GkMF14x51bIap7FmVzHcu7ll8VlFZwH+ACYQqvZNxh82FxrbdUtnMWBlRvMwo7q2/8TirgVhtV9SbxzQCD6RSKHxqC81TnILRZTHbJR3uuqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqcMBGv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqcMBGv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97939C4CEE7;
	Fri, 31 Oct 2025 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919334;
	bh=c35Dr+s4m9Ch6l9OcRR1Z/hjeEUfSyvC/u3X7UaSD6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqcMBGv6eCRfSsZ2j+h5RdrQuw0/ZWPPBdqavl9JgHv9ovr25pJwIQlJM4ftnESby
	 cVIn67prImzGPr/1Kuwa2OhXLn2fYIV7fr2RLVUaGtA3mzS9wUgegy1PzDCMpkGkiM
	 J1jbCypfWj4mAzAScSYS6UAfyCZOj3X0rxgvPFDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/32] mptcp: pm: in-kernel: C-flag: handle late ADD_ADDR
Date: Fri, 31 Oct 2025 15:01:10 +0100
Message-ID: <20251031140042.816030019@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit e84cb860ac3ce67ec6ecc364433fd5b412c448bc ]

The special C-flag case expects the ADD_ADDR to be received when
switching to 'fully-established'. But for various reasons, the ADD_ADDR
could be sent after the "4th ACK", and the special case doesn't work.

On NIPA, the new test validating this special case for the C-flag failed
a few times, e.g.

  102 default limits, server deny join id 0
        syn rx                 [FAIL] got 0 JOIN[s] syn rx expected 2

  Server ns stats
  (...)
  MPTcpExtAddAddrTx  1
  MPTcpExtEchoAdd    1

  Client ns stats
  (...)
  MPTcpExtAddAddr    1
  MPTcpExtEchoAddTx  1

        synack rx              [FAIL] got 0 JOIN[s] synack rx expected 2
        ack rx                 [FAIL] got 0 JOIN[s] ack rx expected 2
        join Rx                [FAIL] see above
        syn tx                 [FAIL] got 0 JOIN[s] syn tx expected 2
        join Tx                [FAIL] see above

I had a suspicion about what the issue could be: the ADD_ADDR might have
been received after the switch to the 'fully-established' state. The
issue was not easy to reproduce. The packet capture shown that the
ADD_ADDR can indeed be sent with a delay, and the client would not try
to establish subflows to it as expected.

A simple fix is not to mark the endpoints as 'used' in the C-flag case,
when looking at creating subflows to the remote initial IP address and
port. In this case, there is no need to try.

Note: newly added fullmesh endpoints will still continue to be used as
expected, thanks to the conditions behind mptcp_pm_add_addr_c_flag_case.

Fixes: 4b1ff850e0c1 ("mptcp: pm: in-kernel: usable client side with C-flag")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251020-net-mptcp-c-flag-late-add-addr-v1-1-8207030cb0e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ applied to pm_netlink.c instead of pm_kernel.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -619,6 +619,10 @@ static void mptcp_pm_create_subflow_or_s
 	}
 
 subflow:
+	/* No need to try establishing subflows to remote id0 if not allowed */
+	if (mptcp_pm_add_addr_c_flag_case(msk))
+		goto exit;
+
 	/* check if should create a new subflow */
 	while (msk->pm.local_addr_used < local_addr_max &&
 	       msk->pm.subflows < subflows_max) {
@@ -650,6 +654,8 @@ subflow:
 			__mptcp_subflow_connect(sk, &local.addr, &addrs[i]);
 		spin_lock_bh(&msk->pm.lock);
 	}
+
+exit:
 	mptcp_pm_nl_check_work_pending(msk);
 }
 


