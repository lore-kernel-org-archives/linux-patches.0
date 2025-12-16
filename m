Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841C135502C;
	Tue, 16 Dec 2025 11:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885878; cv=none; b=kCkr7l9FP6Ynu4SZKc/Mzo76OwWxsmzoYuMtB6feAHRULRT5pywBALrgNGd2GsFCb/vxpBFYIqKK/nhbBg4l37+qWtWO47QdeGmddpcs2Ag9FXVG/OazmNRTVIIt7pS1YmZnFmYOZKmDDeKH3BtcnKaznH4hWgW2vv4m9JiC6Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885878; c=relaxed/simple;
	bh=ta/DndnBeio5Sd8+lqdm77G8+nxP+I37lMMiiTfeY4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4oHFJQG4y+7GQKBQnYRcgRYNTQ7o0ufjXl8Hvy1ognIVPD/Ebsq29uAOfQgGMhuI5hety9H0eK3G2RDHljB3hXuEbeC+cv39wKkkGc2rXEqVnuvnlSeCBZVVIl+S0sF1u3U0/CE/oV3KR4SW6VncV17xIMY18PAiaCAzk6y81k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9LAtCw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9LAtCw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B20C4CEF1;
	Tue, 16 Dec 2025 11:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885878;
	bh=ta/DndnBeio5Sd8+lqdm77G8+nxP+I37lMMiiTfeY4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9LAtCw35gQjYjmjuqA7KYvZ7TcD9qOtBELRAb07UAqR6LNo84ayKm7QNJQ34tXE6
	 LP3o3IKL0Rf3nzQfUJ1OaknERRo598Ua79l2+IxlSnokMDk7OOLfkPGDVCQW8XNUzV
	 vBedwhh1aHaJrkVUE/18O5Vlm8JP6uNuI+ntxb/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 244/507] selftests/bpf: Fix failure paths in send_signal test
Date: Tue, 16 Dec 2025 12:11:25 +0100
Message-ID: <20251216111354.337298954@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1702aa592c2c2..7ac4d5a488aa5 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -206,6 +206,11 @@ static void test_send_signal_common(struct perf_event_attr *attr,
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



