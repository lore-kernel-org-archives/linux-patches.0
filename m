Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A733F1DE4EF;
	Sat, 12 Sep 2026 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223860; cv=none; b=pJAqu3iF2isuMXdPRRcXGDAMKJtPIz1cEDzXw/oB65h80a++2W67LwYhM0ocdIYKVjZ6H1pkoywCXOzLsqy2maN/H6nsXEJ1y2Gald6skWNVsbvjUYqnGRzwA7kgug1xsXAe+gLbqmDHeFpbAHDvptt/c6Y5BviQCkf6jvJnKXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223860; c=relaxed/simple;
	bh=cJ/a3+fEygMZj+9mEBVNdoQ36qkPXOQjOa/n/0PRvaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V65tQ4Ci6TvZ8jwX6UoYP9MjUrYdtQ2fxyv6kY5pIr2Kn/RycToMjovvJLWSyyvHOzCSATz67DfiRDrdNCCoXTFYM3SrauKSxeIHsJoR+mnByX2IjYiBWD7dSShLMFHroF/dPur0WhOntqWkqBBPaMNeUrLqAYtO5I4cv97iRCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fg96kqd3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fg96kqd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD2E1F000FF;
	Sat, 12 Sep 2026 14:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223859;
	bh=rJTORKYh0qZpfbnL9y5RswBoXDwqagI5fIn/OH1DwIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fg96kqd311xXyvZUQVA225fwHvtLsAVNJXbv8Corx9ecrrrTXYu/KX8ZE5GYTQPpt
	 sny/REsR1j3cLmeK3fSQeiIQr4tK+QtAlDjvdFgs92pkTc3zlBkDO3kYlCrmw4Bhs3
	 8Edbgvz4Z45Wd8aThoPSsJXW7+maK/v2McnhIvcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0876/1424] selftests/bpf: Fix memory leak on subtest_states reallocation
Date: Sat, 12 Sep 2026 08:55:08 +0200
Message-ID: <20260912065626.940574571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 29a005cad80f7..e142d0494b06a 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -447,18 +447,19 @@ bool test__start_subtest(const char *subtest_name)
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



