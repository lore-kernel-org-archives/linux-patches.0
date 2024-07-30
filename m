Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1905189900;
	Tue, 30 Jul 2024 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357288; cv=none; b=Gj3OVRIDrBdpcm4QxwYO2vgYG100ZiFvdxS5lazYZV1UxWe7btj+JRhsP3L049tsx8FbOfBsBV+Chi13bM7Wo9Z0n7Vaan19vhmg5lwExcQ8Wx2TW8Zxa4OvrDsc7XIxS0wc29OFS2cCJDjNKFIeBPZVRR/zSrJu2neghE3V+zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357288; c=relaxed/simple;
	bh=MMvGYJjQnM/rKiD2fjwMLrRckAUfmZWK6md4kbfvr/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvMtS4QVhi/EX/dal070SL5AxS7+gDQunAMJnRqmtFYTtstFgOyjbnmlReXXDbYbwB+pCMBNDhAAkLmhfEE4j7whBWSM5yMaYgmPMCB9z9IqhIXUwLaYIyCaoMktbzwSNC2n9YvIlzkY6lUSRVGlJ6C+PesxvItd2pUPWWklRx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOCzKoo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOCzKoo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F00C32782;
	Tue, 30 Jul 2024 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357288;
	bh=MMvGYJjQnM/rKiD2fjwMLrRckAUfmZWK6md4kbfvr/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOCzKoo2pp+jbGibQw3bxGUkrCA3F3WTp+AVbjrtpq2pMEK+/24RP2FCRwWgltumT
	 UR9s2cFXzpPbdk0S8PyjE63kzvkU/e8dpO6/h8GotEZWO43eCVbsZsu8LvcJCLQSMR
	 6Z5cAExkcH2mv/3OLGsSt3r9jFJfLp6IzIjP3UEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Alan Maguire <alan.maguire@oracle.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 240/809] selftests/bpf: Null checks for links in bpf_tcp_ca
Date: Tue, 30 Jul 2024 17:41:56 +0200
Message-ID: <20240730151734.082968134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit eef0532e900c20a6760da829e82dac3ee18688c5 ]

Run bpf_tcp_ca selftests (./test_progs -t bpf_tcp_ca) on a Loongarch
platform, some "Segmentation fault" errors occur:

'''
 test_dctcp:PASS:bpf_dctcp__open_and_load 0 nsec
 test_dctcp:FAIL:bpf_map__attach_struct_ops unexpected error: -524
 #29/1    bpf_tcp_ca/dctcp:FAIL
 test_cubic:PASS:bpf_cubic__open_and_load 0 nsec
 test_cubic:FAIL:bpf_map__attach_struct_ops unexpected error: -524
 #29/2    bpf_tcp_ca/cubic:FAIL
 test_dctcp_fallback:PASS:dctcp_skel 0 nsec
 test_dctcp_fallback:PASS:bpf_dctcp__load 0 nsec
 test_dctcp_fallback:FAIL:dctcp link unexpected error: -524
 #29/4    bpf_tcp_ca/dctcp_fallback:FAIL
 test_write_sk_pacing:PASS:open_and_load 0 nsec
 test_write_sk_pacing:FAIL:attach_struct_ops unexpected error: -524
 #29/6    bpf_tcp_ca/write_sk_pacing:FAIL
 test_update_ca:PASS:open 0 nsec
 test_update_ca:FAIL:attach_struct_ops unexpected error: -524
 settcpca:FAIL:setsockopt unexpected setsockopt: \
					actual -1 == expected -1
 (network_helpers.c:99: errno: No such file or directory) \
					Failed to call post_socket_cb
 start_test:FAIL:start_server_str unexpected start_server_str: \
					actual -1 == expected -1
 test_update_ca:FAIL:ca1_ca1_cnt unexpected ca1_ca1_cnt: \
					actual 0 <= expected 0
 #29/9    bpf_tcp_ca/update_ca:FAIL
 #29      bpf_tcp_ca:FAIL
 Caught signal #11!
 Stack trace:
 ./test_progs(crash_handler+0x28)[0x5555567ed91c]
 linux-vdso.so.1(__vdso_rt_sigreturn+0x0)[0x7ffffee408b0]
 ./test_progs(bpf_link__update_map+0x80)[0x555556824a78]
 ./test_progs(+0x94d68)[0x5555564c4d68]
 ./test_progs(test_bpf_tcp_ca+0xe8)[0x5555564c6a88]
 ./test_progs(+0x3bde54)[0x5555567ede54]
 ./test_progs(main+0x61c)[0x5555567efd54]
 /usr/lib64/libc.so.6(+0x22208)[0x7ffff2aaa208]
 /usr/lib64/libc.so.6(__libc_start_main+0xac)[0x7ffff2aaa30c]
 ./test_progs(_start+0x48)[0x55555646bca8]
 Segmentation fault
'''

This is because BPF trampoline is not implemented on Loongarch yet,
"link" returned by bpf_map__attach_struct_ops() is NULL. test_progs
crashs when this NULL link passes to bpf_link__update_map(). This
patch adds NULL checks for all links in bpf_tcp_ca to fix these errors.
If "link" is NULL, goto the newly added label "out" to destroy the skel.

v2:
 - use "goto out" instead of "return" as Eduard suggested.

Fixes: 06da9f3bd641 ("selftests/bpf: Test switching TCP Congestion Control algorithms.")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/r/b4c841492bd4ed97964e4e61e92827ce51bf1dc9.1720615848.git.tanggeliang@kylinos.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c        | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index 0aca025327948..3f0daf660703f 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -307,7 +307,8 @@ static void test_update_ca(void)
 		return;
 
 	link = bpf_map__attach_struct_ops(skel->maps.ca_update_1);
-	ASSERT_OK_PTR(link, "attach_struct_ops");
+	if (!ASSERT_OK_PTR(link, "attach_struct_ops"))
+		goto out;
 
 	do_test("tcp_ca_update", NULL);
 	saved_ca1_cnt = skel->bss->ca1_cnt;
@@ -321,6 +322,7 @@ static void test_update_ca(void)
 	ASSERT_GT(skel->bss->ca2_cnt, 0, "ca2_ca2_cnt");
 
 	bpf_link__destroy(link);
+out:
 	tcp_ca_update__destroy(skel);
 }
 
@@ -336,7 +338,8 @@ static void test_update_wrong(void)
 		return;
 
 	link = bpf_map__attach_struct_ops(skel->maps.ca_update_1);
-	ASSERT_OK_PTR(link, "attach_struct_ops");
+	if (!ASSERT_OK_PTR(link, "attach_struct_ops"))
+		goto out;
 
 	do_test("tcp_ca_update", NULL);
 	saved_ca1_cnt = skel->bss->ca1_cnt;
@@ -349,6 +352,7 @@ static void test_update_wrong(void)
 	ASSERT_GT(skel->bss->ca1_cnt, saved_ca1_cnt, "ca2_ca1_cnt");
 
 	bpf_link__destroy(link);
+out:
 	tcp_ca_update__destroy(skel);
 }
 
@@ -363,7 +367,8 @@ static void test_mixed_links(void)
 		return;
 
 	link_nl = bpf_map__attach_struct_ops(skel->maps.ca_no_link);
-	ASSERT_OK_PTR(link_nl, "attach_struct_ops_nl");
+	if (!ASSERT_OK_PTR(link_nl, "attach_struct_ops_nl"))
+		goto out;
 
 	link = bpf_map__attach_struct_ops(skel->maps.ca_update_1);
 	ASSERT_OK_PTR(link, "attach_struct_ops");
@@ -376,6 +381,7 @@ static void test_mixed_links(void)
 
 	bpf_link__destroy(link);
 	bpf_link__destroy(link_nl);
+out:
 	tcp_ca_update__destroy(skel);
 }
 
@@ -418,7 +424,8 @@ static void test_link_replace(void)
 	bpf_link__destroy(link);
 
 	link = bpf_map__attach_struct_ops(skel->maps.ca_update_2);
-	ASSERT_OK_PTR(link, "attach_struct_ops_2nd");
+	if (!ASSERT_OK_PTR(link, "attach_struct_ops_2nd"))
+		goto out;
 
 	/* BPF_F_REPLACE with a wrong old map Fd. It should fail!
 	 *
@@ -441,6 +448,7 @@ static void test_link_replace(void)
 
 	bpf_link__destroy(link);
 
+out:
 	tcp_ca_update__destroy(skel);
 }
 
-- 
2.43.0



