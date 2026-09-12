Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B68B47B408;
	Sat, 12 Sep 2026 12:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216191; cv=none; b=URvFXzTQ8OzRwN399jdd9fSy4zKonTxixn9YDKanoCpwmIROUtSxxnjCAZah1laBAcfP984qXl4l0BJTkW3ZDTrHbCwr3reYBYkBt/ugXfQ6VEGyvShbHnhTqrFNIM4hyBOWLhEBL7MW7ocOo30KVE/uvbkBg4F+vh2RkAwsses=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216191; c=relaxed/simple;
	bh=+EqgCHEzzzzY+UZVA+SoOK2HBwhkv3yKA6FGEKCOUUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVNJ+xJsU15qWqjf08SQYwbp+hIg2XosnVfF7BzNAVYEHzEMa0rqQiLqIoO09/dYmo1XJoizLGPZmFcfo/2Pdh3PvmYRyt27EGJCOL2nSn1DT2n5S+0ULiW016BThsuEcopuSpxyk7o3arZ7pIyuykapEIbp5wH0eXW6QNGxsZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLCryLMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLCryLMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C66E1F000FF;
	Sat, 12 Sep 2026 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216189;
	bh=+qH40GCK1gH6Yv58No7Hu/9JxeQ+JQ/Td0ITfLgX6oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLCryLMqscxg2Y3RNv0mVMrvItzudhRNwuHqusF7AymDSfdb5NNHSjKDfhB2Iv9TG
	 trv0WKyyrAi+yQ82HxI5aBGDB6RI6ExOdg7QtFXpk+Qe1nqSAPmsfO/nig7bikahO/
	 3KJDGs86LuNZm/3vNaTd9kyGV/NdFguYof8TauQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0685/1376] selftests/bpf: Fix memory leak on subtest_states reallocation
Date: Sat, 12 Sep 2026 08:51:51 +0200
Message-ID: <20260912065622.813093691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a48a3b1f687e6..3a89cf01db90e 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -468,18 +468,19 @@ bool test__start_subtest(const char *subtest_name)
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



