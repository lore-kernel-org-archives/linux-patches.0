Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4B13D896;
	Tue, 23 Jul 2024 18:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760243; cv=none; b=sCblhaM/OK/8+h0rwpAyStFpHMr06drLIEV49fUn69B1tJL+Fj3uVGsiX2OfHeuFOIJYlInCmqlRghJooU1v8Q8ru7pa9zcAc9WAyvcoDYRkct0xIyJEPCuVVCcPiFZ6oYII+wlyNJlV03yIkIRPxMJuiwCCSjul8xHF74D2k28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760243; c=relaxed/simple;
	bh=mQE8wgnR0HfcY3YgxHgKdZUrfa0oUoSq+1XJFYHJSj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ownu+ZAMqxjJZ3hwI2GjL60HRPDbQtlW4yTP4oxCnNqnpU3jW464QkXxZALf5au/0VF+M5lIFYG0H99+pOjBJ21dIm9qlMahXnEz3eKh/C617mT2FLccwzB75b+fy8A8jWOCKTmuOj+UvBjiUZq/jZJ/XJ+gm4om156qWhsSbFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lS2TA3yD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lS2TA3yD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93F9C4AF0A;
	Tue, 23 Jul 2024 18:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760243;
	bh=mQE8wgnR0HfcY3YgxHgKdZUrfa0oUoSq+1XJFYHJSj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS2TA3yDK/6RlSc7ZCMfD0nja6W6LK8BLGbM36IBicGp89Xhf02S1FMPNC/Q38rWh
	 COmEV1jfgAl7dI3Sn9PQk9RYyqCgRB2igrNGyx3lamwGKJ4lBBLu/dQg/Pi1+GPVzg
	 iiqKKgyYJGHHcdQSFP9ShXNuhzTDHv5nj5YKZSTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 151/163] selftests/bpf: Extend tcx tests to cover late tcx_entry release
Date: Tue, 23 Jul 2024 20:24:40 +0200
Message-ID: <20240723180149.305034461@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 5f1d18de79180deac2822c93e431bbe547f7d3ce ]

Add a test case which replaces an active ingress qdisc while keeping the
miniq in-tact during the transition period to the new clsact qdisc.

  # ./vmtest.sh -- ./test_progs -t tc_link
  [...]
  ./test_progs -t tc_link
  [    3.412871] bpf_testmod: loading out-of-tree module taints kernel.
  [    3.413343] bpf_testmod: module verification failed: signature and/or required key missing - tainting kernel
  #332     tc_links_after:OK
  #333     tc_links_append:OK
  #334     tc_links_basic:OK
  #335     tc_links_before:OK
  #336     tc_links_chain_classic:OK
  #337     tc_links_chain_mixed:OK
  #338     tc_links_dev_chain0:OK
  #339     tc_links_dev_cleanup:OK
  #340     tc_links_dev_mixed:OK
  #341     tc_links_ingress:OK
  #342     tc_links_invalid:OK
  #343     tc_links_prepend:OK
  #344     tc_links_replace:OK
  #345     tc_links_revision:OK
  Summary: 14/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20240708133130.11609-2-daniel@iogearbox.net
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/config            |  3 +
 .../selftests/bpf/prog_tests/tc_links.c       | 61 +++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 01f241ea2c67b..dec9fd7ebba7f 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -53,9 +53,12 @@ CONFIG_MPLS=y
 CONFIG_MPLS_IPTUNNEL=y
 CONFIG_MPLS_ROUTING=y
 CONFIG_MPTCP=y
+CONFIG_NET_ACT_SKBMOD=y
+CONFIG_NET_CLS=y
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_CLS_BPF=y
 CONFIG_NET_CLS_FLOWER=y
+CONFIG_NET_CLS_MATCHALL=y
 CONFIG_NET_FOU=y
 CONFIG_NET_FOU_IP_TUNNELS=y
 CONFIG_NET_IPGRE=y
diff --git a/tools/testing/selftests/bpf/prog_tests/tc_links.c b/tools/testing/selftests/bpf/prog_tests/tc_links.c
index bc98411446855..1af9ec1149aab 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_links.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_links.c
@@ -9,6 +9,8 @@
 #define ping_cmd "ping -q -c1 -w1 127.0.0.1 > /dev/null"
 
 #include "test_tc_link.skel.h"
+
+#include "netlink_helpers.h"
 #include "tc_helpers.h"
 
 void serial_test_tc_links_basic(void)
@@ -1787,6 +1789,65 @@ void serial_test_tc_links_ingress(void)
 	test_tc_links_ingress(BPF_TCX_INGRESS, false, false);
 }
 
+struct qdisc_req {
+	struct nlmsghdr  n;
+	struct tcmsg     t;
+	char             buf[1024];
+};
+
+static int qdisc_replace(int ifindex, const char *kind, bool block)
+{
+	struct rtnl_handle rth = { .fd = -1 };
+	struct qdisc_req req;
+	int err;
+
+	err = rtnl_open(&rth, 0);
+	if (!ASSERT_OK(err, "open_rtnetlink"))
+		return err;
+
+	memset(&req, 0, sizeof(req));
+	req.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.n.nlmsg_flags = NLM_F_CREATE | NLM_F_REPLACE | NLM_F_REQUEST;
+	req.n.nlmsg_type = RTM_NEWQDISC;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_ifindex = ifindex;
+	req.t.tcm_parent = 0xfffffff1;
+
+	addattr_l(&req.n, sizeof(req), TCA_KIND, kind, strlen(kind) + 1);
+	if (block)
+		addattr32(&req.n, sizeof(req), TCA_INGRESS_BLOCK, 1);
+
+	err = rtnl_talk(&rth, &req.n, NULL);
+	ASSERT_OK(err, "talk_rtnetlink");
+	rtnl_close(&rth);
+	return err;
+}
+
+void serial_test_tc_links_dev_chain0(void)
+{
+	int err, ifindex;
+
+	ASSERT_OK(system("ip link add dev foo type veth peer name bar"), "add veth");
+	ifindex = if_nametoindex("foo");
+	ASSERT_NEQ(ifindex, 0, "non_zero_ifindex");
+	err = qdisc_replace(ifindex, "ingress", true);
+	if (!ASSERT_OK(err, "attaching ingress"))
+		goto cleanup;
+	ASSERT_OK(system("tc filter add block 1 matchall action skbmod swap mac"), "add block");
+	err = qdisc_replace(ifindex, "clsact", false);
+	if (!ASSERT_OK(err, "attaching clsact"))
+		goto cleanup;
+	/* Heuristic: kern_sync_rcu() alone does not work; a wait-time of ~5s
+	 * triggered the issue without the fix reliably 100% of the time.
+	 */
+	sleep(5);
+	ASSERT_OK(system("tc filter add dev foo ingress matchall action skbmod swap mac"), "add filter");
+cleanup:
+	ASSERT_OK(system("ip link del dev foo"), "del veth");
+	ASSERT_EQ(if_nametoindex("foo"), 0, "foo removed");
+	ASSERT_EQ(if_nametoindex("bar"), 0, "bar removed");
+}
+
 static void test_tc_links_dev_mixed(int target)
 {
 	LIBBPF_OPTS(bpf_tc_opts, tc_opts, .handle = 1, .priority = 1);
-- 
2.43.0



