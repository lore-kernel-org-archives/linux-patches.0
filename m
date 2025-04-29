Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83954243364;
	Tue, 29 Apr 2025 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948333; cv=none; b=HA2KRpCPrXxCBD4kQQWBxTKLPjd+9y9wTN83nGuqPK2A2idwxhD4qXaisgQVL27n013aP+UiVzjSlY+BGINZ6vI50pwOKM1E6Isix/KSq1w9t+Zq/wmzhFaneSmxNtCfXALZgwS12mHfD/fWz2VW8Fecnu+xizezJG6QPpY29Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948333; c=relaxed/simple;
	bh=D9+vyBYeJTI9+dU6hmZXp7tDUNd/viM0+6w9v5h2lbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5Gi0DdlmRi8rOGOcygT+sJLtGvAi7Hsjf/uRgMNiec7wJxBdsrQBT79y95YZPweshl3PoOfVrM+0E3h5rfAeU9y8ZopdVlqbnOoueo0mUiwlCWcCR64Hu1mLJgu3WyGo/sJoIAw0WGwzVAVj5Z/rk+3e+QGvwFgwKrbPFOkg1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbvEr0E/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbvEr0E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B429C4CEE3;
	Tue, 29 Apr 2025 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948333;
	bh=D9+vyBYeJTI9+dU6hmZXp7tDUNd/viM0+6w9v5h2lbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbvEr0E/jCmKJX/wCY5elGyxEYz4iG0QL2ChyeVHqm9SRfPSpV/xpLynWlLLB9SmF
	 rKVwZ/9C+AGAWt+F9irqdtKQ4R/9QwbR7a5DnLLV8h5UAT7iMrs7BYdM/OnRB5cC6r
	 WTJUvsE09PLAtbyWMWHRGIT3I6Z+kgPsbb71/ef0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 256/280] selftests/bpf: make xdp_cpumap_attach keep redirect prog attached
Date: Tue, 29 Apr 2025 18:43:17 +0200
Message-ID: <20250429161125.608639902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

commit d5fbcf46ee82574aee443423f3e4132d1154372b upstream.

Current test only checks attach/detach on cpu map type program, and so
does not check that it can be properly executed, neither that it
redirects correctly.

Update the existing test to extend its coverage:
- keep the redirected program loaded
- try to execute it through bpf_prog_test_run_opts with some dummy
  context

While at it, bring the following minor improvements:
- isolate test interface in its own namespace

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Link: https://lore.kernel.org/r/20241009-convert_xdp_tests-v3-2-51cea913710c@bootlin.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: c7f2188d68c1 ("selftests/bpf: Adjust data size to have ETH_HLEN")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c |   41 ++++++++++---
 1 file changed, 33 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -2,35 +2,41 @@
 #include <uapi/linux/bpf.h>
 #include <linux/if_link.h>
 #include <test_progs.h>
+#include <network_helpers.h>
 
 #include "test_xdp_with_cpumap_frags_helpers.skel.h"
 #include "test_xdp_with_cpumap_helpers.skel.h"
 
 #define IFINDEX_LO	1
+#define TEST_NS "cpu_attach_ns"
 
 static void test_xdp_with_cpumap_helpers(void)
 {
-	struct test_xdp_with_cpumap_helpers *skel;
+	struct test_xdp_with_cpumap_helpers *skel = NULL;
 	struct bpf_prog_info info = {};
 	__u32 len = sizeof(info);
 	struct bpf_cpumap_val val = {
 		.qsize = 192,
 	};
-	int err, prog_fd, map_fd;
+	int err, prog_fd, prog_redir_fd, map_fd;
+	struct nstoken *nstoken = NULL;
 	__u32 idx = 0;
 
+	SYS(out_close, "ip netns add %s", TEST_NS);
+	nstoken = open_netns(TEST_NS);
+	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
+		goto out_close;
+	SYS(out_close, "ip link set dev lo up");
+
 	skel = test_xdp_with_cpumap_helpers__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "test_xdp_with_cpumap_helpers__open_and_load"))
 		return;
 
-	prog_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
-	err = bpf_xdp_attach(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE, NULL);
+	prog_redir_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
+	err = bpf_xdp_attach(IFINDEX_LO, prog_redir_fd, XDP_FLAGS_SKB_MODE, NULL);
 	if (!ASSERT_OK(err, "Generic attach of program with 8-byte CPUMAP"))
 		goto out_close;
 
-	err = bpf_xdp_detach(IFINDEX_LO, XDP_FLAGS_SKB_MODE, NULL);
-	ASSERT_OK(err, "XDP program detach");
-
 	prog_fd = bpf_program__fd(skel->progs.xdp_dummy_cm);
 	map_fd = bpf_map__fd(skel->maps.cpu_map);
 	err = bpf_prog_get_info_by_fd(prog_fd, &info, &len);
@@ -45,6 +51,23 @@ static void test_xdp_with_cpumap_helpers
 	ASSERT_OK(err, "Read cpumap entry");
 	ASSERT_EQ(info.id, val.bpf_prog.id, "Match program id to cpumap entry prog_id");
 
+	/* send a packet to trigger any potential bugs in there */
+	char data[10] = {};
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+			    .data_in = &data,
+			    .data_size_in = 10,
+			    .flags = BPF_F_TEST_XDP_LIVE_FRAMES,
+			    .repeat = 1,
+		);
+	err = bpf_prog_test_run_opts(prog_redir_fd, &opts);
+	ASSERT_OK(err, "XDP test run");
+
+	/* wait for the packets to be flushed */
+	kern_sync_rcu();
+
+	err = bpf_xdp_detach(IFINDEX_LO, XDP_FLAGS_SKB_MODE, NULL);
+	ASSERT_OK(err, "XDP program detach");
+
 	/* can not attach BPF_XDP_CPUMAP program to a device */
 	err = bpf_xdp_attach(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE, NULL);
 	if (!ASSERT_NEQ(err, 0, "Attach of BPF_XDP_CPUMAP program"))
@@ -65,6 +88,8 @@ static void test_xdp_with_cpumap_helpers
 	ASSERT_NEQ(err, 0, "Add BPF_XDP program with frags to cpumap entry");
 
 out_close:
+	close_netns(nstoken);
+	SYS_NOFAIL("ip netns del %s", TEST_NS);
 	test_xdp_with_cpumap_helpers__destroy(skel);
 }
 
@@ -111,7 +136,7 @@ out_close:
 	test_xdp_with_cpumap_frags_helpers__destroy(skel);
 }
 
-void serial_test_xdp_cpumap_attach(void)
+void test_xdp_cpumap_attach(void)
 {
 	if (test__start_subtest("CPUMAP with programs in entries"))
 		test_xdp_with_cpumap_helpers();


