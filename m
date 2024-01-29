Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7658157E68;
	Mon, 29 Jan 2024 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548526; cv=none; b=lPAvq/CuYiFinW5CF6/2k/zk5ZzG3hOMtTn43iueFR4MuFMCDPWurViXDz+VOCtrccN8d8q4hjypnRYoNaL5pQL6I7ReMIoAqnQhuHC5YMuOH7ZD4uJLYqeJP/P381aP00Ss23J+0XoZuHTTDtTIMna//wYNwepJmY4kzvTQrAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548526; c=relaxed/simple;
	bh=sTe6ngf+AsnH5mbfoVSouz2eY2gj/YXgYXK8uBgbk/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yg3YmFbWsCObUSj4DLc7+wJaraHauXIenUU8iYnOiYr7YPGLaKhdf1bTVFJBEIBTLZq7nlYwWw5167O9OCi7KwoR4S1dHPEaICek+cpo0TbUKL71Dhr1SZQy1zC23tELPe5UPS2Cm+jNZIb2jlG7P2zaR00czN4wR7PXxI+f7qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUlKgS5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUlKgS5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A78C433C7;
	Mon, 29 Jan 2024 17:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548526;
	bh=sTe6ngf+AsnH5mbfoVSouz2eY2gj/YXgYXK8uBgbk/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUlKgS5LLuFEP/q3+5nV5aMv9HNEqvjhmdd661k7EEr9sY2eE/0Q/pSjNBWh+qui9
	 S5LgssBJrxB0IsrVdYkVkTT4ADwlDGdshnkwRmq/PBNG10jhPbbVq1ZeVf7GbiAw9r
	 T231UYm8OcysTe6FrpVqOf7HFiOklWpfGX7L7Sdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 160/331] selftests/bpf: test widening for iterating callbacks
Date: Mon, 29 Jan 2024 09:03:44 -0800
Message-ID: <20240129170019.613584498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 9f3330aa644d6d979eb064c46e85c62d4b4eac75 upstream.

A test case to verify that imprecise scalars widening is applied to
callback entering state, when callback call is simulated repeatedly.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231121020701.26440-10-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c |   20 ++++++++++
 1 file changed, 20 insertions(+)

--- a/tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c
+++ b/tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c
@@ -25,6 +25,7 @@ struct buf_context {
 
 struct num_context {
 	__u64 i;
+	__u64 j;
 };
 
 __u8 choice_arr[2] = { 0, 1 };
@@ -69,6 +70,25 @@ int unsafe_on_zero_iter(void *unused)
 	return choice_arr[loop_ctx.i];
 }
 
+static int widening_cb(__u32 idx, struct num_context *ctx)
+{
+	++ctx->i;
+	return 0;
+}
+
+SEC("?raw_tp")
+__success
+int widening(void *unused)
+{
+	struct num_context loop_ctx = { .i = 0, .j = 1 };
+
+	bpf_loop(100, widening_cb, &loop_ctx, 0);
+	/* loop_ctx.j is not changed during callback iteration,
+	 * verifier should not apply widening to it.
+	 */
+	return choice_arr[loop_ctx.j];
+}
+
 static int loop_detection_cb(__u32 idx, struct num_context *ctx)
 {
 	for (;;) {}


