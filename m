Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBABF155A26;
	Tue,  9 Jul 2024 11:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523944; cv=none; b=dMmApoCVejTmfyyeIYDeDuBHuJAwxDi9uI3HkxG3VqYFTnT8GaOWwxRFsADmRymSc4X1n8ZAt4Uj6TtoDPkcbcqBO1++W8A0fWPXHOyEzpK0ZEdgUYFJmLCR0UYYgtznuvW+ynPOvMnHQy/Uus5IOdEfgoUxtr7OXXFctmLqRlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523944; c=relaxed/simple;
	bh=K5ALkmwy3ILMvY5WRAKM80CzVYqkN5LXWD3KnjBVEdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbuBEwaRCiWlNW9dCIzrGKlu3eHF5pffgsK5LGl5WMcAsoHJS9CUQfnqGyJe77pckoOCLFTe0yEN9bzeMwXrGFlNLTGpLICIabpJMa3deO82I+bbceB8ui6yk8H/sm0EaLZyRFB9dERq1fr3x/f4d7qLS6RSo7t8qYxxIfMNDyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0065oTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0065oTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D04C3277B;
	Tue,  9 Jul 2024 11:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523944;
	bh=K5ALkmwy3ILMvY5WRAKM80CzVYqkN5LXWD3KnjBVEdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0065oTD0PlczsU4upNOY1X4urQdzPfeEsB6K7XuoGS/nqF/5LnuVbtP0imP0yjL6
	 FNjNQkAsaTSOqPbYUpCEnBFObXXF9hxqfrmqD4s6hLGeszxg8/LA0TeZpY2i0iPxGr
	 xre+U3KmL7jOPMYhGpudoVZiBJrpDG2PF9dDsDQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 020/197] selftests/bpf: dummy_st_ops should reject 0 for non-nullable params
Date: Tue,  9 Jul 2024 13:07:54 +0200
Message-ID: <20240709110709.698785532@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 6a2d30d3c5bf9f088dcfd5f3746b04d84f2fab83 ]

Check if BPF_PROG_TEST_RUN for bpf_dummy_struct_ops programs
rejects execution if NULL is passed for non-nullable parameter.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240424012821.595216-6-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/dummy_st_ops.c   | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
index dd926c00f4146..d3d94596ab79c 100644
--- a/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
+++ b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
@@ -147,6 +147,31 @@ static void test_dummy_sleepable(void)
 	dummy_st_ops_success__destroy(skel);
 }
 
+/* dummy_st_ops.test_sleepable() parameter is not marked as nullable,
+ * thus bpf_prog_test_run_opts() below should be rejected as it tries
+ * to pass NULL for this parameter.
+ */
+static void test_dummy_sleepable_reject_null(void)
+{
+	__u64 args[1] = {0};
+	LIBBPF_OPTS(bpf_test_run_opts, attr,
+		.ctx_in = args,
+		.ctx_size_in = sizeof(args),
+	);
+	struct dummy_st_ops_success *skel;
+	int fd, err;
+
+	skel = dummy_st_ops_success__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
+		return;
+
+	fd = bpf_program__fd(skel->progs.test_sleepable);
+	err = bpf_prog_test_run_opts(fd, &attr);
+	ASSERT_EQ(err, -EINVAL, "test_run");
+
+	dummy_st_ops_success__destroy(skel);
+}
+
 void test_dummy_st_ops(void)
 {
 	if (test__start_subtest("dummy_st_ops_attach"))
@@ -159,6 +184,8 @@ void test_dummy_st_ops(void)
 		test_dummy_multiple_args();
 	if (test__start_subtest("dummy_sleepable"))
 		test_dummy_sleepable();
+	if (test__start_subtest("dummy_sleepable_reject_null"))
+		test_dummy_sleepable_reject_null();
 
 	RUN_TESTS(dummy_st_ops_fail);
 }
-- 
2.43.0



