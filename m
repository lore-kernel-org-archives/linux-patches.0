Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55558308F3B;
	Sat, 25 Oct 2025 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409694; cv=none; b=C38Qn70nkAFiIdEFd1GJQ4XhpiYjG2f21f624rxpJKqZW5BOKXC2TxNbJbtXaDSzYbSUs3+gIcq9ynr/yMXBQUK1D1PDccN19JTuLlvbARi55dz5fl+zTCUu0np2guMJWFtBt9qgMGZlHSDZLumIMsXWY04gffAQ8+LTYPwSKEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409694; c=relaxed/simple;
	bh=gZxkSvZJ9V3UEqMCsEpcS4aIsFIbNceZgBs8ifVJj8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CJRB2RDxYwgStThOd0KfVsyMi6HO34+Oy+MtB3skx2YiekK5ZsJgp9fCajfyZvsBabsXD6uXdzGDfNJCm9YQ8oxaUcZyofk8q4kp931GjgW1YnnQ/fW6b9aCOTBwR9b0ol9hDLqSq4S41FVvVkTUwHgham7rt9v+ttHTwm+oFyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFVDcdTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFVDcdTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49083C4CEFB;
	Sat, 25 Oct 2025 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409694;
	bh=gZxkSvZJ9V3UEqMCsEpcS4aIsFIbNceZgBs8ifVJj8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFVDcdTrTeFuiRojcgps2IBc+rnnAPqsyXoK14X3NNRwXDBFhp66DB9rrCyeKEHaO
	 KAi7ygcpW+/Li7Oqu5ywJGKHjtwr61upRt8cgjKB5Y86/QKpeyZ0Yf9+6lCCTrnYSx
	 XeN+0OOmlNgfI65N+0iXLcf89CjxnQ+dBPIh4Jvpe5hlOtgK16tSJDib39lBJWIH0V
	 FH4XqHNugYFB69vOHuPdy6NusvkZbjjlC82ITOexY+xbpurEFd+zEtP3j2zHHq3RM4
	 YFeN3SsZ1Dc2iU5GsB57LIQkVlGH2hKWeaAvjxEVWkSzlHHmuz/9ugdwwHV2nZMq7r
	 QfnAi6yWBZVKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] selftests: net: make the dump test less sensitive to mem accounting
Date: Sat, 25 Oct 2025 12:00:53 -0400
Message-ID: <20251025160905.3857885-422-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 27bc5eaf004c437309dee1b9af24806262631d57 ]

Recent changes to make netlink socket memory accounting must
have broken the implicit assumption of the netlink-dump test
that we can fit exactly 64 dumps into the socket. Handle the
failure mode properly, and increase the dump count to 80
to make sure we still run into the error condition if
the default buffer size increases in the future.

Link: https://patch.msgid.link/20250906211351.3192412-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Rationale
- Fixes a real selftest failure mode caused by recent netlink socket
  memory accounting changes. The original test assumed exactly 64 dumps
  would fit in the socket; this is no longer reliable and leads to false
  failures.
- The change is confined to selftests and does not affect kernel
  behavior or ABI, making regression risk extremely low while restoring
  test correctness.

Key Changes
- Robust extack parsing:
  - Introduces explicit return semantics for control messages via `enum
    get_ea_ret` to distinguish done, error, and extack cases
    (`tools/testing/selftests/net/netlink-dumps.c:34`).
  - `nl_get_extack()` now treats both `NLMSG_ERROR` and `NLMSG_DONE` as
    control messages and returns either the base result or
    `FOUND_EXTACK` if TLVs are present
    (`tools/testing/selftests/net/netlink-dumps.c:42`,
    `tools/testing/selftests/net/netlink-dumps.c:55`,
    `tools/testing/selftests/net/netlink-dumps.c:57`,
    `tools/testing/selftests/net/netlink-dumps.c:64`,
    `tools/testing/selftests/net/netlink-dumps.c:84`,
    `tools/testing/selftests/net/netlink-dumps.c:87`).
- Handle realistic error sequencing during dump pressure:
  - After intentionally overfilling the socket, the test explicitly
    tolerates one `ENOBUFS` and subsequent `EBUSY` responses before the
    final DONE+extack, matching current kernel behavior under memory
    pressure (`tools/testing/selftests/net/netlink-dumps.c:141`,
    `tools/testing/selftests/net/netlink-dumps.c:156`,
    `tools/testing/selftests/net/netlink-dumps.c:161`,
    `tools/testing/selftests/net/netlink-dumps.c:168`).
- Maintain correctness checks for the intended validation error:
  - Still asserts the extack must carry `EINVAL` and a valid attribute
    offset when the invalid attribute is parsed
    (`tools/testing/selftests/net/netlink-dumps.c:164`,
    `tools/testing/selftests/net/netlink-dumps.c:165`).
- Future-proofing the buffer fill:
  - Increases the dump count from 64 to 80 to ensure the test continues
    to trigger the pressure condition if default buffer sizes grow
    (`tools/testing/selftests/net/netlink-dumps.c:133`).

Why It Fits Stable Criteria
- Important bugfix: Prevents false failures and flakiness in selftests
  caused by legitimate kernel changes to memory accounting.
- Small and contained: Touches a single selftest file with clear,
  localized changes.
- No features or architecture changes: Strictly test logic and
  robustness improvements.
- Minimal regression risk: Only affects testing; improves compatibility
  across kernels that may return `ENOBUFS` and/or `EBUSY` under dump
  pressure; still verifies the original `EINVAL` extack path when
  applicable.
- Helps keep stable trees’ selftests reliable as netlink memory
  accounting changes are commonly backported.

Conclusion
- This is a low-risk, clearly beneficial selftest robustness fix that
  addresses real test failures. It should be backported to stable trees
  to keep networking selftests passing and meaningful.

 tools/testing/selftests/net/netlink-dumps.c | 43 ++++++++++++++++-----
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/netlink-dumps.c b/tools/testing/selftests/net/netlink-dumps.c
index 07423f256f963..7618ebe528a4c 100644
--- a/tools/testing/selftests/net/netlink-dumps.c
+++ b/tools/testing/selftests/net/netlink-dumps.c
@@ -31,9 +31,18 @@ struct ext_ack {
 	const char *str;
 };
 
-/* 0: no done, 1: done found, 2: extack found, -1: error */
-static int nl_get_extack(char *buf, size_t n, struct ext_ack *ea)
+enum get_ea_ret {
+	ERROR = -1,
+	NO_CTRL = 0,
+	FOUND_DONE,
+	FOUND_ERR,
+	FOUND_EXTACK,
+};
+
+static enum get_ea_ret
+nl_get_extack(char *buf, size_t n, struct ext_ack *ea)
 {
+	enum get_ea_ret ret = NO_CTRL;
 	const struct nlmsghdr *nlh;
 	const struct nlattr *attr;
 	ssize_t rem;
@@ -41,15 +50,19 @@ static int nl_get_extack(char *buf, size_t n, struct ext_ack *ea)
 	for (rem = n; rem > 0; NLMSG_NEXT(nlh, rem)) {
 		nlh = (struct nlmsghdr *)&buf[n - rem];
 		if (!NLMSG_OK(nlh, rem))
-			return -1;
+			return ERROR;
 
-		if (nlh->nlmsg_type != NLMSG_DONE)
+		if (nlh->nlmsg_type == NLMSG_ERROR)
+			ret = FOUND_ERR;
+		else if (nlh->nlmsg_type == NLMSG_DONE)
+			ret = FOUND_DONE;
+		else
 			continue;
 
 		ea->err = -*(int *)NLMSG_DATA(nlh);
 
 		if (!(nlh->nlmsg_flags & NLM_F_ACK_TLVS))
-			return 1;
+			return ret;
 
 		ynl_attr_for_each(attr, nlh, sizeof(int)) {
 			switch (ynl_attr_type(attr)) {
@@ -68,10 +81,10 @@ static int nl_get_extack(char *buf, size_t n, struct ext_ack *ea)
 			}
 		}
 
-		return 2;
+		return FOUND_EXTACK;
 	}
 
-	return 0;
+	return ret;
 }
 
 static const struct {
@@ -99,9 +112,9 @@ static const struct {
 TEST(dump_extack)
 {
 	int netlink_sock;
+	int i, cnt, ret;
 	char buf[8192];
 	int one = 1;
-	int i, cnt;
 	ssize_t n;
 
 	netlink_sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
@@ -118,7 +131,7 @@ TEST(dump_extack)
 	ASSERT_EQ(n, 0);
 
 	/* Dump so many times we fill up the buffer */
-	cnt = 64;
+	cnt = 80;
 	for (i = 0; i < cnt; i++) {
 		n = send(netlink_sock, &dump_neigh_bad,
 			 sizeof(dump_neigh_bad), 0);
@@ -140,10 +153,20 @@ TEST(dump_extack)
 		}
 		ASSERT_GE(n, (ssize_t)sizeof(struct nlmsghdr));
 
-		EXPECT_EQ(nl_get_extack(buf, n, &ea), 2);
+		ret = nl_get_extack(buf, n, &ea);
+		/* Once we fill the buffer we'll see one ENOBUFS followed
+		 * by a number of EBUSYs. Then the last recv() will finally
+		 * trigger and complete the dump.
+		 */
+		if (ret == FOUND_ERR && (ea.err == ENOBUFS || ea.err == EBUSY))
+			continue;
+		EXPECT_EQ(ret, FOUND_EXTACK);
+		EXPECT_EQ(ea.err, EINVAL);
 		EXPECT_EQ(ea.attr_offs,
 			  sizeof(struct nlmsghdr) + sizeof(struct ndmsg));
 	}
+	/* Make sure last message was a full DONE+extack */
+	EXPECT_EQ(ret, FOUND_EXTACK);
 }
 
 static const struct {
-- 
2.51.0

