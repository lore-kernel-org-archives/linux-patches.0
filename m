Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91592F0C5E;
	Mon, 22 Sep 2025 19:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569668; cv=none; b=J+aP0YArxLHk+Pj7Pe5y2e03zAslhO1/LBiO4FiVXzQ3CzgZPHeuXSqbpjHpGu5oNrg1tDmGp8tZmINumQQEOHE63RjO6j6NrOhznYDbJ361UsnWn1a84+wA3D+iLlahE+QrU8/OFYAvGT5mA0CHS9NXIJBtYAqC9cq+jU54z74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569668; c=relaxed/simple;
	bh=0J8XijI1nvbWz5FYvTnIvaxwYQwOvF0KsZ6k7mLQMJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/woKTAKLaeWTmwvkeNCdGtn5EMeaFOWmc11udVkGZs19aohNMaQAJPdqIAeCWQjGBlt1GBEL7jd2KzW9b5b9whzh+ZcFTpW/8XyVogR12dDQ9UoIq8WsLBPsy6LY+WT/TyEAF/nkrlXw84n2MJAURQCm3FhpcERrF25BvgD7w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaTl3wXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaTl3wXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73526C4CEF0;
	Mon, 22 Sep 2025 19:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569668;
	bh=0J8XijI1nvbWz5FYvTnIvaxwYQwOvF0KsZ6k7mLQMJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FaTl3wXvNpLMIlfXgV2C0DWt8l7F8e9QibCea78l8AXuzQ9n1dH+vrfq09ttyvN8S
	 ejFq/704NS7SzOApejJ+T1GdG2J7by1B0ilIK4LYgsM2pD43z+A5gLQMh2ZHeK5uqX
	 mnv73jA16GFzKiwRmrHlGTAvmlPXOMKA2Cpdl/XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 14/70] selftests: mptcp: sockopt: fix error messages
Date: Mon, 22 Sep 2025 21:29:14 +0200
Message-ID: <20250922192404.900623676@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit b86418beade11d45540a2d20c4ec1128849b6c27 ]

This patch fixes several issues in the error reporting of the MPTCP sockopt
selftest:

1. Fix diff not printed: The error messages for counter mismatches had
   the actual difference ('diff') as argument, but it was missing in the
   format string. Displaying it makes the debugging easier.

2. Fix variable usage: The error check for 'mptcpi_bytes_acked' incorrectly
   used 'ret2' (sent bytes) for both the expected value and the difference
   calculation. It now correctly uses 'ret' (received bytes), which is the
   expected value for bytes_acked.

3. Fix off-by-one in diff: The calculation for the 'mptcpi_rcv_delta' diff
   was 's.mptcpi_rcv_delta - ret', which is off-by-one. It has been
   corrected to 's.mptcpi_rcv_delta - (ret + 1)' to match the expected
   value in the condition above it.

Fixes: 5dcff89e1455 ("selftests: mptcp: explicitly tests aggregate counters")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-pm-uspace-deny_join_id0-v1-5-40171884ade8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_sockopt.c  | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
index 926b0be87c990..1dc2bd6ee4a50 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
@@ -658,22 +658,26 @@ static void process_one_client(int fd, int pipefd)
 
 	do_getsockopts(&s, fd, ret, ret2);
 	if (s.mptcpi_rcv_delta != (uint64_t)ret + 1)
-		xerror("mptcpi_rcv_delta %" PRIu64 ", expect %" PRIu64, s.mptcpi_rcv_delta, ret + 1, s.mptcpi_rcv_delta - ret);
+		xerror("mptcpi_rcv_delta %" PRIu64 ", expect %" PRIu64 ", diff %" PRId64,
+		       s.mptcpi_rcv_delta, ret + 1, s.mptcpi_rcv_delta - (ret + 1));
 
 	/* be nice when running on top of older kernel */
 	if (s.pkt_stats_avail) {
 		if (s.last_sample.mptcpi_bytes_sent != ret2)
-			xerror("mptcpi_bytes_sent %" PRIu64 ", expect %" PRIu64,
+			xerror("mptcpi_bytes_sent %" PRIu64 ", expect %" PRIu64
+			       ", diff %" PRId64,
 			       s.last_sample.mptcpi_bytes_sent, ret2,
 			       s.last_sample.mptcpi_bytes_sent - ret2);
 		if (s.last_sample.mptcpi_bytes_received != ret)
-			xerror("mptcpi_bytes_received %" PRIu64 ", expect %" PRIu64,
+			xerror("mptcpi_bytes_received %" PRIu64 ", expect %" PRIu64
+			       ", diff %" PRId64,
 			       s.last_sample.mptcpi_bytes_received, ret,
 			       s.last_sample.mptcpi_bytes_received - ret);
 		if (s.last_sample.mptcpi_bytes_acked != ret)
-			xerror("mptcpi_bytes_acked %" PRIu64 ", expect %" PRIu64,
-			       s.last_sample.mptcpi_bytes_acked, ret2,
-			       s.last_sample.mptcpi_bytes_acked - ret2);
+			xerror("mptcpi_bytes_acked %" PRIu64 ", expect %" PRIu64
+			       ", diff %" PRId64,
+			       s.last_sample.mptcpi_bytes_acked, ret,
+			       s.last_sample.mptcpi_bytes_acked - ret);
 	}
 
 	close(fd);
-- 
2.51.0



