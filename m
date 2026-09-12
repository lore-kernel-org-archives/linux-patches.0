Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9332AD37;
	Sat, 12 Sep 2026 10:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209382; cv=none; b=q+NfLWW+vHm8OPFAQEVCVfTjM6P0doM1+DyUu0oTyK/iDrb76P8hMA47wr4UBObPthRHafpQdaNsCIhmYFHv8gzqBGJWjgjaIhEy22eBMf1Ds57POC0gkzyR0/rUsSrfxr/TECQHBSChSi+Kp/A+7cIvtZKcecnJgNYhPjqtVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209382; c=relaxed/simple;
	bh=Rygk5kyeckAtNmTSJxZkX/pjsgZIYnH/m0IFHu4WtYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dfn7vozaltAmQP7u2fWT7z7+uknscj43vdnT6GzF/Ff0Bw1Ddp5mMcVbw0A3O89Lulk9ARO8vt2LN2DJ77aPqUoWOiLQRwWwe2jxYnYs3Qy8jx6+HkwiB3mAUXMiNZ9QiFzK66jPirwTOTX0tgJqgf8BtZi8fnCw62BNeAOWZ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGSzwsGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGSzwsGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C61F0089A;
	Sat, 12 Sep 2026 10:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209380;
	bh=hMwvdlMW+2Chbjdb6HJNwO5rqpw0K3OSNDjemC9zFug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGSzwsGOusEpXvI9yawitDVemAT0OsB/8O5/P2hl/EGC4VT8vQFj6lAtX3K3ZoQqn
	 yNuUNzDbSUDzjcaI7AtKAFhQbDb3DRD2YZ5rLTJjMiKc9rZi7nDywrs2sySQ+bctt6
	 umcDM8gH2y5NwKUtkblJICh88CvVhCKSmNXk5kxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0809/1518] kselftest/arm64: fp-ptrace: Fix checks for inactive SVE and SSVE regsets
Date: Sat, 12 Sep 2026 08:49:38 +0200
Message-ID: <20260912065641.736849217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit bd290e7fc245f9f85607f305fe8213c6c47a416c ]

The checks on the header size reported for the inactive regset of the
NT_ARM_SVE/NT_ARM_SSVE pair compare it against sizeof(sve), but sve is
a struct user_sve_header *, so this is 8 rather than the intended 16.
The kernel carried the identical typo when filling in the header, so
kernel and test agreed on the wrong value and the test passed.

Compare against sizeof(*sve), stop after the header checks for an
inactive regset since it has no payload to compare, and prefill the
buffer with a sentinel to verify that reading an inactive regset
leaves everything after the header untouched. This also covers the
getter's return value, which determines how many bytes ptrace copies
back to userspace.

Fixes: 864f3ddcd715 ("kselftest/arm64: fp-ptrace: Adjust to new inactive mode behaviour")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/fp-ptrace.c | 47 +++++++++++++++++---
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/arm64/fp/fp-ptrace.c b/tools/testing/selftests/arm64/fp/fp-ptrace.c
index a85c19e9524e1..c3fcd47e33968 100644
--- a/tools/testing/selftests/arm64/fp/fp-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/fp-ptrace.c
@@ -65,6 +65,9 @@
 /* VL 128..2048 in powers of 2 */
 #define MAX_NUM_VLS 5
 
+/* Sentinel for detecting buffer bytes the kernel did not write */
+#define REGSET_SENTINEL 0xa5
+
 /*
  * FPMR bits we can set without doing feature checks to see if values
  * are valid.
@@ -181,6 +184,20 @@ static bool compare_buffer(const char *name, void *out,
 	return false;
 }
 
+static bool buffer_is_filled(const void *buffer, size_t size,
+			     unsigned char value)
+{
+	const unsigned char *bytes = buffer;
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		if (bytes[i] != value)
+			return false;
+	}
+
+	return true;
+}
+
 struct test_config {
 	int sve_vl_in;
 	int sve_vl_expected;
@@ -401,6 +418,7 @@ static bool check_ptrace_values_sve(pid_t child, struct test_config *config)
 	struct user_sve_header *sve;
 	struct user_fpsimd_state *fpsimd;
 	struct iovec iov;
+	size_t buf_size;
 	int ret, vq;
 	bool pass = true;
 
@@ -409,14 +427,16 @@ static bool check_ptrace_values_sve(pid_t child, struct test_config *config)
 
 	vq = __sve_vq_from_vl(config->sve_vl_in);
 
-	iov.iov_len = SVE_PT_SVE_OFFSET + SVE_PT_SVE_SIZE(vq, SVE_PT_REGS_SVE);
-	iov.iov_base = malloc(iov.iov_len);
+	buf_size = SVE_PT_SVE_OFFSET + SVE_PT_SVE_SIZE(vq, SVE_PT_REGS_SVE);
+	iov.iov_len = buf_size;
+	iov.iov_base = malloc(buf_size);
 	if (!iov.iov_base) {
 		ksft_print_msg("OOM allocating %lu byte SVE buffer\n",
 			       iov.iov_len);
 		return false;
 	}
 
+	memset(iov.iov_base, REGSET_SENTINEL, buf_size);
 	ret = ptrace(PTRACE_GETREGSET, child, NT_ARM_SVE, &iov);
 	if (ret != 0) {
 		ksft_print_msg("Failed to read initial SVE: %s (%d)\n",
@@ -440,10 +460,16 @@ static bool check_ptrace_values_sve(pid_t child, struct test_config *config)
 	}
 
 	if (svcr_in & SVCR_SM) {
-		if (sve->size != sizeof(sve)) {
+		if (sve->size != sizeof(*sve)) {
 			ksft_print_msg("NT_ARM_SVE reports data with PSTATE.SM\n");
 			pass = false;
 		}
+		if (!buffer_is_filled(iov.iov_base + sizeof(*sve),
+				      buf_size - sizeof(*sve), REGSET_SENTINEL)) {
+			ksft_print_msg("NT_ARM_SVE wrote beyond its header with PSTATE.SM\n");
+			pass = false;
+		}
+		goto out;
 	} else {
 		if (sve->size != SVE_PT_SIZE(vq, sve->flags)) {
 			ksft_print_msg("Mismatch in SVE header size: %d != %lu\n",
@@ -485,6 +511,7 @@ static bool check_ptrace_values_ssve(pid_t child, struct test_config *config)
 	struct user_sve_header *sve;
 	struct user_fpsimd_state *fpsimd;
 	struct iovec iov;
+	size_t buf_size;
 	int ret, vq;
 	bool pass = true;
 
@@ -493,14 +520,16 @@ static bool check_ptrace_values_ssve(pid_t child, struct test_config *config)
 
 	vq = __sve_vq_from_vl(config->sme_vl_in);
 
-	iov.iov_len = SVE_PT_SVE_OFFSET + SVE_PT_SVE_SIZE(vq, SVE_PT_REGS_SVE);
-	iov.iov_base = malloc(iov.iov_len);
+	buf_size = SVE_PT_SVE_OFFSET + SVE_PT_SVE_SIZE(vq, SVE_PT_REGS_SVE);
+	iov.iov_len = buf_size;
+	iov.iov_base = malloc(buf_size);
 	if (!iov.iov_base) {
 		ksft_print_msg("OOM allocating %lu byte SSVE buffer\n",
 			       iov.iov_len);
 		return false;
 	}
 
+	memset(iov.iov_base, REGSET_SENTINEL, buf_size);
 	ret = ptrace(PTRACE_GETREGSET, child, NT_ARM_SSVE, &iov);
 	if (ret != 0) {
 		ksft_print_msg("Failed to read initial SSVE: %s (%d)\n",
@@ -523,10 +552,16 @@ static bool check_ptrace_values_ssve(pid_t child, struct test_config *config)
 	}
 
 	if (!(svcr_in & SVCR_SM)) {
-		if (sve->size != sizeof(sve)) {
+		if (sve->size != sizeof(*sve)) {
 			ksft_print_msg("NT_ARM_SSVE reports data without PSTATE.SM\n");
 			pass = false;
 		}
+		if (!buffer_is_filled(iov.iov_base + sizeof(*sve),
+				      buf_size - sizeof(*sve), REGSET_SENTINEL)) {
+			ksft_print_msg("NT_ARM_SSVE wrote beyond its header without PSTATE.SM\n");
+			pass = false;
+		}
+		goto out;
 	} else {
 		if (sve->size != SVE_PT_SIZE(vq, sve->flags)) {
 			ksft_print_msg("Mismatch in SSVE header size: %d != %lu\n",
-- 
2.53.0



