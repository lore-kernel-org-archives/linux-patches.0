Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F502144C1;
	Wed,  7 May 2025 19:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644942; cv=none; b=Pr9WHmxdkMdQXRR9tgoz8Jpc27Ros6C/1MN2g6Fkh7TaceYXalPwmUiWmnMwrSFpGXhkSqt4Uq8SFsV4+BZPIBLZaPF7FD0+7pP2j21fzysLSyRUMBlZY2oh4E+v4IbPStIq3PDRGmZhu8I+pbSbIOT08BjdayUKbhC/CuywaHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644942; c=relaxed/simple;
	bh=tTZ+tOcMxZVafqOz2fxBi9CoT7W3NhumK1oI1W12KRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXEydwr9K4YkL1dam6A5V3UzH6FSghGRaXJVCoqGjQ7orDhwyn2jzpf77H/oFufUnnaHCHewmgDXpXC4Wu+5XfFuoDfDJ2/57+Xf29iwHICTCS5yHt05BNZC/4t6u/Lzsk9z1xCJBanCy062DnXZSnLm8GiFNO3yBPr2zBtd3ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtOQTfj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtOQTfj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE62C4CEE2;
	Wed,  7 May 2025 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644941;
	bh=tTZ+tOcMxZVafqOz2fxBi9CoT7W3NhumK1oI1W12KRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtOQTfj2K2wDBIxftgkZtr1w2y8nfTa2TNnOgZfEDUVGm6NuD18H8Ahwm3gbGSf4s
	 xcEMb+9OvHN9bFc2Mb84Yf8GUhl3wNJE/JyOZqhKg6wGHLyzBWV9utaITNooyPl7FL
	 DqksH4K+NPLm+XbUmzBM2YwQFPPAc+V1dg/9YVIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 042/129] selftests/bpf: extend changes_pkt_data with cases w/o subprograms
Date: Wed,  7 May 2025 20:39:38 +0200
Message-ID: <20250507183815.247012143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 04789af756a4a43e72986185f66f148e65b32fed upstream.

Extend changes_pkt_data tests with test cases freplacing the main
program that does not have subprograms. Try four combinations when
both main program and replacement do and do not change packet data.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241212070711.427443-2-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/changes_pkt_data.c     |   55 +++++++---
 tools/testing/selftests/bpf/progs/changes_pkt_data.c          |   27 +++-
 tools/testing/selftests/bpf/progs/changes_pkt_data_freplace.c |    6 -
 3 files changed, 66 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/changes_pkt_data.c
+++ b/tools/testing/selftests/bpf/prog_tests/changes_pkt_data.c
@@ -10,10 +10,14 @@ static void print_verifier_log(const cha
 		fprintf(stdout, "VERIFIER LOG:\n=============\n%s=============\n", log);
 }
 
-static void test_aux(const char *main_prog_name, const char *freplace_prog_name, bool expect_load)
+static void test_aux(const char *main_prog_name,
+		     const char *to_be_replaced,
+		     const char *replacement,
+		     bool expect_load)
 {
 	struct changes_pkt_data_freplace *freplace = NULL;
 	struct bpf_program *freplace_prog = NULL;
+	struct bpf_program *main_prog = NULL;
 	LIBBPF_OPTS(bpf_object_open_opts, opts);
 	struct changes_pkt_data *main = NULL;
 	char log[16*1024];
@@ -26,6 +30,10 @@ static void test_aux(const char *main_pr
 	main = changes_pkt_data__open_opts(&opts);
 	if (!ASSERT_OK_PTR(main, "changes_pkt_data__open"))
 		goto out;
+	main_prog = bpf_object__find_program_by_name(main->obj, main_prog_name);
+	if (!ASSERT_OK_PTR(main_prog, "main_prog"))
+		goto out;
+	bpf_program__set_autoload(main_prog, true);
 	err = changes_pkt_data__load(main);
 	print_verifier_log(log);
 	if (!ASSERT_OK(err, "changes_pkt_data__load"))
@@ -33,14 +41,14 @@ static void test_aux(const char *main_pr
 	freplace = changes_pkt_data_freplace__open_opts(&opts);
 	if (!ASSERT_OK_PTR(freplace, "changes_pkt_data_freplace__open"))
 		goto out;
-	freplace_prog = bpf_object__find_program_by_name(freplace->obj, freplace_prog_name);
+	freplace_prog = bpf_object__find_program_by_name(freplace->obj, replacement);
 	if (!ASSERT_OK_PTR(freplace_prog, "freplace_prog"))
 		goto out;
 	bpf_program__set_autoload(freplace_prog, true);
 	bpf_program__set_autoattach(freplace_prog, true);
 	bpf_program__set_attach_target(freplace_prog,
-				       bpf_program__fd(main->progs.dummy),
-				       main_prog_name);
+				       bpf_program__fd(main_prog),
+				       to_be_replaced);
 	err = changes_pkt_data_freplace__load(freplace);
 	print_verifier_log(log);
 	if (expect_load) {
@@ -62,15 +70,38 @@ out:
  * that either do or do not. It is only ok to freplace subprograms
  * that do not change packet data with those that do not as well.
  * The below tests check outcomes for each combination of such freplace.
+ * Also test a case when main subprogram itself is replaced and is a single
+ * subprogram in a program.
  */
 void test_changes_pkt_data_freplace(void)
 {
-	if (test__start_subtest("changes_with_changes"))
-		test_aux("changes_pkt_data", "changes_pkt_data", true);
-	if (test__start_subtest("changes_with_doesnt_change"))
-		test_aux("changes_pkt_data", "does_not_change_pkt_data", true);
-	if (test__start_subtest("doesnt_change_with_changes"))
-		test_aux("does_not_change_pkt_data", "changes_pkt_data", false);
-	if (test__start_subtest("doesnt_change_with_doesnt_change"))
-		test_aux("does_not_change_pkt_data", "does_not_change_pkt_data", true);
+	struct {
+		const char *main;
+		const char *to_be_replaced;
+		bool changes;
+	} mains[] = {
+		{ "main_with_subprogs",   "changes_pkt_data",         true },
+		{ "main_with_subprogs",   "does_not_change_pkt_data", false },
+		{ "main_changes",         "main_changes",             true },
+		{ "main_does_not_change", "main_does_not_change",     false },
+	};
+	struct {
+		const char *func;
+		bool changes;
+	} replacements[] = {
+		{ "changes_pkt_data",         true },
+		{ "does_not_change_pkt_data", false }
+	};
+	char buf[64];
+
+	for (int i = 0; i < ARRAY_SIZE(mains); ++i) {
+		for (int j = 0; j < ARRAY_SIZE(replacements); ++j) {
+			snprintf(buf, sizeof(buf), "%s_with_%s",
+				 mains[i].to_be_replaced, replacements[j].func);
+			if (!test__start_subtest(buf))
+				continue;
+			test_aux(mains[i].main, mains[i].to_be_replaced, replacements[j].func,
+				 mains[i].changes || !replacements[j].changes);
+		}
+	}
 }
--- a/tools/testing/selftests/bpf/progs/changes_pkt_data.c
+++ b/tools/testing/selftests/bpf/progs/changes_pkt_data.c
@@ -4,22 +4,35 @@
 #include <bpf/bpf_helpers.h>
 
 __noinline
-long changes_pkt_data(struct __sk_buff *sk, __u32 len)
+long changes_pkt_data(struct __sk_buff *sk)
 {
-	return bpf_skb_pull_data(sk, len);
+	return bpf_skb_pull_data(sk, 0);
 }
 
 __noinline __weak
-long does_not_change_pkt_data(struct __sk_buff *sk, __u32 len)
+long does_not_change_pkt_data(struct __sk_buff *sk)
 {
 	return 0;
 }
 
-SEC("tc")
-int dummy(struct __sk_buff *sk)
+SEC("?tc")
+int main_with_subprogs(struct __sk_buff *sk)
+{
+	changes_pkt_data(sk);
+	does_not_change_pkt_data(sk);
+	return 0;
+}
+
+SEC("?tc")
+int main_changes(struct __sk_buff *sk)
+{
+	bpf_skb_pull_data(sk, 0);
+	return 0;
+}
+
+SEC("?tc")
+int main_does_not_change(struct __sk_buff *sk)
 {
-	changes_pkt_data(sk, 0);
-	does_not_change_pkt_data(sk, 0);
 	return 0;
 }
 
--- a/tools/testing/selftests/bpf/progs/changes_pkt_data_freplace.c
+++ b/tools/testing/selftests/bpf/progs/changes_pkt_data_freplace.c
@@ -4,13 +4,13 @@
 #include <bpf/bpf_helpers.h>
 
 SEC("?freplace")
-long changes_pkt_data(struct __sk_buff *sk, __u32 len)
+long changes_pkt_data(struct __sk_buff *sk)
 {
-	return bpf_skb_pull_data(sk, len);
+	return bpf_skb_pull_data(sk, 0);
 }
 
 SEC("?freplace")
-long does_not_change_pkt_data(struct __sk_buff *sk, __u32 len)
+long does_not_change_pkt_data(struct __sk_buff *sk)
 {
 	return 0;
 }


