Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA01530C60F;
	Sat, 12 Sep 2026 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230049; cv=none; b=okDm/2m5fhYmRhJJTEMGyAC5oYV2xVdNSvK37vP5bIshFgvNiKJt7wWVksAca6uPefl+h8xe/AXalpCceCxWNX8QFgRsgRJat2syfWiD6P0UHl8gaOrgcUVvUpHECeYpDv/scbqD1qjgUx0xzxliX6OnwCLelUQ6B5LAAzbZ0Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230049; c=relaxed/simple;
	bh=NIUHxjfyLQd0rrsFr5KfX5SmF6oJLfXbnEmAeLgNMSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYxQa6QjWmVSkguu6XQ01is6PoL6lfVvheFvB3XRtOj5yRYgw2qzn6wUuvrWg2L0IW9X/78TVHj0zZnkaiOEA/3sA+oJkRIW2uBoocg4AnCxtkbvbEGiKjKRKo4VJffCSGqxCs3ohcA6MDxOy5U23Zwn9Ba2XF4Q5EACZfqbyK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lx+ANxtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lx+ANxtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43BB1F000FF;
	Sat, 12 Sep 2026 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230047;
	bh=jhtIpCK1yBG5z/Kmn1O6nMKT5gjN+CkGH2p18X3IDNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lx+ANxtZKHEoItBlFOkPWS88M2Xu7OuYe0TRa0wwbaGGP+FaOpCNvkpVBN5uTl07Z
	 JZ5PbiPLs77i/P2/YcVBrAVh9oWtHezPxpFS83LFeveCg0HMiyHx/mcaykJEnEiCUP
	 gx/wcqbrqS82LU64RqcUaWkaWpU4nl9sbSTy5xKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0714/1191] selftests/bpf: Fix memory leak on subtest_states reallocation
Date: Sat, 12 Sep 2026 08:57:22 +0200
Message-ID: <20260912065604.315520610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit 06efb01c6530e9cfc247178cb96aa8adb3beaf61 ]

Fix memory leak in subtest_states reallocation,
and revert subtest_num if allocation fails.

Fixes: 0925225956bb ("bpf/selftests: Add granular subtest output for prog_test")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Link: https://lore.kernel.org/bpf/20260723085100.482147-6-yangfeng59949@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 9f827139655a6..91613da36791e 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -404,18 +404,19 @@ bool test__start_subtest(const char *subtest_name)
 	struct test_state *state = env.test_state;
 	struct subtest_state *subtest_state;
 	size_t sub_state_size = sizeof(*subtest_state);
+	void *tmp;
 
 	if (env.subtest_state)
 		test__end_subtest();
 
 	state->subtest_num++;
-	state->subtest_states =
-		realloc(state->subtest_states,
-			state->subtest_num * sub_state_size);
-	if (!state->subtest_states) {
+	tmp = realloc(state->subtest_states, state->subtest_num * sub_state_size);
+	if (!tmp) {
+		state->subtest_num--;
 		fprintf(stderr, "Not enough memory to allocate subtest result\n");
 		return false;
 	}
+	state->subtest_states = tmp;
 
 	subtest_state = &state->subtest_states[state->subtest_num - 1];
 
-- 
2.53.0



