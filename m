Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E890C26E158;
	Tue, 11 Nov 2025 01:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824349; cv=none; b=HXK24yJ1UtzSd6cD0eNe/LD6ngi4Zd+LgNBLFedPRxJ06UWKNTdugnpS5fyjMnwwOaZBye+1Lxh+iM2JjPUqsnQl7ani8VVTNhpG8paf3reZN+K2hfLLeu9aD0IYXM9RkBUOHhWWBh9/jNAmp8rHsn5zwdP1ebufMUu7bX4BvaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824349; c=relaxed/simple;
	bh=M3xNntnYqHTPMjLyYSjym8YpWq4SE6NCavUArnwhQM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STCb3OpX+EEx4FlRsShMYDlOjVfvSuofHfA2Th4wuU8rcKF50//1OS23dnlOthZ7EXtI04HNZRiHzHOKOi10ABJtuwrK/76nRxEf3LZYP2J7WssrYL2DBJxrBHR1d6pyx0LE3dnSAT5KX2VEQ9Dy9uT2YvvagfFQF51vVIjAdyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcVQ2Ekj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcVQ2Ekj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B11FC19422;
	Tue, 11 Nov 2025 01:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824348;
	bh=M3xNntnYqHTPMjLyYSjym8YpWq4SE6NCavUArnwhQM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcVQ2EkjxqdBeKh4lKwY+8Dkh0urPlRFHZ7OaY97rylTOYIliTzQBgXh+UuiaU9s4
	 YF8LgzWXVwm0VVLpkCyafHSPFhYcHxkBLFdWiXgYFVSfWBNLqutJH87B9u+cgeH+jQ
	 MLU6mGV7G/DEjmHuG/q9LZDrvdEORaPKbfUhth1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 478/849] selftests: net: make the dump test less sensitive to mem accounting
Date: Tue, 11 Nov 2025 09:40:48 +0900
Message-ID: <20251111004548.000663918@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



