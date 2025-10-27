Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48305326D57;
	Mon, 27 Oct 2025 19:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593338; cv=none; b=iELCCzygbjWdwM/FtLcwnielEGRfCJhfrmcGuJNjivty6xV/Dd0vZ0o3Rr9ROVQHLRPxjTEYvbnnIJx4fAm29ZfFxeldIMoNQwqCNqX1AokvEbT/gLsJ5AqDkcMcTMMpz8wO9o5zk32wi6R8/nK5CcaWjTpCW61fzeyJj7XzpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593338; c=relaxed/simple;
	bh=1U87pk044WuEdTOTzcEjZa5STFnA39Ci48CVt3ZOmrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un9gsCdCzf+m61UTnlNK5wghfELsfY+sZJ1jyPDkBHbr8V/3B/QoDDzUvYE+l0G/CUlO8mnVuaOLDRTPD7cYYWRvXY43lQolc0C55+/woeQ0HWqChDEbx901N7XGvGOFhjtSkUeIaQT49ZitAjM7GkYET1ZLktfZQmelSC6zgLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAyD4wx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAyD4wx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA23C4CEFD;
	Mon, 27 Oct 2025 19:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593338;
	bh=1U87pk044WuEdTOTzcEjZa5STFnA39Ci48CVt3ZOmrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAyD4wx4+TpsMm+YsBw2pRjOrBDV1e5dvemVygMiJiJJdiJbvAoi7J//x4uXilHtD
	 n1hb6n2Pdjv+fwFi6hrgUjUeEUzl3lnFbs7oiDMTfUtrkUifAL4wiQa5xUs4pPi2ej
	 Ks2bwqfLBFSfaQROqb98/3rmCHgSP/f5fFrcrS3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 101/184] mptcp: pm: in-kernel: C-flag: handle late ADD_ADDR
Date: Mon, 27 Oct 2025 19:36:23 +0100
Message-ID: <20251027183517.632948550@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit e84cb860ac3ce67ec6ecc364433fd5b412c448bc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_kernel.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -333,6 +333,10 @@ static void mptcp_pm_create_subflow_or_s
 	}
 
 subflow:
+	/* No need to try establishing subflows to remote id0 if not allowed */
+	if (mptcp_pm_add_addr_c_flag_case(msk))
+		goto exit;
+
 	/* check if should create a new subflow */
 	while (msk->pm.local_addr_used < local_addr_max &&
 	       msk->pm.subflows < subflows_max) {
@@ -364,6 +368,8 @@ subflow:
 			__mptcp_subflow_connect(sk, &local, &addrs[i]);
 		spin_lock_bh(&msk->pm.lock);
 	}
+
+exit:
 	mptcp_pm_nl_check_work_pending(msk);
 }
 


