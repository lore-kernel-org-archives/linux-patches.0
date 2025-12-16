Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEC034847B;
	Tue, 16 Dec 2025 12:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887638; cv=none; b=ePMrCGhBnFohn07QG/4ycSifNu0/WzWp0/D2plz43guu5FIIbc7zB0OO7Wa76IRE4owD4tBVh6I0sEVT1R1zZZfAgkWCoBzix0DiLnmRLPrimUl+jPaC8+s53yFJL0hDLRMxlhwliFxIlOAwGfj+FjzHJarXDnRh80q+R/9Dl6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887638; c=relaxed/simple;
	bh=46kzOCd74n4XWJYdNMcGm2F00ebjC49UA1S0zEG0DAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM+8K2qaNTkRRdSsy0qTBDQXPDy+zcSnPm0sqHGcCkmjehU3nFx2bbZSTTZD2qydYQfcm5RzqY58xEhKzTZNRyVPClJP2mCTplt1cc+jx/PbnfFy1L+WmgML3H77Nr2DzfxkQJguT16sulwaZEJlAZlCxwskBAw0g0kzqOcnON4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w010EPeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w010EPeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DA6C4CEF1;
	Tue, 16 Dec 2025 12:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887638;
	bh=46kzOCd74n4XWJYdNMcGm2F00ebjC49UA1S0zEG0DAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w010EPeAlDQHyuR+rQPbXU/bu4TqFDoVKRETKgpmGJZlsRfgOs6SFfE9s76RUa7+y
	 BEgJY3UI41VS5O+akr+fBhrCJpeRC2535/9SkDKEZdwcGeORHS7yryu79RKywCtTAq
	 razqpdZPB5xayofhkOD9IK9N/h4uiPvvNnqnW55M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 293/614] selftests/bpf: Fix failure paths in send_signal test
Date: Tue, 16 Dec 2025 12:11:00 +0100
Message-ID: <20251216111411.987394119@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



