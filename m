Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750B7341ACA;
	Tue, 16 Dec 2025 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884350; cv=none; b=KTDiZrt5nfCuWSMnbof9Vj5s5L9zkVz34SuSe4Qp5Su20wXv+u3wJPIOuOLHks921E18OBvkBTdpW+3wCxtnw0I2zRjdK63JxbUFoE2FF6jjl5b7nRaFRZ0LSqqXujtUvnvqZUaXUl2mBBMi5h3q2tCxbT2cxsxVey4ufMNrQNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884350; c=relaxed/simple;
	bh=IoXaNsDadhYmlcAUEHeVlOjsOEgv3WFoixpU03kHL3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxpsQ6q1p8Psrps9EZ9Cz2HsPTxApp+yVHuX8oAR5FEt5u3eMUFSI6DlVL484RmauTew2gfd9QHs7tic401zjDaEbybb0RNpfLIi2eJoaxpAVIED7W0jIWdo7s+kl+91PgNrCnhin02+54D+pcyOCIWNbhszC+iB8JuTVFf46XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2qcxWWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2qcxWWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903F9C4CEF1;
	Tue, 16 Dec 2025 11:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884350;
	bh=IoXaNsDadhYmlcAUEHeVlOjsOEgv3WFoixpU03kHL3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2qcxWWP1Bf+w5lfDcLaFs+PpbGsb13Zu8ljfbbezbR0kVxbAJYGaarBK1VMuzGBb
	 3YU5q6o/cEDhSHHXmhq/tekuXLr+HDNXwh+O+p9JS85F3t9C9YUWzznfY9sA5euFef
	 5LrHQxX4GMWtHkZiCbhH9m5wYOP9uSVkLuKKcdx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/354] selftests/bpf: Fix failure paths in send_signal test
Date: Tue, 16 Dec 2025 12:12:12 +0100
Message-ID: <20251216111326.891911858@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 6cc69900b3106..752b75b7170df 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -145,6 +145,11 @@ static void test_send_signal_common(struct perf_event_attr *attr,
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



