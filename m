Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E54725393E;
	Sat, 12 Sep 2026 07:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199756; cv=none; b=JVbi/Or5MFjo/QBu0spK3rujNk/Ah3y9Eh19BL5ptgFo4Sohgpt2F5ch86g0GgFFIjf0vELpOkeWfneysCpxqNwTfKYfxrHYKNZO8kCT+YB4YwPXErXv78HoI9+PASkDMkWuO8R/GCc7fefhJSiIsr46aAPXMASXuBX2AcVpKDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199756; c=relaxed/simple;
	bh=7ItQSTOlJe/YXXWfyH2jy0imAYuzZHNpyYXZY6v9wZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7r1gOf8V5lnrwoxwVUkfc7Blkylf4KGiHXcCVHYjPx3xy6Q7A923BdNA8GOEXpcGXIZfgD1uyYmQ6DVPYOCv6fbPJSPT2Pz8tAx+52KPHwMjOoNkVZKKOf5+tzkZvxpDquVTXxSLqkmFnxvKI+QvywYGjO7cLnG2pxaG+Pl9B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ket4tGaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ket4tGaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E8A1F000FF;
	Sat, 12 Sep 2026 07:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199755;
	bh=y+SKBFA3zdXgYxWU9hKpePjm74Bm5Uetpg5D6XC1FKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ket4tGaNWJv4jWZQhL18QDgFWVjPPla84+PzjZa2PV+rDZvTc4q70SR9jzlVaF+Fw
	 Du9ldLjdYiU73eNvRIXld9qz7KQW+Ikh9i0SBIRM0s7AnGJNzf0rhnXYnNizeY4604
	 35TE3vIOVRxtV2gTet+JlvT/04cvhcM1pQaFmiCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0651/1815] selftests/bpf: Fix memory leak on subtest_states reallocation
Date: Sat, 12 Sep 2026 08:40:01 +0200
Message-ID: <20260912065704.162590029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ded892f8777b7..8ffababe0084b 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -573,18 +573,19 @@ bool test__start_subtest_with_desc(const char *subtest_name, const char *subtest
 	struct subtest_state *subtest_state;
 	const char *subtest_display_name;
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



