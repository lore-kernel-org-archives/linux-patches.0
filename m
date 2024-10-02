Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31011D0F4F;
	Wed,  2 Oct 2024 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877980; cv=none; b=I2RLxSS2rabyHm7OJ4WQJ4ScwSa1QfqXm+m3TCSOQLqD/Ur1Ig3aaD1evMyHZ6OtyARxL4j+4DGi1d1+iay0ka+MuKxVwr03ONWbksabUl5da6ioeFh1/T+PIxqk+aQaiPp4aF6JHOdwdbxG9ZwhNyvJEr9bvbRA4pvSdgsl72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877980; c=relaxed/simple;
	bh=6hn8D/7eDYl5xliP30EF4c1vUJxLsCSRidV5sa1Tlzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYKy2SxdHxAMHbVwPVcbEW+jCS+itQKC6jDqzmroV7REQHsxVkScL3fHSh85eNKI6nBe8ke/p8AodAKQW2RgsHvkkz9wJjgGyvudhtVLSUHZon6zcvpekLk3v9x7XOUF7ox7gPMtMea9+h2yF1jAKwoiFLFu+Y9vWFPlaWbZRy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0CSXdfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0CSXdfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58A3C4CECD;
	Wed,  2 Oct 2024 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877980;
	bh=6hn8D/7eDYl5xliP30EF4c1vUJxLsCSRidV5sa1Tlzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0CSXdfjiuVTdl9dTmkhR8EbLEqs4TbeJm1uBOX+94Ihbk8OSSIeKBX6eip+Ie5ij
	 ugw1jjd2V/U/Su4Ne5cl/NfxWshJ2Qu1rUYvNxbJ+k7aY3/iRrVL4vmHSTkcuDVduG
	 PdC0k491GkmRhxb2i+EWkoA9nS+Nwssp7YMD7/jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 260/634] selftests/bpf: Fix error compiling tc_redirect.c with musl libc
Date: Wed,  2 Oct 2024 14:56:00 +0200
Message-ID: <20241002125821.363412064@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
index b1073d36d77ac..a80a83e0440e3 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -471,7 +471,7 @@ static int set_forwarding(bool enable)
 
 static int __rcv_tstamp(int fd, const char *expected, size_t s, __u64 *tstamp)
 {
-	struct __kernel_timespec pkt_ts = {};
+	struct timespec pkt_ts = {};
 	char ctl[CMSG_SPACE(sizeof(pkt_ts))];
 	struct timespec now_ts;
 	struct msghdr msg = {};
@@ -495,7 +495,7 @@ static int __rcv_tstamp(int fd, const char *expected, size_t s, __u64 *tstamp)
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg && cmsg->cmsg_level == SOL_SOCKET &&
-	    cmsg->cmsg_type == SO_TIMESTAMPNS_NEW)
+	    cmsg->cmsg_type == SO_TIMESTAMPNS)
 		memcpy(&pkt_ts, CMSG_DATA(cmsg), sizeof(pkt_ts));
 
 	pkt_ns = pkt_ts.tv_sec * NSEC_PER_SEC + pkt_ts.tv_nsec;
@@ -537,9 +537,9 @@ static int wait_netstamp_needed_key(void)
 	if (!ASSERT_GE(srv_fd, 0, "start_server"))
 		goto done;
 
-	err = setsockopt(srv_fd, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
+	err = setsockopt(srv_fd, SOL_SOCKET, SO_TIMESTAMPNS,
 			 &opt, sizeof(opt));
-	if (!ASSERT_OK(err, "setsockopt(SO_TIMESTAMPNS_NEW)"))
+	if (!ASSERT_OK(err, "setsockopt(SO_TIMESTAMPNS)"))
 		goto done;
 
 	cli_fd = connect_to_fd(srv_fd, TIMEOUT_MILLIS);
@@ -621,9 +621,9 @@ static void test_inet_dtime(int family, int type, const char *addr, __u16 port)
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



