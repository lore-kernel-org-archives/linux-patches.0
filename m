Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D87D260569;
	Tue, 30 Sep 2025 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244035; cv=none; b=imZZ6LpW+tEHpYOhb7dAaPdWItn//3aKgJrPyQZnSJNrWYSVwFCrgbIhhD15QSdDeBdJXV18eDRGrIC2ExOaBT4OQ0VeaZpLRbWzhgjG2PO5Ni+IoWK/YQnqM8wl8/xpk12WStsatRdvzpII2n0BCN4EAdukEVlD9jNsTiNmfOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244035; c=relaxed/simple;
	bh=PViqG1FehBJXgQ+FkGreF5P+4oZv9x3GuW3hj3q+OqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6DUNklkt2t6x1vCHvohhCStv6fYm0uZO+qE68X4/W9AQuBbFpN4gJTT3b0urSS/2f2qT9f/X/PgBFZyh7v0A0vmAuRoZFlvKMW3on4nbhK4kW9kSkffgO27G6T2K6AHoPqblrzvFVtMObnQxnwqD+xw+QjcnKT3nbGZK/ec198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkuusczS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkuusczS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716ACC4CEF0;
	Tue, 30 Sep 2025 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244034;
	bh=PViqG1FehBJXgQ+FkGreF5P+4oZv9x3GuW3hj3q+OqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkuusczSVGpcdveC+uvjl2ECdXB1KsaABenmqhEeL3NH8kwRuGjAEvcZpsLucCQKj
	 1ImCefSPLgy6yckJbwW8fUYa4ELQBP0K0EfznijlFYMNABRpdrrGElo/BNYiDf+lcP
	 8XWutxx/O6dkMAHX30YCHeFwB6fLiqkmm15dP4CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Dreibholz <dreibh@simula.no>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Maximilian Heyne <mheyne@amazon.de>
Subject: [PATCH 5.10 001/122] mptcp: pm: kernel: flush: do not reset ADD_ADDR limit
Date: Tue, 30 Sep 2025 16:45:32 +0200
Message-ID: <20250930143823.011639171@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 68fc0f4b0d25692940cdc85c68e366cae63e1757 upstream.

A flush of the MPTCP endpoints should not affect the MPTCP limits. In
other words, 'ip mptcp endpoint flush' should not change 'ip mptcp
limits'.

But it was the case: the MPTCP_PM_ATTR_RCV_ADD_ADDRS (add_addr_accepted)
limit was reset by accident. Removing the reset of this counter during a
flush fixes this issue.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Reported-by: Thomas Dreibholz <dreibh@simula.no>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/579
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-2-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[adjusted patch by removing WRITE_ONCE to take into account the missing
 commit 72603d207d59 ("mptcp: use WRITE_ONCE for the pernet *_max")]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -869,7 +869,6 @@ static void __flush_addrs(struct pm_nl_p
 static void __reset_counters(struct pm_nl_pernet *pernet)
 {
 	pernet->add_addr_signal_max = 0;
-	pernet->add_addr_accept_max = 0;
 	pernet->local_addr_max = 0;
 	pernet->addrs = 0;
 }


