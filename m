Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC6F140E3C;
	Thu, 11 Apr 2024 10:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832130; cv=none; b=OkskfZ8qGtaT+Stsp9YR8VX5aC6vDPn6vPlRVoTAwWSbdiqeGzlaDeQq9CMHkhgH22j1RNveiHdXVSwA3Uu6rdAf+hlpooMno1zjW/Q1r6AXS315rP5akbbqhRg4C6hnmWmjXOjV260NZvp+Y/n0nb2Zg219A39EJEWK8WaUziU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832130; c=relaxed/simple;
	bh=BqWnsPUgaXbfyT166bwskhR5NXBzeq1RTiB1GSCx96I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqIMalYJN3vEm4wwtdcURVAf1tqC/iRHMqN3iAU0GUQamb1tAXbn2M36FLGkXfDVHLhhb3+5uxXiNUgKPuK+h9JB/ViDST+sa1UpAh6r2AtScenIpzO33kUOuMs3oRLWl5iVID1/bBcoD+2bRGbPUAeZ4zC0Cce91UYaO5gCuXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujk7JEwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujk7JEwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FCEC433F1;
	Thu, 11 Apr 2024 10:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832130;
	bh=BqWnsPUgaXbfyT166bwskhR5NXBzeq1RTiB1GSCx96I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujk7JEwOuIllvXZRUlD7eoYa8rawtUVkG2d8iCMCH8oJryvhCZHE/c2qHzpGAYmfT
	 OSPhh4p9i4IwL05qKN+lUsGzmnn89TZxPXdDhfm0rRVVfh1f99E6eEnpChzLhYN0nB
	 ue0Aaf3BKVU87NsQF/14uf6vpzf0LMsAEO/E3nUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 240/294] mptcp: dont account accept() of non-MPC client as fallback to TCP
Date: Thu, 11 Apr 2024 11:56:43 +0200
Message-ID: <20240411095442.800522688@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Caratti <dcaratti@redhat.com>

commit 7a1b3490f47e88ec4cbde65f1a77a0f4bc972282 upstream.

Current MPTCP servers increment MPTcpExtMPCapableFallbackACK when they
accept non-MPC connections. As reported by Christoph, this is "surprising"
because the counter might become greater than MPTcpExtMPCapableSYNRX.

MPTcpExtMPCapableFallbackACK counter's name suggests it should only be
incremented when a connection was seen using MPTCP options, then a
fallback to TCP has been done. Let's do that by incrementing it when
the subflow context of an inbound MPC connection attempt is dropped.
Also, update mptcp_connect.sh kselftest, to ensure that the
above MIB does not increment in case a pure TCP client connects to a
MPTCP server.

Fixes: fc518953bc9c ("mptcp: add and use MIB counter infrastructure")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/449
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240329-upstream-net-20240329-fallback-mib-v1-1-324a8981da48@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 ---
 net/mptcp/subflow.c  |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2218,9 +2218,6 @@ static struct sock *mptcp_accept(struct
 
 		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
 		local_bh_enable();
-	} else {
-		MPTCP_INC_STATS(sock_net(sk),
-				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
 	}
 
 out:
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -595,6 +595,9 @@ create_child:
 			if (fallback_is_fatal)
 				goto dispose_child;
 
+			if (fallback)
+				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
+
 			subflow_drop_ctx(child);
 			goto out;
 		}


