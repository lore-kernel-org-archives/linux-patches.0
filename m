Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB2178C90;
	Mon, 14 Oct 2024 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917358; cv=none; b=UeXQp062o/GouyEr8cPrnFMtccQEzRqvpKu0hZQ4sk3R6LGgnfE4yU0u58nZ8u0leDnuw23DmXg7qAZsH364J0RR/9+jH4+q44bk67C92N3Bc6unbYa1+kC5LkH4b87m/Cq7knxqP96ufM31T9tWff5obaaqcX0feg8w87W2kBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917358; c=relaxed/simple;
	bh=acKKgsrfv872iUxBDZAyLqlANcBL1U7SRHSWQsGB/aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Deg4aaG3+16c6TpJ64q3kQVivWGI34yTgLC2ZqWTG6EX9Wr54F1kLEzF3XoVfstt+WKupGjq8FD31yVBobKA+Tl43bhLX43hXXAL3nLcl8oft48rt7hd3ZM+aMYnBtMdMxVQLFSZhxgkOAiEbbKWlKLX5Jwmn7RhuHScJIN4Ofc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjt/XZbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjt/XZbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EFBC4CEC3;
	Mon, 14 Oct 2024 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917358;
	bh=acKKgsrfv872iUxBDZAyLqlANcBL1U7SRHSWQsGB/aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjt/XZbwXy8jMyFLMZJrjocWCnIHLeNN38E+065oj+MgGjvvGHyx36wvOFojU9+x0
	 wDJumWKwlvAVT2fI1mgREv+ANJBD+ZUAZuujI/NP0mrXq3lVUOfCFXvyJbrA+8D0m0
	 TzKT4cT3IdnbRzSFLzuD1UXFZmPeipI0rgiIxK8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/798] kselftest/arm64: Verify simultaneous SSVE and ZA context generation
Date: Mon, 14 Oct 2024 16:09:28 +0200
Message-ID: <20241014141218.510357109@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit bc69da5ff087c40d1fc4f30596f1ee1b71924577 ]

Add a test that generates SSVE and ZA context in a single signal frame to
ensure that nothing is going wrong in that case for any reason.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20230117-arm64-test-ssve-za-v1-2-203c00150154@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 5225b6562b9a ("kselftest/arm64: signal: fix/refactor SVE vector length enumeration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/signal/testcases/ssve_za_regs.c     | 162 ++++++++++++++++++
 1 file changed, 162 insertions(+)
 create mode 100644 tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c

diff --git a/tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c b/tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c
new file mode 100644
index 0000000000000..954a21f6121a2
--- /dev/null
+++ b/tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 ARM Limited
+ *
+ * Verify that both the streaming SVE and ZA register context in
+ * signal frames is set up as expected when enabled simultaneously.
+ */
+
+#include <signal.h>
+#include <ucontext.h>
+#include <sys/prctl.h>
+
+#include "test_signals_utils.h"
+#include "testcases.h"
+
+static union {
+	ucontext_t uc;
+	char buf[1024 * 128];
+} context;
+static unsigned int vls[SVE_VQ_MAX];
+unsigned int nvls = 0;
+
+static bool sme_get_vls(struct tdescr *td)
+{
+	int vq, vl;
+
+	/*
+	 * Enumerate up to SVE_VQ_MAX vector lengths
+	 */
+	for (vq = SVE_VQ_MAX; vq > 0; --vq) {
+		vl = prctl(PR_SME_SET_VL, vq * 16);
+		if (vl == -1)
+			return false;
+
+		vl &= PR_SME_VL_LEN_MASK;
+
+		/* Skip missing VLs */
+		vq = sve_vq_from_vl(vl);
+
+		vls[nvls++] = vl;
+	}
+
+	/* We need at least one VL */
+	if (nvls < 1) {
+		fprintf(stderr, "Only %d VL supported\n", nvls);
+		return false;
+	}
+
+	return true;
+}
+
+static void setup_regs(void)
+{
+	/* smstart sm; real data is TODO */
+	asm volatile(".inst 0xd503437f" : : : );
+
+	/* smstart za; real data is TODO */
+	asm volatile(".inst 0xd503457f" : : : );
+}
+
+static char zeros[ZA_SIG_REGS_SIZE(SVE_VQ_MAX)];
+
+static int do_one_sme_vl(struct tdescr *td, siginfo_t *si, ucontext_t *uc,
+			 unsigned int vl)
+{
+	size_t offset;
+	struct _aarch64_ctx *head = GET_BUF_RESV_HEAD(context);
+	struct _aarch64_ctx *regs;
+	struct sve_context *ssve;
+	struct za_context *za;
+	int ret;
+
+	fprintf(stderr, "Testing VL %d\n", vl);
+
+	ret = prctl(PR_SME_SET_VL, vl);
+	if (ret != vl) {
+		fprintf(stderr, "Failed to set VL, got %d\n", ret);
+		return 1;
+	}
+
+	/*
+	 * Get a signal context which should have the SVE and ZA
+	 * frames in it.
+	 */
+	setup_regs();
+	if (!get_current_context(td, &context.uc, sizeof(context)))
+		return 1;
+
+	regs = get_header(head, SVE_MAGIC, GET_BUF_RESV_SIZE(context),
+			  &offset);
+	if (!regs) {
+		fprintf(stderr, "No SVE context\n");
+		return 1;
+	}
+
+	ssve = (struct sve_context *)regs;
+	if (ssve->vl != vl) {
+		fprintf(stderr, "Got SSVE VL %d, expected %d\n", ssve->vl, vl);
+		return 1;
+	}
+
+	if (!(ssve->flags & SVE_SIG_FLAG_SM)) {
+		fprintf(stderr, "SVE_SIG_FLAG_SM not set in SVE record\n");
+		return 1;
+	}
+
+	fprintf(stderr, "Got expected SSVE size %u and VL %d\n",
+		regs->size, ssve->vl);
+
+	regs = get_header(head, ZA_MAGIC, GET_BUF_RESV_SIZE(context),
+			  &offset);
+	if (!regs) {
+		fprintf(stderr, "No ZA context\n");
+		return 1;
+	}
+
+	za = (struct za_context *)regs;
+	if (za->vl != vl) {
+		fprintf(stderr, "Got ZA VL %d, expected %d\n", za->vl, vl);
+		return 1;
+	}
+
+	fprintf(stderr, "Got expected ZA size %u and VL %d\n",
+		regs->size, za->vl);
+
+	/* We didn't load any data into ZA so it should be all zeros */
+	if (memcmp(zeros, (char *)za + ZA_SIG_REGS_OFFSET,
+		   ZA_SIG_REGS_SIZE(sve_vq_from_vl(za->vl))) != 0) {
+		fprintf(stderr, "ZA data invalid\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int sme_regs(struct tdescr *td, siginfo_t *si, ucontext_t *uc)
+{
+	int i;
+
+	for (i = 0; i < nvls; i++) {
+		if (do_one_sme_vl(td, si, uc, vls[i]))
+			return 1;
+	}
+
+	td->pass = 1;
+
+	return 0;
+}
+
+struct tdescr tde = {
+	.name = "Streaming SVE registers",
+	.descr = "Check that we get the right Streaming SVE registers reported",
+	/*
+	 * We shouldn't require FA64 but things like memset() used in the
+	 * helpers might use unsupported instructions so for now disable
+	 * the test unless we've got the full instruction set.
+	 */
+	.feats_required = FEAT_SME | FEAT_SME_FA64,
+	.timeout = 3,
+	.init = sme_get_vls,
+	.run = sme_regs,
+};
-- 
2.43.0



