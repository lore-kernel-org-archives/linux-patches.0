Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353183328E7;
	Wed, 25 Feb 2026 06:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002795; cv=none; b=CRo/sk/Ieiq+wtXgzDu4t2fNGeyKh9a896ZOW7tIGwVRe+3T24S9jArbORueuCPC1Lw4oL1NGUQ+j2nsnhwVNOjelz/Tfqm4p+otnhC7xSeGF/7RqWlFzpS5j3WiNJCHBi87zxu2fp1tkmB8AOcwX7G50SZM8BWE3YcCDDqBJRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002795; c=relaxed/simple;
	bh=medo3rsHinhJqoQ7/cX9tHYrnXnUevmtcnLqazIIP3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUe4mA0x7/gveRGzl6lNr95ErmEMYkHMaTx8dUZ3wOws4dxgt9K8FuRaDP/NPjKv0N8cGU5Sg3c1a9WPBkdHBJT4gqVUvC7K+ita3vNJ+u1AX+Jvlot565gDeZwXcFMrG6ypvcQA66dm2RC9hY/M+EQJzqX6Y6/sjhQYp6mDXzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KeuN3SxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KeuN3SxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82CDC116D0;
	Wed, 25 Feb 2026 06:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002794;
	bh=medo3rsHinhJqoQ7/cX9tHYrnXnUevmtcnLqazIIP3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeuN3SxDIicL2Z1Tf3D/QjmDECtSZJvEPoocCAyNdFnaRhk5+8aWThnyLHm1Mfa2J
	 YFkEKOk0aHZFQ9b7imxmNz3M3dhsHS6G143zy1Ozni1yINM+Fcfilvl3HeF1Ff9ELD
	 j/qCcKAHT2poqz8iuAg8J/fyzBJwL3AbKyixmxbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.18 639/641] selftests/bpf: Test bpf_skb_check_mtu(BPF_MTU_CHK_SEGS) when transport_header is not set
Date: Tue, 24 Feb 2026 17:26:05 -0800
Message-ID: <20260225012403.986715285@linuxfoundation.org>
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
Message-ID: <20260225012605._i5nOdjSXV0RtsLFsGrETa7DazgIfZGebRuMrdfEyD0@z>

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <martin.lau@kernel.org>

commit 6cc73f35406cae1f053e984e8de40e6dc9681446 upstream.

Add a test to check that bpf_skb_check_mtu(BPF_MTU_CHK_SEGS) is
rejected (-EINVAL) if skb->transport_header is not set. The test
needs to lower the MTU of the loopback device. Thus, take this
opportunity to run the test in a netns by adding "ns_" to the test
name. The "serial_" prefix can then be removed.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20251112232331.1566074-2-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |   23 ++++++++++++++++++++-
 tools/testing/selftests/bpf/progs/test_check_mtu.c |   12 ++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/prog_tests/check_mtu.c
+++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
@@ -153,6 +153,26 @@ static void test_check_mtu_run_tc(struct
 	ASSERT_EQ(mtu_result, mtu_expect, "MTU-compare-user");
 }
 
+static void test_chk_segs_flag(struct test_check_mtu *skel, __u32 mtu)
+{
+	int err, prog_fd = bpf_program__fd(skel->progs.tc_chk_segs_flag);
+	struct __sk_buff skb = {
+		.gso_size = 10,
+	};
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		    .data_in = &pkt_v4,
+		    .data_size_in = sizeof(pkt_v4),
+		    .ctx_in = &skb,
+		    .ctx_size_in = sizeof(skb),
+	);
+
+	/* Lower the mtu to test the BPF_MTU_CHK_SEGS */
+	SYS_NOFAIL("ip link set dev lo mtu 10");
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	SYS_NOFAIL("ip link set dev lo mtu %u", mtu);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(topts.retval, BPF_OK, "retval");
+}
 
 static void test_check_mtu_tc(__u32 mtu, __u32 ifindex)
 {
@@ -177,11 +197,12 @@ static void test_check_mtu_tc(__u32 mtu,
 	test_check_mtu_run_tc(skel, skel->progs.tc_minus_delta, mtu);
 	test_check_mtu_run_tc(skel, skel->progs.tc_input_len, mtu);
 	test_check_mtu_run_tc(skel, skel->progs.tc_input_len_exceed, mtu);
+	test_chk_segs_flag(skel, mtu);
 cleanup:
 	test_check_mtu__destroy(skel);
 }
 
-void serial_test_check_mtu(void)
+void test_ns_check_mtu(void)
 {
 	int mtu_lo;
 
--- a/tools/testing/selftests/bpf/progs/test_check_mtu.c
+++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
@@ -7,6 +7,7 @@
 
 #include <stddef.h>
 #include <stdint.h>
+#include <errno.h>
 
 char _license[] SEC("license") = "GPL";
 
@@ -288,3 +289,14 @@ int tc_input_len_exceed(struct __sk_buff
 	global_bpf_mtu_xdp = mtu_len;
 	return retval;
 }
+
+SEC("tc")
+int tc_chk_segs_flag(struct __sk_buff *ctx)
+{
+	__u32 mtu_len = 0;
+	int err;
+
+	err = bpf_check_mtu(ctx, GLOBAL_USER_IFINDEX, &mtu_len, 0, BPF_MTU_CHK_SEGS);
+
+	return err == -EINVAL ? BPF_OK : BPF_DROP;
+}


