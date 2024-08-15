Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B211A2570;
	Thu, 15 Aug 2024 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732931; cv=none; b=RXlyu5wwvoOzG/qhhSVaE5dAGgtAuG5Rn4YJQzkwJJZdQCq0ONQuhHFlzIutW9Q/7GdEzDhKKF5ZVapUKbWHG1554M5tyUlQZoJSdVprrovExbMGi2jEVXiZuDxQWyH330Cpwp3sljBhZSKz3BJYCl6JkDTeZM6Gwn6tyyloVZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732931; c=relaxed/simple;
	bh=Pkw4h1ydNdaGiIlYOb+LMifHdli0LvOA5naCUYDAV48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUzTP7OwWplvAcjn2jU+61CNKzXipUlILuG3xHI3fN0J4GFPFUI8E0gTgU8xfgh0EgcY40PvoS50awVihKLs6gyU8PSO43N7rqdLBPWRlj4G7HpVGbqGfD/ywo0bziWaq4R1P27t/VjDbcrTAjNNJUMO+F97itlXKiiCIU7mkLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cd/tHSSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cd/tHSSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D716CC4AF0C;
	Thu, 15 Aug 2024 14:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732931;
	bh=Pkw4h1ydNdaGiIlYOb+LMifHdli0LvOA5naCUYDAV48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cd/tHSSc5qLMQiUOxbrKGQOqIfK560CAgfTrfT/8dV1chY6ROUFvov889fYf5AKDm
	 eACf11DpIj7LX9xzfE1pmh8Qq8GfCIvATnd4aNTFLTUYyi8XhJd/jhgQ6XBoOZWOwN
	 sjtUeg2ez4Prn1LvuUfD7+ugqrVusAPqdxJHKyfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 331/352] mptcp: mib: count MPJ with backup flag
Date: Thu, 15 Aug 2024 15:26:37 +0200
Message-ID: <20240815131932.251284980@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

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
[ Conflicts in subflow.c because the context has changed in
  commit b3ea6b272d79 ("mptcp: consolidate initial ack seq generation")
  and commit 5bc56388c74f ("mptcp: add port number check for MP_JOIN")
  which are not in this version. These commits are unrelated to this
  modification. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/mib.c     |    2 ++
 net/mptcp/mib.h     |    2 ++
 net/mptcp/subflow.c |    6 ++++++
 3 files changed, 10 insertions(+)

--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -16,7 +16,9 @@ static const struct snmp_mib mptcp_snmp_
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
@@ -9,7 +9,9 @@ enum linux_mptcp_mib_field {
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
@@ -135,6 +135,9 @@ static void subflow_init_req(struct requ
 			return;
 	} else if (mp_opt.mp_join) {
 		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINSYNRX);
+
+		if (mp_opt.backup)
+			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINSYNBACKUPRX);
 	}
 
 	if (mp_opt.mp_capable && listener->request_mptcp) {
@@ -347,6 +350,9 @@ static void subflow_finish_connect(struc
 
 		subflow->mp_join = 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKRX);
+
+		if (subflow->backup)
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKBACKUPRX);
 	} else if (mptcp_check_fallback(sk)) {
 fallback:
 		mptcp_rcv_space_init(mptcp_sk(parent), sk);


