Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF4A37702D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301660; cv=none; b=dvHGUgq8OjQW1Pw0f3rq8a4R5U1npxElq7lsHBsCy3/tYFVBXaHarutnxf+dukHgoU+A6jZHQ0G3tzi/7UKXGjdqw5UAFimnaZ1Ktwl748UjTe48tmKoDxiEFyd4qqlZMuiUehogwkRt4xS7FbgiFgSVKtr4rsUMHphIsB3ycGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301660; c=relaxed/simple;
	bh=zLrOqwF2igl7icuzvy+7unU3FTitpzX5ep1qU5+ZkbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tffBnyoQ5aQtytepeqEgXok86Q/86tLrgHfFY92DBy9Ant9CixzH6Cr51tmCKbfq7xlb2fqAhnBhhiUB+yFGTN8+N3YINoZZFmIcS6A4B3yWDJWkOq1luWOLhrdcPJQR4uIqN70yaP/G9GlD9akfa8KuQYYZioFv1CzNXthKPIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhTlsaIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhTlsaIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986B4C19423;
	Sat, 28 Feb 2026 18:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301660;
	bh=zLrOqwF2igl7icuzvy+7unU3FTitpzX5ep1qU5+ZkbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhTlsaIU+CjwD1Lh5PDLRe614lHUoO52mL2NfaNnQaaiFSlInd2Nm5tFlK8TSO9p/
	 Li0/IaXjFW3MfTWlSe1baD1/njvfnncRlADjCcqX4dc/xcePrCNtqVPSasJuWcEWS6
	 5dS6IYEJ6iXUd1CmzQkfD9KLojEPt8HOqIGajkEwayX/K3hj3b2iJi6jSmExO6rKfi
	 xcE60gEXFF/Ot1RpuG24uJGVGznhuOvByIpC9TW6a+CbaneS2nkvnABNqr/Xq1QOW5
	 KMXYuZTuLq5YDWU39M02j7STfxoY4z5HjMUh8iRp3kT+X2nFuspZh+bWG2a42L6GR3
	 E2qAhxyTE40Fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kery Qi <qikeyu2017@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/385] selftests/bpf: Fix resource leak in serial_test_wq on attach failure
Date: Sat, 28 Feb 2026 12:54:40 -0500
Message-ID: <20260228180011.1568201-58-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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

