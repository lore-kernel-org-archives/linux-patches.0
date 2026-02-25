Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08644248886;
	Wed, 25 Feb 2026 01:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983817; cv=none; b=VCeSG+IM1gFFFzg9glIb+Gr9YO8pTPkGZkWvmwLgxYsvz0jbRd8DDzdT5Y5WS+Yb8A7icT5rIbxJq0ewnINUF0lqlaBJxaqGV4dryAv+AWknmsa4DYDVxqEnSmjCKYUjPobBDGsUyUksMwkTmLadLqjF30DrURQJvkXfXYCDAio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983817; c=relaxed/simple;
	bh=rBJmvvt90HDeiAfb2lB09Hn+cy3yovrTxhNLvwMkFss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fz0TnmO9D/7MMAjCbqqn4lWLkht+bx5XA6aJWqcCkri+6CGzznV4KfnVPF+/gCi1lw2xaJ+PHRl0qMJJAnoyVB7fGLYSI/GXlpgKm3/BJovY86H7w2ysMqNCB8HTvv2sE5pcUvaZ4BkkanhxJX9U0XPxue4/ILixJ2KSjPfFLR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5LHR3dL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5LHR3dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9EDC116D0;
	Wed, 25 Feb 2026 01:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983816;
	bh=rBJmvvt90HDeiAfb2lB09Hn+cy3yovrTxhNLvwMkFss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5LHR3dLZI5Ano3O1TMAfFtb0ZKb37rIDVPKgQvuuPBuH4PJc3K6l6mJcztOy+ugz
	 pPtv0iXUFqd5abhwaook8a21VUyjoS5LF862Nww+HL79sSuHfrkGGQjJx9B3npOKIO
	 ScxuzVwh484phnjXmTKEKwkoFcuWvbdpTNdSbLpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/641] selftests/bpf: Fix kprobe multi stacktrace_ips test
Date: Tue, 24 Feb 2026 17:17:07 -0800
Message-ID: <20260225012351.556819218@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 0207f94971e72a13380e28022c86da147e8e090f ]

We now include the attached function in the stack trace,
fixing the test accordingly.

Fixes: c9e208fa93cd ("selftests/bpf: Add stacktrace ips test for kprobe_multi/kretprobe_multi")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260126211837.472802-4-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/stacktrace_ips.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_ips.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_ips.c
index c9efdd2a5b18a..c93718dafd9b6 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_ips.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_ips.c
@@ -74,11 +74,20 @@ static void test_stacktrace_ips_kprobe_multi(bool retprobe)
 
 	load_kallsyms();
 
-	check_stacktrace_ips(bpf_map__fd(skel->maps.stackmap), skel->bss->stack_key, 4,
-			     ksym_get_addr("bpf_testmod_stacktrace_test_3"),
-			     ksym_get_addr("bpf_testmod_stacktrace_test_2"),
-			     ksym_get_addr("bpf_testmod_stacktrace_test_1"),
-			     ksym_get_addr("bpf_testmod_test_read"));
+	if (retprobe) {
+		check_stacktrace_ips(bpf_map__fd(skel->maps.stackmap), skel->bss->stack_key, 4,
+				     ksym_get_addr("bpf_testmod_stacktrace_test_3"),
+				     ksym_get_addr("bpf_testmod_stacktrace_test_2"),
+				     ksym_get_addr("bpf_testmod_stacktrace_test_1"),
+				     ksym_get_addr("bpf_testmod_test_read"));
+	} else {
+		check_stacktrace_ips(bpf_map__fd(skel->maps.stackmap), skel->bss->stack_key, 5,
+				     ksym_get_addr("bpf_testmod_stacktrace_test"),
+				     ksym_get_addr("bpf_testmod_stacktrace_test_3"),
+				     ksym_get_addr("bpf_testmod_stacktrace_test_2"),
+				     ksym_get_addr("bpf_testmod_stacktrace_test_1"),
+				     ksym_get_addr("bpf_testmod_test_read"));
+	}
 
 cleanup:
 	stacktrace_ips__destroy(skel);
-- 
2.51.0



