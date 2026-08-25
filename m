Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A248F481AA6;
	Tue, 25 Aug 2026 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666330; cv=none; b=nLzu88ILArejQrb4XQhuVbb5ecWa3j9slgMjP6k06ZqLnNNjk1EMdhubgKggfAx7yLQw5TyqGzSu9ypvJ6yqUtVpiq5rkMIay6qJt8axvbJskbFpeO3KPI9GKjoGJZZgMRQcHNq1P7SdjRWURRCVX1FcllgezJ3YN3K8MyoTMx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666330; c=relaxed/simple;
	bh=dMbOj04O2XVihy/rhoxuqOia8piPZvOMOwFyqO/YPJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr+XiP75QzO6+Dq/nq27YdQqbaEEvGX4ei443phv4ErOztmXzqZ1uuWFoAdbHY+h/TD4CX9kv/Gv4UWQcomyEt8mzcps7lmUVvjkWuaMWfktJDU16cbpn/EL3bbm/YMB0lHudg8niObW6I72oSlUD8V1IX6tF48bqe40VV2ETvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2f+wJZJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2f+wJZJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1901F000E9;
	Tue, 25 Aug 2026 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666328;
	bh=KhCXgOM7yoPNOvDti3mhRBpZNK62YtI16IqQJWWOzHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2f+wJZJDNdkihQivJ0gz4wjlQdAW2a5kI3cEFBgrwBYIu88wa2ylDiCEB7K7uBJJo
	 J0i1a8rijUOIj86CIWwaB1H9R8kyds4Xq+7XwvljGWoyMMomtHOd5xCWyEXWduHYjh
	 L2cS4c3+AUwPmWaDems79SWF6O4LWbla2SZgMA+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/76] mptcp: avoid combining some incoming suboptions
Date: Tue, 25 Aug 2026 15:26:42 +0200
Message-ID: <20260825132543.496629832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit b6ee361524641f57b2e2363f7737f20e17f67827 ]

Some MPTCP suboptions are mutually exclusive according to the RFC8684,
but also because in different places, the code doesn't expect some
combinations to be present. That's specially true for suboptions that
would be present twice, but with different attributes.

The new restrictions are the same as the ones applied on the output
side, with mptcp_write_options. The same rules can be reused with a
small fix: an MP_FASTCLOSE can be used with a DSS when the sender picks
this option [1], which is not the case on Linux. Here are the rules:

  Which options can be used together?

  X: mutually exclusive
  O: often used together
  C: can be used together in some cases
  P: could be used together but we prefer not to (optimisations)

  | Opt: | MPC  | MPJ  | DSS  | ADD  |  RM  | PRIO | FAIL |  FC  |
  |------|------|------|------|------|------|------|------|------|
  | MPC  |------|------|------|------|------|------|------|------|
  | MPJ  |  X   |------|------|------|------|------|------|------|
  | DSS  |  X   |  X   |------|------|------|------|------|------|
  | ADD  |  X   |  X   |  P   |------|------|------|------|------|
  | RM   |  C   |  C   |  C   |  P   |------|------|------|------|
  | PRIO |  X   |  C   |  C   |  C   |  C   |------|------|------|
  | FAIL |  X   |  X   |  C   |  X   |  X   |  X   |------|------|
  | FC   |  X   |  X   |  P   |  X   |  X   |  X   |  X   |------|
  | RST  |  X   |  X   |  X   |  X   |  X   |  X   |  O   |  O   |
  |------|------|------|------|------|------|------|------|------|

The only difference is with the 'P': another stack could send and
ADD_ADDR with other suboptions (DSS, RM_ADDR), and this should be
allowed.

A few points of attention:

 - In theory, an MP_CAPABLE could be used with a RM_ADDR, but there is
   no reason to add it with a SYN. Note that even with a 4th ACK, it
   doesn't seem to be useful, except when IDs are known in advance via
   another channel. Better not to break that.

 - Now, combining both an MP_CAPABLE and an MP_JOIN will no longer
   result to a reject of the two options, but only the second suboption
   is ignored. That seems OK to do that for this unexpected error. At
   least now all inconsistent combinations are handled the same way.
   This could change later in next. This also means the explicit checks
   for having both MPC + MPJ in subflow.c will now be unreachable.
   That's fine, they will be removed in a follow-up patch.

 - In case of conflicting combinations, the extra suboption(s) is/are
   ignored: having such combinations either means the remote peer is
   buggy, or is evil. The simplest action is then taken in this case:
   stop processing the current suboption.

 - In mp_opt->suboptions, there is also a bit reserved to the checksum,
   which can be used in an MP_CAPABLE and a DSS. Each time a DSS option
   can be used in parallel with another option, the checksum can be set,
   so the verification is combined into a new OPTIONS_MPTCP_DSS macro.

 - An MP_CAPABLE ACK can carry a Data-Level Length, and an optional
   Checksum: they are the same as the ones found in a DSS, because a DSS
   cannot be used in parallel to an MP_CAPABLE. Similarly, even if there
   is room, a DSS cannot be used with an MP_JOIN.

Fixes: eda7acddf808 ("mptcp: Handle MPTCP TCP options")
Cc: stable@vger.kernel.org
Link: https://www.rfc-editor.org/rfc/rfc8684.html#section-3.5-5.1 [1]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-2-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ used `!(TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)` instead of missing `subopt` variable and `OPTIONS_MPTCP_MPC` instead of `OPTION_MPTCP_MPC_ACK` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |    1 
 2 files changed, 58 insertions(+)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -45,6 +45,14 @@ static void mptcp_parse_option(const str
 				expected_opsize = TCPOLEN_MPTCP_MPC_SYN;
 		}
 
+		/* Only the MPC + ACK can be used with a RM_ADDR */
+		if (!(TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)) {
+			if ((mp_opt->suboptions & ~OPTION_MPTCP_RM_ADDR) != 0)
+				break;
+		} else if (mp_opt->suboptions != 0) {
+			break;
+		}
+
 		/* Cfr RFC 8684 Section 3.3.0:
 		 * If a checksum is present but its use had
 		 * not been negotiated in the MP_CAPABLE handshake, the receiver MUST
@@ -117,6 +125,11 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_MP_JOIN:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTION_MPTCP_RM_ADDR |
+					    OPTION_MPTCP_PRIO)) != 0)
+			break;
+
 		if (opsize == TCPOLEN_MPTCP_MPJ_SYN) {
 			mp_opt->suboptions |= OPTION_MPTCP_MPJ_SYN;
 			mp_opt->backup = *ptr++ & MPTCPOPT_BACKUP;
@@ -148,6 +161,14 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_DSS:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTION_MPTCP_ADD_ADDR |
+					    OPTION_MPTCP_RM_ADDR |
+					    OPTION_MPTCP_PRIO |
+					    OPTION_MPTCP_FASTCLOSE |
+					    OPTION_MPTCP_FAIL)) != 0)
+			break;
+
 		pr_debug("DSS\n");
 		ptr++;
 
@@ -235,6 +256,12 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_ADD_ADDR:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_RM_ADDR |
+					    OPTION_MPTCP_PRIO)) != 0)
+			break;
+
 		mp_opt->echo = (*ptr++) & MPTCP_ADDR_ECHO;
 		if (!mp_opt->echo) {
 			if (opsize == TCPOLEN_MPTCP_ADD_ADDR ||
@@ -294,6 +321,14 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_RM_ADDR:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_MPC |
+					    OPTIONS_MPTCP_MPJ |
+					    OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_ADD_ADDR |
+					    OPTION_MPTCP_PRIO)) != 0)
+			break;
+
 		if (opsize < TCPOLEN_MPTCP_RM_ADDR_BASE + 1 ||
 		    opsize > TCPOLEN_MPTCP_RM_ADDR_BASE + MPTCP_RM_IDS_MAX)
 			break;
@@ -308,6 +343,13 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_MP_PRIO:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_MPJ |
+					    OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_ADD_ADDR |
+					    OPTION_MPTCP_RM_ADDR)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_PRIO)
 			break;
 
@@ -317,6 +359,11 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_MP_FASTCLOSE:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_RST)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_FASTCLOSE)
 			break;
 
@@ -327,6 +374,11 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_RST:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTION_MPTCP_FAIL |
+					    OPTION_MPTCP_FASTCLOSE)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_RST)
 			break;
 
@@ -340,6 +392,11 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_MP_FAIL:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_RST)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_FAIL)
 			break;
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -35,6 +35,7 @@
 				 OPTION_MPTCP_MPC_ACK)
 #define OPTIONS_MPTCP_MPJ	(OPTION_MPTCP_MPJ_SYN | OPTION_MPTCP_MPJ_SYNACK | \
 				 OPTION_MPTCP_MPJ_ACK)
+#define OPTIONS_MPTCP_DSS	(OPTION_MPTCP_DSS | OPTION_MPTCP_CSUMREQD)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0


