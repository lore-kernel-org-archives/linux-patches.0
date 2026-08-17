Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F1821CC5C;
	Mon, 17 Aug 2026 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978623; cv=none; b=kJT+w4UlYUvlhQEnz2JVZBWYfAMYMcKOThV3iOXJyizqrW8pJKrJUQfOj9dGJl9M/95MDegIjVgnrNyyW5h3+0Om3a283p1p0gb4r49/xxeF726hJS5jAXWeX/ApTXcR0xMMci4VOVsieZsUKFuW1yHdYNe1zaur5xkWCGE1Tno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978623; c=relaxed/simple;
	bh=2DCJ8vt3PCgQdmNrSpn83Lr5LNhAlUFpifqgx3kZKSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWcopsdM4vz/bP4m5oM69N/fpVbfDXE/eLtW7cwnRFtkGyEMURltFraCMp0P6cf76i1kVglEQj4On87IykiFFeCFxl/k2V+eAeBZBQNKqD81yfZPicHggyD5M08n1JMEa+ZMhvCquEeX4QeUcC2jNzpHgPlBYzF+C5uhVm2kgNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFDdIc/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFDdIc/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7152A1F000E9;
	Mon, 17 Aug 2026 14:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978622;
	bh=PceAwUOFqA26WCJd6u+CNFvh7ADWEhHaBwcoyDUvYrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFDdIc/GDXQXXWe+Lxu0QbBpFC1S3N8N0dbEpz/Uuq05NgaH/RBpS6VFPYARGQJcx
	 PcwyUpeUwH+386zKFhtqH9mEpD++zCYmr4D25jYQA5C8LqyKeRf5BwKTLcESQw9wCV
	 SMgRBp7AmSOpeBZ5rhunM82KkXMqOjaSQlElQRS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/156] selftests/bpf: Adapt sockmap update error handling
Date: Mon, 17 Aug 2026 15:33:54 +0200
Message-ID: <20260817132538.535664116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index a6d8aa8c2a9ac..6386d6069b9db 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -51,8 +51,8 @@ static void test_insert_opened(struct test_sockmap_listen *skel __always_unused,
 			       int family, int sotype, int mapfd)
 {
 	u32 key = 0;
-	u64 value;
 	int err, s;
+	u64 value;
 
 	s = xsocket(family, sotype, 0);
 	if (s == -1)
@@ -61,11 +61,8 @@ static void test_insert_opened(struct test_sockmap_listen *skel __always_unused,
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
 
@@ -75,8 +72,8 @@ static void test_insert_bound(struct test_sockmap_listen *skel __always_unused,
 	struct sockaddr_storage addr;
 	socklen_t len;
 	u32 key = 0;
-	u64 value;
 	int err, s;
+	u64 value;
 
 	init_addr_loopback(family, &addr, &len);
 
@@ -91,8 +88,12 @@ static void test_insert_bound(struct test_sockmap_listen *skel __always_unused,
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
@@ -1261,7 +1262,7 @@ static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
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



