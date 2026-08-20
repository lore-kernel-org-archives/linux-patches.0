Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9AF25B0AA;
	Thu, 20 Aug 2026 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239473; cv=none; b=ud4hFqo4rI99CArOrDAiD6Rtpdt8W9Y1aCdyZvoq0YiJPOBe6CEibh3ktuXcfGRAh+8qVsl3RGIUCr70t0cnByyfVkLLcKlbfnlJKi17sxa+0d7/715nSeojeOFUO6QT3lLOGdGKY3mqkFjAPuNSOEdihhOskWM3D7uMleu/E6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239473; c=relaxed/simple;
	bh=aXd9FC5eE9PpBY0/s6TitURZlcHWqXVwQpTpRzbQNVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ3fsWk0OtG1ii4Im/XfPOSEjtQ8E0UIE0Dkp5SSXpmKS7yu1OLgFwIN1Rl8QRRbwCpJVCMHWsma64eLgs4mFZdU4kOtEBQC3y2RqXG+RTPyVVxb2D65W6LTL27RN/AzGRr4yKpilXJNE0xc1y7i7IhxjO3xzV5bwQIwDSbqBxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxWE5LUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxWE5LUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6291F000E9;
	Thu, 20 Aug 2026 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239471;
	bh=/QlCLrbbXcnoAHZrAu+N7sRLgURpwAZ+rIPxmSZ4YsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxWE5LUQM20IIK5eyUFV+LEVlT2Pe6hdPozY3tvIOxn3AH20I3LpXQIYejOVaPg60
	 QlfCIuVdpmSWXuYQw88jmyFeBpnKdcPx1O6/2H2t0nsjAGHRX9ruuSfkbwyAW3tLc3
	 aAzpEvqUFNtb/6U72i2adzvF9CtkLQHVeoEEuxnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 021/220] mptcp: avoid combining some incoming suboptions
Date: Thu, 20 Aug 2026 16:53:31 +0200
Message-ID: <20260820145224.142425264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit b6ee361524641f57b2e2363f7737f20e17f67827 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.h |    1 
 2 files changed, 59 insertions(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -50,6 +50,14 @@ static void mptcp_parse_option(const str
 			}
 		}
 
+		/* Only the MPC + ACK can be used with a RM_ADDR */
+		if (subopt == OPTION_MPTCP_MPC_ACK) {
+			if ((mp_opt->suboptions & ~OPTION_MPTCP_RM_ADDR) != 0)
+				break;
+		} else if (mp_opt->suboptions != 0) {
+			break;
+		}
+
 		/* Cfr RFC 8684 Section 3.3.0:
 		 * If a checksum is present but its use had
 		 * not been negotiated in the MP_CAPABLE handshake, the receiver MUST
@@ -122,6 +130,11 @@ static void mptcp_parse_option(const str
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
@@ -153,6 +166,14 @@ static void mptcp_parse_option(const str
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
 
@@ -234,6 +255,12 @@ static void mptcp_parse_option(const str
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
@@ -293,6 +320,14 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_RM_ADDR:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTION_MPTCP_MPC_ACK |
+					    OPTIONS_MPTCP_MPJ |
+					    OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_ADD_ADDR |
+					    OPTION_MPTCP_PRIO)) != 0)
+			break;
+
 		if (opsize < TCPOLEN_MPTCP_RM_ADDR_BASE + 1 ||
 		    opsize > TCPOLEN_MPTCP_RM_ADDR_BASE + MPTCP_RM_IDS_MAX)
 			break;
@@ -307,6 +342,13 @@ static void mptcp_parse_option(const str
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
 
@@ -316,6 +358,11 @@ static void mptcp_parse_option(const str
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
 
@@ -342,6 +394,11 @@ static void mptcp_parse_option(const str
 		break;
 
 	case MPTCPOPT_MP_FAIL:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_RST)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_FAIL)
 			break;
 
@@ -1416,7 +1473,7 @@ void mptcp_write_options(struct tcphdr *
 	 *  RM   |  C   |  C   |  C   |  P   |------|------|------|------|
 	 *  PRIO |  X   |  C   |  C   |  C   |  C   |------|------|------|
 	 *  FAIL |  X   |  X   |  C   |  X   |  X   |  X   |------|------|
-	 *  FC   |  X   |  X   |  X   |  X   |  X   |  X   |  X   |------|
+	 *  FC   |  X   |  X   |  P   |  X   |  X   |  X   |  X   |------|
 	 *  RST  |  X   |  X   |  X   |  X   |  X   |  X   |  O   |  O   |
 	 * ------|------|------|------|------|------|------|------|------|
 	 *
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -37,6 +37,7 @@
 				 OPTION_MPTCP_MPC_ACK)
 #define OPTIONS_MPTCP_MPJ	(OPTION_MPTCP_MPJ_SYN | OPTION_MPTCP_MPJ_SYNACK | \
 				 OPTION_MPTCP_MPJ_ACK)
+#define OPTIONS_MPTCP_DSS	(OPTION_MPTCP_DSS | OPTION_MPTCP_CSUMREQD)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0


