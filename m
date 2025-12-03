Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F4330FC3A;
	Wed,  3 Dec 2025 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778173; cv=none; b=gy6FNRdHsnd8nXQEWnQzG/U297HDdr46enrtPYoCJsMsFrV6FpJSd7c/ZajNThhKcrBHKnH4jAFB8zu3N9XUEWdv8hgs9iXmvJNwiEGflnMO9MR7+EcCjcE12BXLsnYO2vavSam7eECgz8jAt95ZaP+JBUdrPNANrGyctWu1DDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778173; c=relaxed/simple;
	bh=JFsFLL3YTRY9RQOuJuMcDKua8V8fBERUoQJ6+lyMerc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkxfAP5210tqT6cApQACtYFWX2yIvTJGiuAo7Y7S47UrFaznzRdtlOqAe3EjpTX2/eB73bDJ7Ns50p6iR5NdzUGKMkfCVj1wDrG+Qh/ZROUBONzo4iO+890PsEBKTRPr+TNta4Il3IgX88hut6Jc3zOYeMM4XO72EsyZMVDvVZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vJozB/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vJozB/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8DEC4CEF5;
	Wed,  3 Dec 2025 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778172;
	bh=JFsFLL3YTRY9RQOuJuMcDKua8V8fBERUoQJ6+lyMerc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vJozB/DOUdMIphHzrs4bHIhKE44egSQBviStAHKlBNTmEYztzNNaMN2wj3KgBqQu
	 tNUawYwBFA6O/E3mRJIYgMC25MCoHZpojhzrYBo4qjGbHFbi+DVsOnqcJezZ48sXgf
	 PaKzVTsh8h+wSgJ1Xp1CFUEOC5zKYq1hThErDdT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/392] mptcp: pm: in-kernel: C-flag: handle late ADD_ADDR
Date: Wed,  3 Dec 2025 16:26:55 +0100
Message-ID: <20251203152423.917173415@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

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
[ I took the version from Sasha from v6.1, and fixed an additional
  conflict in pm_netlink.c, because commit a88c9e496937 ("mptcp: do not
  block subflows creation on errors") is not in this version and changed
  the code around: check_work_pending() is now called directly, followed
  by a return instead of a goto. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index df46ca14ce234..e94b78a8b0ef1 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -532,6 +532,12 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 		check_work_pending(msk);
 	}
 
+	/* No need to try establishing subflows to remote id0 if not allowed */
+	if (mptcp_pm_add_addr_c_flag_case(msk)) {
+		check_work_pending(msk);
+		return;
+	}
+
 	/* check if should create a new subflow */
 	if (msk->pm.local_addr_used < local_addr_max &&
 	    msk->pm.subflows < subflows_max &&
-- 
2.51.0



