Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051C14369A;
	Wed, 25 Feb 2026 01:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982942; cv=none; b=UD+PIjlIYm06kbt1COcm5TwvUVsWuTcm2Saf6StOkeMn7nqUSdg3eGCqDTSdHZRqAXVGGeMz/RT718C0sutKy7S6DPeJC/TszE4AKKgZrueVqoYVvcejf3aq3UhE0pzJ67YOW00HdfGGN8skx9a/OvKJz6M06dbaUy7EWJTxE8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982942; c=relaxed/simple;
	bh=6JfrC9Z1TuOkGSHfCin5dt2YIrmReTxnLyDo444llU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ4mZD/VbJTXxDqAuE/kl6wNpttMNF02AcRzh0ZyHamv8GI+F69RiTzq3Z2yURA1NBkiEqWQOZJTeA5dbssP+cg119+5cu43gtl0zq3olVTl7NXbbWVvhy5/LAapyegR9NDpbROTDfwt0lG9OImaL7TYag5gBWUbXvfnoTbts+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dygY+3y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dygY+3y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0872C116D0;
	Wed, 25 Feb 2026 01:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982941;
	bh=6JfrC9Z1TuOkGSHfCin5dt2YIrmReTxnLyDo444llU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dygY+3y5Nmffx4u5F5eTP2btQpGt6zql7HN+Vu4kW1g/rIFfvon9HejsZAhuJlOz2
	 q6T8nYlhI053YZkzm6p+oqFC6y7qVRKmlJ6Q2ZIyi8tPOV0DQER8gUa0fwBKVZh1xd
	 /iY//stypPAd2vIg+2mjTQbhf/a+pjHQfkyGbLsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 113/781] selftests/bpf: Fix kprobe multi stacktrace_ips test
Date: Tue, 24 Feb 2026 17:13:42 -0800
Message-ID: <20260225012402.449481338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



