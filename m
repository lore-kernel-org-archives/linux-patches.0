Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0061C280327;
	Thu, 15 Jan 2026 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497513; cv=none; b=tTxb9oXBdPnCCfooF7LrXkR+brNiiNu/vEgt4lsFRo7H1hr8TsBCUIq4EP19/F23hxot5UI3PO9jQi83j1dDk09Dkci4LvUOH1tjY/CjqqRoKdX61Cziq2SXfR5GSI7HfaSIrqI4kKxfopeuZUkG76CVWt7rTYf9NMZIXm1Og1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497513; c=relaxed/simple;
	bh=qzJ4zbAB62qhRQwhFuXH4ZzzT8vSGS/7nxgLCiySKWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Emcr2R53E790XUEyXvAI4k+PN7OF+qGeP7l4dX2Paoo+eVaup+YIViXUwHdkIdisH+1DpcOzm8h0nJ+9tSirl4fwwew/6lWblPV+pjTCk0uNtMkkF1ZtjMFejXM5Ujkwe1EU1Hp58UUUwTGs94h5bSfWIENjTO2W1Y0xIUnsxQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmcFyW36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmcFyW36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA85C116D0;
	Thu, 15 Jan 2026 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497512;
	bh=qzJ4zbAB62qhRQwhFuXH4ZzzT8vSGS/7nxgLCiySKWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmcFyW36nJl9RqgOYfz0+Ckt1nJQUvJ1A7PzgqlCEEIwSHp0AhFqpIdPXSCX295IX
	 KCB9VaZOMZu4u/2WFwSTI1sMtKIQGPw8qjcwm4CCVbD+gh1VaDSPpxJzfkmPi6M3as
	 IRdMh66cAMnxdV1NGiXHnZDRPAjE17wu0+vQOUnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/554] selftests/bpf: Fix failure paths in send_signal test
Date: Thu, 15 Jan 2026 17:42:54 +0100
Message-ID: <20260115164250.163367232@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7b1343f70e65a..ab5fedc5741e8 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -138,6 +138,11 @@ static void test_send_signal_common(struct perf_event_attr *attr,
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



