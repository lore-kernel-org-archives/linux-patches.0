Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30BF43991C;
	Mon, 17 Aug 2026 13:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974452; cv=none; b=DSjTEqCnZov4/99yROmuwDtilK4l5LcEqblf+oMYg4WJtKbIxrHYYORbZlfdInpx+DlxD5lJd+QNWkQkoLnfuHRmmQcjpqtnteUZ37bKOOWPl9CFCR1fyY0VjaKe4WcHIkdii7O/+7XEUDTrwqse6AkO0t8UTShQQaCC6ZTQo3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974452; c=relaxed/simple;
	bh=Sw3Euk467/dh/er4iQdxVNa2FCAAs8xajsyKxH+kHkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSx+AJhdxt+zWPeQJd4g1bjOEB1yAvst7nwXhtOc7X6B9QAyHVe4Imh/n2XbLlxDFwYqXdPMd6i7vjeJdUSuOUii+zjsoxuiNWkZNF4ZXSsDooN5jk42oh5r0enQ98+1Fk1jNkmmAywukUlolCVmCFW+cUhW0HmBy0QC6FUz7zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY0zMtNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY0zMtNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D1E1F000E9;
	Mon, 17 Aug 2026 13:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974448;
	bh=i+jfcJ5/7wLArcTKn+pXHrgdrqKvqkw1rso46KAfvLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zY0zMtNPBQjYY49oU7AuXI2CuvlW7LNHaNyEqsvcJx6VzWFIdGoyiH9d+AnwlFg8F
	 pGuWUCTv23C+fqfECNPDb6w6KOFoR9TKNqrrEpqJB3Mw4gXUjBtAjT4JGHE2t2569g
	 HxTpm+DcROM6r3oWcIrSXdbxyGEQ/JN/qPcbDNUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re=20 ?=" <ricardo@marliere.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 170/271] selftests/bpf: Adapt sockmap update error handling
Date: Mon, 17 Aug 2026 15:31:35 +0200
Message-ID: <20260817132543.861770365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 30581eda4a07ff15db623612cac578e81869e96f ]

Update sockmap_listen to accommodate the recent change in sockmap that
rejects unbound UDP sockets.

TCP: Reject unbound and bound (unless established or listening).
UDP: Accept only bound sockets.

While at it, migrate to ASSERT_* and enforce reverse xmas tree.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20260707-sockmap-lookup-udp-leak-v4-3-f878346f27ab@rbox.co
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index cc0c68bab9079..1c96a3cf4b979 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -53,8 +53,8 @@ static void test_insert_opened(struct test_sockmap_listen *skel __always_unused,
 			       int family, int sotype, int mapfd)
 {
 	u32 key = 0;
-	u64 value;
 	int err, s;
+	u64 value;
 
 	s = xsocket(family, sotype, 0);
 	if (s == -1)
@@ -63,11 +63,8 @@ static void test_insert_opened(struct test_sockmap_listen *skel __always_unused,
 	errno = 0;
 	value = s;
 	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
-	if (sotype == SOCK_STREAM) {
-		if (!err || errno != EOPNOTSUPP)
-			FAIL_ERRNO("map_update: expected EOPNOTSUPP");
-	} else if (err)
-		FAIL_ERRNO("map_update: expected success");
+	ASSERT_ERR(err, "map_update");
+	ASSERT_EQ(errno, EOPNOTSUPP, "errno");
 	xclose(s);
 }
 
@@ -77,8 +74,8 @@ static void test_insert_bound(struct test_sockmap_listen *skel __always_unused,
 	struct sockaddr_storage addr;
 	socklen_t len = 0;
 	u32 key = 0;
-	u64 value;
 	int err, s;
+	u64 value;
 
 	init_addr_loopback(family, &addr, &len);
 
@@ -93,8 +90,12 @@ static void test_insert_bound(struct test_sockmap_listen *skel __always_unused,
 	errno = 0;
 	value = s;
 	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
-	if (!err || errno != EOPNOTSUPP)
-		FAIL_ERRNO("map_update: expected EOPNOTSUPP");
+	if (sotype == SOCK_STREAM) {
+		ASSERT_ERR(err, "map_update");
+		ASSERT_EQ(errno, EOPNOTSUPP, "errno");
+	} else {
+		ASSERT_OK(err, "map_update");
+	}
 close:
 	xclose(s);
 }
@@ -1289,7 +1290,7 @@ static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
 		/* insert */
 		TEST(test_insert_invalid),
 		TEST(test_insert_opened),
-		TEST(test_insert_bound, SOCK_STREAM),
+		TEST(test_insert_bound),
 		TEST(test_insert),
 		/* delete */
 		TEST(test_delete_after_insert),
-- 
2.53.0



