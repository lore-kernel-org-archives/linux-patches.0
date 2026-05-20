Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF89E3F7ABC;
	Wed, 20 May 2026 18:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301738; cv=none; b=iyyvIc7lnde8IAWQtIjA0pSSdMxv25ugxQQHv4WG4OzTCugUNcEJ+KHYeOOdnq0Mrb0EbB0qthskPZgVAJpwnj7LbFGXoTS6YWiyD0BLaZTLJOtIYFCl+l1k2evrsO5ot1eAbqWQMRmuT3n2cwhq2fzkOH4+lSyeTi+jCiO7sNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301738; c=relaxed/simple;
	bh=x4Vaj/cO+UXufd21FcuQTdjtDh9FkNgj0pBt8XoQltE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZTnMuyJXM37b6J/Zvckn3cx8wSAsMTYe9c6EGadf9CAeyeivlMXSCNpTqvMDyb/vPGKUI1UDeR4p5ucKwqk/aohQfduAfVhAWRJ0/7GnBet9tDkqse+MooE1wpx52CHtpM812wXFaEULCDJB/v7ob6AwKXACWOK10xbmLzYdyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejR7yhQy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejR7yhQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302F71F000E9;
	Wed, 20 May 2026 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301736;
	bh=2CUP8Qe2zXHZEKSwTq8DmtM1pWeLQdTqVRUE6H1WfFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejR7yhQyDc2UOcYQcFdkgPGbON/XhJpPfXvCjFNb3VXHSnnbCPRRSXFw9FAQfEYUy
	 NWk6kbuJs7BXkrtKombXEI0v/ElnS0rEZ9ZRf/0hANdCQXoILhz81s4rbeUKhl7Jvk
	 mUsGL4Cux/78RiJ2TciDmmJCfEqoTrzmA0P2fMLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 657/666] mptcp: pm: prio: skip closed subflows
Date: Wed, 20 May 2026 18:24:28 +0200
Message-ID: <20260520162125.526578760@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 166b78344031bf7ac9f55cb5282776cfd85f220e ]

When sending an MP_PRIO, closed subflows need to be skipped.

This fixes the case where the initial subflow got closed, re-opened
later, then an MP_PRIO is needed for the same local address.

Note that explicit MP_PRIO cannot be sent during the 3WHS, so it is fine
to use __mptcp_subflow_active().

Fixes: 067065422fcd ("mptcp: add the outgoing MP_PRIO support")
Cc: stable@vger.kernel.org
Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-9-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ applied to renamed function `mptcp_pm_nl_mp_prio_send_ack()` in `pm_netlink.c` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -920,6 +920,9 @@ int mptcp_pm_nl_mp_prio_send_ack(struct
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct mptcp_addr_info local, remote;
 
+		if (!__mptcp_subflow_active(subflow))
+			continue;
+
 		mptcp_local_address((struct sock_common *)ssk, &local);
 		if (!mptcp_addresses_equal(&local, addr, addr->port))
 			continue;


