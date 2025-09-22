Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A80F17A2EA;
	Mon, 22 Sep 2025 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569574; cv=none; b=E1oxleJT4lKOp74EoqUfHbkvFo7AJaRnRdCm7aeX4KYOYAxXfMGGYrnxosmMnHNcO1XgC89NaYDNEd61s20R5RH8g5iyK2OQP1RW6A/Qrj+b27I4qt7RuV4EtAcnY6LcBiJIZpFzHuNafC0Gx36ijQp2N8EB/0QpFXxrAByVLFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569574; c=relaxed/simple;
	bh=8fuuRMWOKE50ARGTvbKcr4c5d6vaerX6eBzbNns1/BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLhyGVrWzh7fgNVycM/aYF6K08Kf/bGx/oBqS8+BtN4eRuXMnh1Xgkc7xL9/i+hb8rgB+p3f/aULEXLPSDAYs7EfQ8+NTpP+OnHT9eJyilM7ABqCmIAJV7FFCsBGBd8zLaWrIll/Rt+UpoQ47k2F0yvRAu20qIGyO8GWlSIOUgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSB5JP8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSB5JP8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BEFC4CEF0;
	Mon, 22 Sep 2025 19:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569574;
	bh=8fuuRMWOKE50ARGTvbKcr4c5d6vaerX6eBzbNns1/BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSB5JP8eWHQAgAsMdMO7VNK7RNsZlyHqwPFNHIkPdo5rieRFCtj8h/Ftcq/qlt/8u
	 NZyzHOdCoISs1t3nFQAKmQV/GhB1keZ2K81RKfd6it8PkrqSsN6lh8ufbW/nkFVbKh
	 L/b7tc2zjxZBl4NnJKXLszkUWfv/RAUpl2Mnuvm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 34/61] selftests: mptcp: avoid spurious errors on TCP disconnect
Date: Mon, 22 Sep 2025 21:29:27 +0200
Message-ID: <20250922192404.500508553@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

commit 8708c5d8b3fb3f6d5d3b9e6bfe01a505819f519a upstream.

The disconnect test-case, with 'plain' TCP sockets generates spurious
errors, e.g.

  07 ns1 TCP   -> ns1 (dead:beef:1::1:10006) MPTCP
  read: Connection reset by peer
  read: Connection reset by peer
  (duration   155ms) [FAIL] client exit code 3, server 3

  netns ns1-FloSdv (listener) socket stat for 10006:
  TcpActiveOpens                  2                  0.0
  TcpPassiveOpens                 2                  0.0
  TcpEstabResets                  2                  0.0
  TcpInSegs                       274                0.0
  TcpOutSegs                      276                0.0
  TcpOutRsts                      3                  0.0
  TcpExtPruneCalled               2                  0.0
  TcpExtRcvPruned                 1                  0.0
  TcpExtTCPPureAcks               104                0.0
  TcpExtTCPRcvCollapsed           2                  0.0
  TcpExtTCPBacklogCoalesce        42                 0.0
  TcpExtTCPRcvCoalesce            43                 0.0
  TcpExtTCPChallengeACK           1                  0.0
  TcpExtTCPFromZeroWindowAdv      42                 0.0
  TcpExtTCPToZeroWindowAdv        41                 0.0
  TcpExtTCPWantZeroWindowAdv      13                 0.0
  TcpExtTCPOrigDataSent           164                0.0
  TcpExtTCPDelivered              165                0.0
  TcpExtTCPRcvQDrop               1                  0.0

In the failing scenarios (TCP -> MPTCP), the involved sockets are
actually plain TCP ones, as fallbacks for passive sockets at 2WHS time
cause the MPTCP listeners to actually create 'plain' TCP sockets.

Similar to commit 218cc166321f ("selftests: mptcp: avoid spurious errors
on disconnect"), the root cause is in the user-space bits: the test
program tries to disconnect as soon as all the pending data has been
spooled, generating an RST. If such option reaches the peer before the
connection has reached the closed status, the TCP socket will report an
error to the user-space, as per protocol specification, causing the
above failure. Note that it looks like this issue got more visible since
the "tcp: receiver changes" series from commit 06baf9bfa6ca ("Merge
branch 'tcp-receiver-changes'").

Address the issue by explicitly waiting for the TCP sockets (-t) to
reach a closed status before performing the disconnect. More precisely,
the test program now waits for plain TCP sockets or TCP subflows in
addition to the MPTCP sockets that were already monitored.

While at it, use 'ss' with '-n' to avoid resolving service names, which
is not needed here.

Fixes: 218cc166321f ("selftests: mptcp: avoid spurious errors on disconnect")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-fix-sft-connect-v1-3-d40e77cbbf02@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1153,7 +1153,7 @@ void xdisconnect(int fd)
 	else
 		xerror("bad family");
 
-	strcpy(cmd, "ss -M | grep -q ");
+	strcpy(cmd, "ss -Mnt | grep -q ");
 	cmdlen = strlen(cmd);
 	if (!inet_ntop(addr.ss_family, raw_addr, &cmd[cmdlen],
 		       sizeof(cmd) - cmdlen))
@@ -1163,7 +1163,7 @@ void xdisconnect(int fd)
 
 	/*
 	 * wait until the pending data is completely flushed and all
-	 * the MPTCP sockets reached the closed status.
+	 * the sockets reached the closed status.
 	 * disconnect will bypass/ignore/drop any pending data.
 	 */
 	for (i = 0; ; i += msec_sleep) {


