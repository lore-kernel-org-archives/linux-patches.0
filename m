Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82495256C84;
	Wed, 25 Feb 2026 01:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983862; cv=none; b=JfY6XqSukEfjBv4LShkBrU5vk4e0QbzQYdAzvPRLA8+dqGQDDTbiYlpIht41opL9cpU8hYQvmwHAR99bMKAID4n181T0bei2maTlXBtND0KswwBmhOn0b1R+fnwqo9ssAV6pHyC/uMjxizSG2CuBJCdt4O9CMg7L7BlRIDO9Rnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983862; c=relaxed/simple;
	bh=uciAaTooVvz1ayY2XmTUz6W+4HWFr7aPP1frGlWkAho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYy+iOySLBEVL7P+hSbB11XRMyzGeAGS4uo0Th1tRrIu1y5WUOCESZea6vPDIa5FBosUbT7VFX7U3E9wfsQgSiddhDOY6IOMHShclF485y4W3NRmQBI7YR+w5QV6Hm1DuN+nSO/2iK7rj30QCFOqAO5MfRQYmcoBk/zQPA/c9xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mXmdRk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mXmdRk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CEEC116D0;
	Wed, 25 Feb 2026 01:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983862;
	bh=uciAaTooVvz1ayY2XmTUz6W+4HWFr7aPP1frGlWkAho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mXmdRk12tJ+D5EdqZg1B+/e9k3MJBxoJfNIz8kHSxnVQuwhpHmdfJs8JlXDv585K
	 XvlnOJpjp6LfQpQXdrBRRWtvBoeBJ4YdTAWZn2MW4bxyGBE3uTxzpPrOcevWj8rHeb
	 5sMhZBHHNnGPxLQxOEEW4xGIdDH3mxp8B9DBZaCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/641] selftests/bpf: Fix resource leak in serial_test_wq on attach failure
Date: Tue, 24 Feb 2026 17:16:52 -0800
Message-ID: <20260225012351.179412522@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit a32ae2658471dd87a2f7a438388ed7d9a5767212 ]

When wq__attach() fails, serial_test_wq() returns early without calling
wq__destroy(), leaking the skeleton resources allocated by
wq__open_and_load(). This causes ASAN leak reports in selftests runs.

Fix this by jumping to a common clean_up label that calls wq__destroy()
on all exit paths after successful open_and_load.

Note that the early return after wq__open_and_load() failure is correct
and doesn't need fixing, since that function returns NULL on failure
(after internally cleaning up any partial allocations).

Fixes: 8290dba51910 ("selftests/bpf: wq: add bpf_wq_start() checks")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20260121094114.1801-3-qikeyu2017@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/wq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/wq.c b/tools/testing/selftests/bpf/prog_tests/wq.c
index 99e438fe12acd..15ac8e6d17450 100644
--- a/tools/testing/selftests/bpf/prog_tests/wq.c
+++ b/tools/testing/selftests/bpf/prog_tests/wq.c
@@ -16,12 +16,12 @@ void serial_test_wq(void)
 	/* re-run the success test to check if the timer was actually executed */
 
 	wq_skel = wq__open_and_load();
-	if (!ASSERT_OK_PTR(wq_skel, "wq_skel_load"))
+	if (!ASSERT_OK_PTR(wq_skel, "wq__open_and_load"))
 		return;
 
 	err = wq__attach(wq_skel);
 	if (!ASSERT_OK(err, "wq_attach"))
-		return;
+		goto clean_up;
 
 	prog_fd = bpf_program__fd(wq_skel->progs.test_syscall_array_sleepable);
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
@@ -31,6 +31,7 @@ void serial_test_wq(void)
 	usleep(50); /* 10 usecs should be enough, but give it extra */
 
 	ASSERT_EQ(wq_skel->bss->ok_sleepable, (1 << 1), "ok_sleepable");
+clean_up:
 	wq__destroy(wq_skel);
 }
 
-- 
2.51.0



