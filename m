Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7460F1DE4CD;
	Tue, 26 Aug 2025 13:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214980; cv=none; b=ix6aDe7sx/XjjfXsqMoiDXjEkZuWqPgz1JXw5vtGHnpbTOaeBRzBlNZa2bAZZ+4kYfuB7xKFUnJIXuDAVnBZBIFFdrFXJPbRoH6hws+Axg+sqK96MZoRhxDK9RO+qcF6r3yWUfWkHu6mHV8aDRZqVvdZK74+5lj3s7BD9ZQjGM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214980; c=relaxed/simple;
	bh=zSz8WRE/gT+7VCho03wtC7cTN3LRS3V+GBPD+QHabVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSBtP4Lclcty1Tj883BdqnmcvANrcEEQHqA+DDG+1CjNCt0t8VyVZIA7NJjPQZOggjSVpjBAxCCpqgquJgrt02+YdDu6QDO/vcSLK1Dx2HfRerzveCW/vGUMBRGGKoZm/iCQNDVfOHFm10FdE69PJAp0LUkn6rfZIdAOsFGNpnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qi6u98Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qi6u98Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E14C4CEF1;
	Tue, 26 Aug 2025 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214980;
	bh=zSz8WRE/gT+7VCho03wtC7cTN3LRS3V+GBPD+QHabVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi6u98Q+i5E3ps880wo+JlPpV0n6lCJzUU0ERSMn65L3/Jh4jL54D5jSQPD7Mm8ov
	 SzaE3Wa2NS9SRtDf/JB6TMHmOQ1umSS1wiW907CCNLhy6dZCTiqmsqFzxmLxgq4Ypk
	 NdKNkJtjX9RMS3MWKluZCt1Xl9iK6ZG3qAgubAQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Dreibholz <dreibh@simula.no>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 342/482] mptcp: pm: kernel: flush: do not reset ADD_ADDR limit
Date: Tue, 26 Aug 2025 13:09:55 +0200
Message-ID: <20250826110939.277341412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1778,7 +1778,6 @@ static void __flush_addrs(struct list_he
 static void __reset_counters(struct pm_nl_pernet *pernet)
 {
 	WRITE_ONCE(pernet->add_addr_signal_max, 0);
-	WRITE_ONCE(pernet->add_addr_accept_max, 0);
 	WRITE_ONCE(pernet->local_addr_max, 0);
 	pernet->addrs = 0;
 }


