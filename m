Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94071E3DF9;
	Tue,  3 Dec 2024 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238389; cv=none; b=IltwQQ/L9iEBIyURHwdXv1RkeXlk+odqZqNbXn131DR6yrIwEgcuYGpqx/ej0WtTtSwOllXdV4dqUEuPVxqyAvGjWA+ayPgzv4lpFkvGUy5xlJ+ia3CMAZEIcBKOx/xrDrhvynLweJV34aTx0aIk3fwMt8jsqAeNbalKUSOSC6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238389; c=relaxed/simple;
	bh=52IsrZO/Ui3uiWVnmpfkO8zTGNDcW1PSrs5O5STST6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr0R4ny1kZpwMUSV+ygby7/By74iNHH4HsY0kWp6aZuBZMB0jt0tuSqumIoyUhJw2iMq/IyFv33pCU3nBR/RNQTLBSuMTXfN9kB7NTaVVMIvYx28uOd7K6VsUp1dNSPaagbYMOp0AKxYS8tLDVPX5dVWq7FP2g1yFR8G4A5I63E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckuy43rc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckuy43rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E73C4CED6;
	Tue,  3 Dec 2024 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238389;
	bh=52IsrZO/Ui3uiWVnmpfkO8zTGNDcW1PSrs5O5STST6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckuy43rczXia1qWJw3RkymoFXlR1edtRzilSPxjP7jsQoUzvFW6QNb/dhd1E2Td0g
	 0dOiRa8Xq6volpBzxfy5OSMbzNTdR4KY8dNWG9SdyXh4UYuPP5xlT7FNQehDjTyTI2
	 DXRHfU0rZ4El9xHZjumngtsRTG+Iwq3AuzRkbPbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@fomichev.me>,
	Kui-Feng Lee <thinker.li@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 260/817] selftests/bpf: netns_new() and netns_free() helpers.
Date: Tue,  3 Dec 2024 15:37:12 +0100
Message-ID: <20241203144005.938193536@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kui-Feng Lee <thinker.li@gmail.com>

[ Upstream commit 1e115a58be0ffca63727dc0495dae924a19f8cd4 ]

netns_new()/netns_free() create/delete network namespaces. They support the
option '-m' of test_progs to start/stop traffic monitor for the network
namespace being created for matched tests.

Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Kui-Feng Lee <thinker.li@gmail.com>
Link: https://lore.kernel.org/r/20240815053254.470944-4-thinker.li@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: 5bf1557e3d6a ("selftests/bpf: Fix backtrace printing for selftests crashes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c | 46 ++++++++++
 tools/testing/selftests/bpf/network_helpers.h |  2 +
 tools/testing/selftests/bpf/test_progs.c      | 88 +++++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h      |  4 +
 4 files changed, 140 insertions(+)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index e0cba4178e41d..cff7817964234 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -448,6 +448,52 @@ char *ping_command(int family)
 	return "ping";
 }
 
+int remove_netns(const char *name)
+{
+	char *cmd;
+	int r;
+
+	r = asprintf(&cmd, "ip netns del %s >/dev/null 2>&1", name);
+	if (r < 0) {
+		log_err("Failed to malloc cmd");
+		return -1;
+	}
+
+	r = system(cmd);
+	free(cmd);
+	return r;
+}
+
+int make_netns(const char *name)
+{
+	char *cmd;
+	int r;
+
+	r = asprintf(&cmd, "ip netns add %s", name);
+	if (r < 0) {
+		log_err("Failed to malloc cmd");
+		return -1;
+	}
+
+	r = system(cmd);
+	free(cmd);
+
+	if (r)
+		return r;
+
+	r = asprintf(&cmd, "ip -n %s link set lo up", name);
+	if (r < 0) {
+		log_err("Failed to malloc cmd for setting up lo");
+		remove_netns(name);
+		return -1;
+	}
+
+	r = system(cmd);
+	free(cmd);
+
+	return r;
+}
+
 struct nstoken {
 	int orig_netns_fd;
 };
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index aac5b94d63799..91763fbe58d27 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -92,6 +92,8 @@ struct nstoken;
 struct nstoken *open_netns(const char *name);
 void close_netns(struct nstoken *token);
 int send_recv_data(int lfd, int fd, uint32_t total_bytes);
+int make_netns(const char *name);
+int remove_netns(const char *name);
 
 static __u16 csum_fold(__u32 csum)
 {
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index d5d0cb4eb1975..05bd298b15f4c 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -18,6 +18,8 @@
 #include <bpf/btf.h>
 #include "json_writer.h"
 
+#include "network_helpers.h"
+
 #ifdef __GLIBC__
 #include <execinfo.h> /* backtrace */
 #endif
@@ -624,6 +626,92 @@ int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len)
 	return err;
 }
 
+struct netns_obj {
+	char *nsname;
+	struct tmonitor_ctx *tmon;
+	struct nstoken *nstoken;
+};
+
+/* Create a new network namespace with the given name.
+ *
+ * Create a new network namespace and set the network namespace of the
+ * current process to the new network namespace if the argument "open" is
+ * true. This function should be paired with netns_free() to release the
+ * resource and delete the network namespace.
+ *
+ * It also implements the functionality of the option "-m" by starting
+ * traffic monitor on the background to capture the packets in this network
+ * namespace if the current test or subtest matching the pattern.
+ *
+ * nsname: the name of the network namespace to create.
+ * open: open the network namespace if true.
+ *
+ * Return: the network namespace object on success, NULL on failure.
+ */
+struct netns_obj *netns_new(const char *nsname, bool open)
+{
+	struct netns_obj *netns_obj = malloc(sizeof(*netns_obj));
+	const char *test_name, *subtest_name;
+	int r;
+
+	if (!netns_obj)
+		return NULL;
+	memset(netns_obj, 0, sizeof(*netns_obj));
+
+	netns_obj->nsname = strdup(nsname);
+	if (!netns_obj->nsname)
+		goto fail;
+
+	/* Create the network namespace */
+	r = make_netns(nsname);
+	if (r)
+		goto fail;
+
+	/* Start traffic monitor */
+	if (env.test->should_tmon ||
+	    (env.subtest_state && env.subtest_state->should_tmon)) {
+		test_name = env.test->test_name;
+		subtest_name = env.subtest_state ? env.subtest_state->name : NULL;
+		netns_obj->tmon = traffic_monitor_start(nsname, test_name, subtest_name);
+		if (!netns_obj->tmon) {
+			fprintf(stderr, "Failed to start traffic monitor for %s\n", nsname);
+			goto fail;
+		}
+	} else {
+		netns_obj->tmon = NULL;
+	}
+
+	if (open) {
+		netns_obj->nstoken = open_netns(nsname);
+		if (!netns_obj->nstoken)
+			goto fail;
+	}
+
+	return netns_obj;
+fail:
+	traffic_monitor_stop(netns_obj->tmon);
+	remove_netns(nsname);
+	free(netns_obj->nsname);
+	free(netns_obj);
+	return NULL;
+}
+
+/* Delete the network namespace.
+ *
+ * This function should be paired with netns_new() to delete the namespace
+ * created by netns_new().
+ */
+void netns_free(struct netns_obj *netns_obj)
+{
+	if (!netns_obj)
+		return;
+	traffic_monitor_stop(netns_obj->tmon);
+	close_netns(netns_obj->nstoken);
+	remove_netns(netns_obj->nsname);
+	free(netns_obj->nsname);
+	free(netns_obj);
+}
+
 /* extern declarations for test funcs */
 #define DEFINE_TEST(name)				\
 	extern void test_##name(void) __weak;		\
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index b1e949fb16cf3..dbc4127f9dbd2 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -428,6 +428,10 @@ int write_sysctl(const char *sysctl, const char *value);
 int get_bpf_max_tramp_links_from(struct btf *btf);
 int get_bpf_max_tramp_links(void);
 
+struct netns_obj;
+struct netns_obj *netns_new(const char *name, bool open);
+void netns_free(struct netns_obj *netns);
+
 #ifdef __x86_64__
 #define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
 #elif defined(__s390x__)
-- 
2.43.0



