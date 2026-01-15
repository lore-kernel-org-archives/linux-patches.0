Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C12C3268;
	Thu, 15 Jan 2026 17:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499016; cv=none; b=M16riZHfVWfXkTIuMfdCB0j282RCWQ2104yszju6UKA9vYCAIScG0xY8B4lY6hHcbC97aB/SVOgCmea33DjBmeklO1AvtLUySdeT3nA0RwGHhv7ruMVyp9uwa8FO7YkHoCriH7xLAd5JGO0juMqziKOXFD2IM95KNI9vF6GXEfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499016; c=relaxed/simple;
	bh=CH/VsXFjJTBDmf34p164DqsMQvK8YVIIWSe+lsJv99o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIihlQ1HNHEhqGVZqeN55Rio+rGlCk3Qi5OaGZ9plWGefdWosLKoBCTrLEKN1/8J77UUe9VAPtVreAwRwV9XyeBZIFN1d6YIxcYSi4rDidF5pmmhRKADLL8ZnuriczDgfOodvYhO+rwwi815PEc5ZhmM+Eesn4v5URPLAqT9kbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bwdt2LuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bwdt2LuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA6EC116D0;
	Thu, 15 Jan 2026 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499015;
	bh=CH/VsXFjJTBDmf34p164DqsMQvK8YVIIWSe+lsJv99o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bwdt2LuIVfU7EGCGqh+0KsQn4kR63M6P3oKbUhlfkWl0SS3aDNzjwaUaigeXbFDDG
	 Vv7jaeYD2hA1ne2QJYDG48dXfxzF8HxBCpmGaji5yA+2mfZ/L+Anbn48OzMFnPjP01
	 pTbwieJmXAatwY6EIHIx341DuNlHjJo864SqV2+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/451] selftests/bpf: Fix failure paths in send_signal test
Date: Thu, 15 Jan 2026 17:44:39 +0100
Message-ID: <20260115164233.736261316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit c13339039891dbdfa6c1972f0483bd07f610b776 ]

When test_send_signal_kern__open_and_load() fails parent closes the
pipe which cases ASSERT_EQ(read(pipe_p2c...)) to fail, but child
continues and enters infinite loop, while parent is stuck in wait(NULL).
Other error paths have similar issue, so kill the child before waiting on it.

The bug was discovered while compiling all of selftests with -O1 instead of -O2
which caused progs/test_send_signal_kern.c to fail to load.

Fixes: ab8b7f0cb358 ("tools/bpf: Add self tests for bpf_send_signal_thread()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20251113171153.2583-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/send_signal.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 0b6349070824b..b6e09b383fdb8 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -144,6 +144,11 @@ static void test_send_signal_common(struct perf_event_attr *attr,
 skel_open_load_failure:
 	close(pipe_c2p[0]);
 	close(pipe_p2c[1]);
+	/*
+	 * Child is either about to exit cleanly or stuck in case of errors.
+	 * Nudge it to exit.
+	 */
+	kill(pid, SIGKILL);
 	wait(NULL);
 }
 
-- 
2.51.0



