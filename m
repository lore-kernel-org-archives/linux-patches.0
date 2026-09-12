Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6472342A178;
	Sat, 12 Sep 2026 10:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208232; cv=none; b=eZXS7BB92Y9Y+U8K+EW4Tn8J4UEMmGvJ+Lvs6C58djQ5dokl2FspJHO3kWtWQxd/MapBtOQ6U+Qvss3BfwhWWTlx7ungExHmifEtV4Lqyl+niXAs5oyvXgvs/EkozSlE2AhEfPzuaFrQbcveYUFmoUknyb8F5WInvXH1o0YcUjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208232; c=relaxed/simple;
	bh=s7sXl043sX0jqoMK31fIh0FkOAwVWBq7x1vQ3je5yWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz5L+lXmXJ+bYY7sp4a6sALnq0+oHORgpLPVw/6n2U9SsTm9LncF2Cp9FTkNt7A+mImPJONmT90BgusUFPdhfc8o68vLjXeEhh82MJdiZIzwafjpWFL6wh5bFVqyVnqtWBWuMrauyMp/FN6JvuD0dfVXBs1Q0yPZvT1P/AAC9Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yj1FbF9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yj1FbF9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7C81F000FF;
	Sat, 12 Sep 2026 10:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208221;
	bh=nqoeBlzk64jRM+E8T4c5ErFwvI1W+KsK8ztyIkHDLZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yj1FbF9HST4HkTvXSBZ36Y1j9JG8ZN00s9WdpCH7aB0UVAVYThfAbXnX5bTmQ5mjr
	 FEcBo72iCzuU+6qnUG+iXuY6FcDCo82bEqgEoinqJH7gkaBg3FAmLfLOG6+W3X8j5e
	 I1DyBxgQkm3hJEjMRxs9DxJ2U44AcS7NN/whlZ+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0574/1518] selftests/bpf: Fix memory leak on subtest_states reallocation
Date: Sat, 12 Sep 2026 08:45:43 +0200
Message-ID: <20260912065636.414585551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 082f05f341e58..eda3fcf72095f 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -550,18 +550,19 @@ bool test__start_subtest(const char *subtest_name)
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



