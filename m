Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B722EA150;
	Tue, 17 Jun 2025 16:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177071; cv=none; b=X0A4nTk07P6c4/cE1EYxoYXlRbEfyEk1kCJk+nWK+T3y1QulhHrdz/EVD86HjGiPdKpq9FYZDzGZtnNvb0QeUYK3pZGqcuooywlwqYXNE9GMAKOC28SrIigLpyhthojsCG09FNZQLP8BuSdgHjsV0KafEzZ2YvNJLL/toxGGU/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177071; c=relaxed/simple;
	bh=bsFFjW/hOOCfdKjEdASymUoi2LmQjkn89H4GEDpFPww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AElnmLuYbLH9nPyFUQMYRJLY74XLwfPoHEEbPX2v0sLU3cjY0kU22m3twusyXNBBqcPyHoT9DRMKogjIPm+xWYj70TKXyfTyltVRrE3tkLCSCTcGCHbGvE7JCc1pV7HwKEPodRkGO5WndTFqvJMPqFHyS2C30dQ0XFldGxbXRLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oE1Pjsxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oE1Pjsxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB12DC4CEE3;
	Tue, 17 Jun 2025 16:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177071;
	bh=bsFFjW/hOOCfdKjEdASymUoi2LmQjkn89H4GEDpFPww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oE1PjsxoIJbKifrfTLMni6nPZQJT6tQZKX8EisFz7rZTj1P7uM8X2zAJFDb9W+q7P
	 t3a0jqekoRmQGb6XDT+5k/wptfv3+K08o0RBGTyXoTJXbXzemAlr1fJN5POTDjlkT0
	 isIucPRvXGJZKklpfppHUi8gV0cHRETF7BOHLgVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerhorst <luis.gerhorst@fau.de>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 254/780] selftests/bpf: Fix caps for __xlated/jited_unpriv
Date: Tue, 17 Jun 2025 17:19:22 +0200
Message-ID: <20250617152501.802776808@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Gerhorst <luis.gerhorst@fau.de>

[ Upstream commit cf15cdc0f0f39a5c6315200808ec3e3995b0c2d2 ]

Currently, __xlated_unpriv and __jited_unpriv do not work because the
BPF syscall will overwrite info.jited_prog_len and info.xlated_prog_len
with 0 if the process is not bpf_capable(). This bug was not noticed
before, because there is no test that actually uses
__xlated_unpriv/__jited_unpriv.

To resolve this, simply restore the capabilities earlier (but still
after loading the program). Adding this here unconditionally is fine
because the function first checks that the capabilities were initialized
before attempting to restore them.

This will be important later when we add tests that check whether a
speculation barrier was inserted in the correct location.

Signed-off-by: Luis Gerhorst <luis.gerhorst@fau.de>
Fixes: 9c9f73391310 ("selftests/bpf: allow checking xlated programs in verifier_* tests")
Fixes: 7d743e4c759c ("selftests/bpf: __jited test tag to check disassembly after jit")
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20250501073603.1402960-2-luis.gerhorst@fau.de
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_loader.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index 49f2fc61061f5..9551d8d5f8f9f 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -1042,6 +1042,14 @@ void run_subtest(struct test_loader *tester,
 	emit_verifier_log(tester->log_buf, false /*force*/);
 	validate_msgs(tester->log_buf, &subspec->expect_msgs, emit_verifier_log);
 
+	/* Restore capabilities because the kernel will silently ignore requests
+	 * for program info (such as xlated program text) if we are not
+	 * bpf-capable. Also, for some reason test_verifier executes programs
+	 * with all capabilities restored. Do the same here.
+	 */
+	if (restore_capabilities(&caps))
+		goto tobj_cleanup;
+
 	if (subspec->expect_xlated.cnt) {
 		err = get_xlated_program_text(bpf_program__fd(tprog),
 					      tester->log_buf, tester->log_buf_sz);
@@ -1067,12 +1075,6 @@ void run_subtest(struct test_loader *tester,
 	}
 
 	if (should_do_test_run(spec, subspec)) {
-		/* For some reason test_verifier executes programs
-		 * with all capabilities restored. Do the same here.
-		 */
-		if (restore_capabilities(&caps))
-			goto tobj_cleanup;
-
 		/* Do bpf_map__attach_struct_ops() for each struct_ops map.
 		 * This should trigger bpf_struct_ops->reg callback on kernel side.
 		 */
-- 
2.39.5



