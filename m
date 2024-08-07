Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFA181AB6;
	Wed,  7 Aug 2024 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043165; cv=none; b=N2/l3odi6EJnnPXWYijCOh8vKMHUYJSzFefQGUPci9TVGYlcaIjFtUsIp52G8uCxuhfG/gkMKRBoGpSI/YASo80SC7jPnGjurljp6KwB33qk9xET5zIXyJLZcQ6DU/IXGNFl8AQNA4mxHCkvesNGq/gUJDP9L9AwL+n8Wotqh9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043165; c=relaxed/simple;
	bh=PDQDAiXjn8sMJ2zUX2PnnizrUw9A7SDYSSKpolXhA04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y22Dh7FWjRuaMB0b19oLrDbzfoWG4P8ZibV4XsG0DNIM/hImRoyVbCpCj/TwI3xvw3CGeErEP5Q/IdHpJIoMR6+Q1Pq9ft/+LdUyimn1LRxtULBr9PgdIYd+nHxm/qHdU3GJ2OVBnQo4JNjOqWcoDqgQmkVh4LvCs6LSqXklS3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jv70l6t0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jv70l6t0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C143C32781;
	Wed,  7 Aug 2024 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043165;
	bh=PDQDAiXjn8sMJ2zUX2PnnizrUw9A7SDYSSKpolXhA04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jv70l6t011sI7YkJRo9Let03RMGVTraG4WEKRMy9kMe0HFDKgKuSvxYmXtsJeMo16
	 JmBXkrNguCgH9MxivewT5eBRRe1wVCU4FIvjTKiJV1GivYqyaJ22ifg5AnYe1DE5aN
	 FLOildsDdLgjNjJXx48g+WA4fzcTTiB8+apWfc4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 115/123] mptcp: mib: count MPJ with backup flag
Date: Wed,  7 Aug 2024 17:00:34 +0200
Message-ID: <20240807150024.627611863@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 4dde0d72ccec500c60c798e036b852e013d6e124 upstream.

Without such counters, it is difficult to easily debug issues with MPJ
not having the backup flags on production servers.

This is not strictly a fix, but it eases to validate the following
patches without requiring to take packet traces, to query ongoing
connections with Netlink with admin permissions, or to guess by looking
at the behaviour of the packet scheduler. Also, the modification is self
contained, isolated, well controlled, and the increments are done just
after others, there from the beginning. It looks then safe, and helpful
to backport this.

Fixes: 4596a2c1b7f5 ("mptcp: allow creating non-backup subflows")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/mib.c     |    2 ++
 net/mptcp/mib.h     |    2 ++
 net/mptcp/subflow.c |    6 ++++++
 3 files changed, 10 insertions(+)

--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -19,7 +19,9 @@ static const struct snmp_mib mptcp_snmp_
 	SNMP_MIB_ITEM("MPTCPRetrans", MPTCP_MIB_RETRANSSEGS),
 	SNMP_MIB_ITEM("MPJoinNoTokenFound", MPTCP_MIB_JOINNOTOKEN),
 	SNMP_MIB_ITEM("MPJoinSynRx", MPTCP_MIB_JOINSYNRX),
+	SNMP_MIB_ITEM("MPJoinSynBackupRx", MPTCP_MIB_JOINSYNBACKUPRX),
 	SNMP_MIB_ITEM("MPJoinSynAckRx", MPTCP_MIB_JOINSYNACKRX),
+	SNMP_MIB_ITEM("MPJoinSynAckBackupRx", MPTCP_MIB_JOINSYNACKBACKUPRX),
 	SNMP_MIB_ITEM("MPJoinSynAckHMacFailure", MPTCP_MIB_JOINSYNACKMAC),
 	SNMP_MIB_ITEM("MPJoinAckRx", MPTCP_MIB_JOINACKRX),
 	SNMP_MIB_ITEM("MPJoinAckHMacFailure", MPTCP_MIB_JOINACKMAC),
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -14,7 +14,9 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_RETRANSSEGS,		/* Segments retransmitted at the MPTCP-level */
 	MPTCP_MIB_JOINNOTOKEN,		/* Received MP_JOIN but the token was not found */
 	MPTCP_MIB_JOINSYNRX,		/* Received a SYN + MP_JOIN */
+	MPTCP_MIB_JOINSYNBACKUPRX,	/* Received a SYN + MP_JOIN + backup flag */
 	MPTCP_MIB_JOINSYNACKRX,		/* Received a SYN/ACK + MP_JOIN */
+	MPTCP_MIB_JOINSYNACKBACKUPRX,	/* Received a SYN/ACK + MP_JOIN + backup flag */
 	MPTCP_MIB_JOINSYNACKMAC,	/* HMAC was wrong on SYN/ACK + MP_JOIN */
 	MPTCP_MIB_JOINACKRX,		/* Received an ACK + MP_JOIN */
 	MPTCP_MIB_JOINACKMAC,		/* HMAC was wrong on ACK + MP_JOIN */
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -168,6 +168,9 @@ static int subflow_check_req(struct requ
 			return 0;
 	} else if (opt_mp_join) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINSYNRX);
+
+		if (mp_opt.backup)
+			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINSYNBACKUPRX);
 	}
 
 	if (opt_mp_capable && listener->request_mptcp) {
@@ -577,6 +580,9 @@ static void subflow_finish_connect(struc
 		subflow->mp_join = 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKRX);
 
+		if (subflow->backup)
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKBACKUPRX);
+
 		if (subflow_use_different_dport(msk, sk)) {
 			pr_debug("synack inet_dport=%d %d",
 				 ntohs(inet_sk(sk)->inet_dport),


