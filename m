Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CC71D0438;
	Wed,  2 Oct 2024 14:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879732; cv=none; b=McjXr0h6u1sDFBUBjTVHLp//upzfAqeEhFjSyH1iO+8z6T3wNgrxjdA4/O7d7vJJ1IqGkCYtBfd6Dq1gTnJB/FcfsyS4XGEVl+9Bid89R1fJZpJK86HeGbYvX+gNY/fyoerRrCx4DPflzRtJCHAtA1aIrNTJdi+dIdHkQCovSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879732; c=relaxed/simple;
	bh=JLwAqmTN2pWxTvqRsLjxgG6xTxIbVZ8yY2VKNaeibSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sF8OD0i9wiDbWX7gVmHo4pY3qsqHzbAAkoshbt3n/JzSlCLzx1oJEoIBbkUalG6k+Tj3gpB0UPIg1YnwuWxF/qqzHQXUz92lZdC1HD3GyAIA9jXXFNXumQWuVQPo8NxImWMHpo1DRB7G6nAJmep+eisNjtpekq6NBjjVKCdtfqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlT6v7ZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlT6v7ZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729AEC4CEC2;
	Wed,  2 Oct 2024 14:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879731;
	bh=JLwAqmTN2pWxTvqRsLjxgG6xTxIbVZ8yY2VKNaeibSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlT6v7ZRrOYhNIbI691VzObOPV+M9/32iTuJjGOvqvItoCKr2pR95PrsFPiTEya3t
	 WyH2DdruHP7DdH+8OYvn9/DKFPmH5pVJFTst2ny1y+CsPUem3XRGs6L9E7MMGBuHlR
	 DsWuUTYGfybT5qezSrF+6pGKIT/ayYU9u8YXIcbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/538] selftests/bpf: Fix error compiling tc_redirect.c with musl libc
Date: Wed,  2 Oct 2024 14:57:38 +0200
Message-ID: <20241002125800.901202725@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 21c5f4f55da759c7444a1ef13e90b6e6f674eeeb ]

Linux 5.1 implemented 64-bit time types and related syscalls to address the
Y2038 problem generally across archs. Userspace handling of Y2038 varies
with the libc however. While musl libc uses 64-bit time across all 32-bit
and 64-bit platforms, GNU glibc uses 64-bit time on 64-bit platforms but
defaults to 32-bit time on 32-bit platforms unless they "opt-in" to 64-bit
time or explicitly use 64-bit syscalls and time structures.

One specific area is the standard setsockopt() call, SO_TIMESTAMPNS option
used for timestamping, and the related output 'struct timespec'. GNU glibc
defaults as above, also exposing the SO_TIMESTAMPNS_NEW flag to explicitly
use a 64-bit call and 'struct __kernel_timespec'. Since these are not
exposed or needed with musl libc, their use in tc_redirect.c leads to
compile errors building for mips64el/musl:

  tc_redirect.c: In function 'rcv_tstamp':
  tc_redirect.c:425:32: error: 'SO_TIMESTAMPNS_NEW' undeclared (first use in this function); did you mean 'SO_TIMESTAMPNS'?
    425 |             cmsg->cmsg_type == SO_TIMESTAMPNS_NEW)
        |                                ^~~~~~~~~~~~~~~~~~
        |                                SO_TIMESTAMPNS
  tc_redirect.c:425:32: note: each undeclared identifier is reported only once for each function it appears in
  tc_redirect.c: In function 'test_inet_dtime':
  tc_redirect.c:491:49: error: 'SO_TIMESTAMPNS_NEW' undeclared (first use in this function); did you mean 'SO_TIMESTAMPNS'?
    491 |         err = setsockopt(listen_fd, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
        |                                                 ^~~~~~~~~~~~~~~~~~
        |                                                 SO_TIMESTAMPNS

However, using SO_TIMESTAMPNS_NEW isn't strictly needed, nor is Y2038 being
explicitly tested. The timestamp checks in tc_redirect.c are simple: the
packet receive timestamp is non-zero and processed/handled in less than 5
seconds.

Switch to using the standard setsockopt() call and SO_TIMESTAMPNS option to
ensure compatibility across glibc and musl libc. In the worst-case, there
is a 5-second window 14 years from now where tc_redirect tests may fail on
32-bit systems. However, we should reasonably expect glibc to adopt a
64-bit mandate rather than the current "opt-in" policy before the Y2038
roll-over.

Fixes: ce6f6cffaeaa ("selftests/bpf: Wait for the netstamp_needed_key static key to be turned on")
Fixes: c803475fd8dd ("bpf: selftests: test skb->tstamp in redirect_neigh")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/031d656c058b4e55ceae56ef49c4e1729b5090f3.1722244708.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tc_redirect.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index af3c31f82a8ae..5a64017335875 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -421,7 +421,7 @@ static int set_forwarding(bool enable)
 
 static int __rcv_tstamp(int fd, const char *expected, size_t s, __u64 *tstamp)
 {
-	struct __kernel_timespec pkt_ts = {};
+	struct timespec pkt_ts = {};
 	char ctl[CMSG_SPACE(sizeof(pkt_ts))];
 	struct timespec now_ts;
 	struct msghdr msg = {};
@@ -445,7 +445,7 @@ static int __rcv_tstamp(int fd, const char *expected, size_t s, __u64 *tstamp)
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg && cmsg->cmsg_level == SOL_SOCKET &&
-	    cmsg->cmsg_type == SO_TIMESTAMPNS_NEW)
+	    cmsg->cmsg_type == SO_TIMESTAMPNS)
 		memcpy(&pkt_ts, CMSG_DATA(cmsg), sizeof(pkt_ts));
 
 	pkt_ns = pkt_ts.tv_sec * NSEC_PER_SEC + pkt_ts.tv_nsec;
@@ -487,9 +487,9 @@ static int wait_netstamp_needed_key(void)
 	if (!ASSERT_GE(srv_fd, 0, "start_server"))
 		goto done;
 
-	err = setsockopt(srv_fd, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
+	err = setsockopt(srv_fd, SOL_SOCKET, SO_TIMESTAMPNS,
 			 &opt, sizeof(opt));
-	if (!ASSERT_OK(err, "setsockopt(SO_TIMESTAMPNS_NEW)"))
+	if (!ASSERT_OK(err, "setsockopt(SO_TIMESTAMPNS)"))
 		goto done;
 
 	cli_fd = connect_to_fd(srv_fd, TIMEOUT_MILLIS);
@@ -571,9 +571,9 @@ static void test_inet_dtime(int family, int type, const char *addr, __u16 port)
 		return;
 
 	/* Ensure the kernel puts the (rcv) timestamp for all skb */
-	err = setsockopt(listen_fd, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
+	err = setsockopt(listen_fd, SOL_SOCKET, SO_TIMESTAMPNS,
 			 &opt, sizeof(opt));
-	if (!ASSERT_OK(err, "setsockopt(SO_TIMESTAMPNS_NEW)"))
+	if (!ASSERT_OK(err, "setsockopt(SO_TIMESTAMPNS)"))
 		goto done;
 
 	if (type == SOCK_STREAM) {
-- 
2.43.0



