Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D356932C931;
	Fri, 17 Oct 2025 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713797; cv=none; b=PMuAcVfP/VheFdzGe+tNFLJD6dpL7O5V8xkxNKDYxEABDFznTS76wPFDUdWSCVyrjG1TLTPByNzQixEgPa3V88r88Z9mxu0wTzv1aLvrk7d/Gyy+5Bbo5ntknVad8PkNLWZvZY6+kAp+cPui7qgNQnS7+YCY+vWlhS7LPS4O0ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713797; c=relaxed/simple;
	bh=g0OADHhe3LKXx7cQlJ54pfPfgs87fTK54XsdE9FcTCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQR/3F+p66Ux5J6LeChRafBwrqBkC6WTxJ7iVaGhFOenq8YRqpPWL9h2aueyzFRRnoaBITl1U+bTmEDxCG1UgATsvsMvHB6Toc6+LyPyKdwbvdiR+X6BD0HDj3NsOu5c8nGFB8vSSSfo+HLsaJySJ6VXu1PMa3lk23YNo9yUimw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMEnEd9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMEnEd9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1FEC4CEE7;
	Fri, 17 Oct 2025 15:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713797;
	bh=g0OADHhe3LKXx7cQlJ54pfPfgs87fTK54XsdE9FcTCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMEnEd9AN5pgmSfjoOaZm22xn7pWvWfPr9P0G70cwYVhcaeNVryFWAWMC7JjpsG/w
	 YfzrQ4Yg8NkYdsyddah6JzYzTW+8Oa07XtZ3b+lbiiS/lWkdBejGFgT5ZGe09hTt72
	 3AqYhC99C2A0nzlDJqg7QvCH1DnK9pCobvIJkEoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Weimer <fweimer@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 6.6 124/201] rseq/selftests: Use weak symbol reference, not definition, to link with glibc
Date: Fri, 17 Oct 2025 16:53:05 +0200
Message-ID: <20251017145139.296760439@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit a001cd248ab244633c5fabe4f7c707e13fc1d1cc upstream.

Add "extern" to the glibc-defined weak rseq symbols to convert the rseq
selftest's usage from weak symbol definitions to weak symbol _references_.
Effectively re-defining the glibc symbols wreaks havoc when building with
-fno-common, e.g. generates segfaults when running multi-threaded programs,
as dynamically linked applications end up with multiple versions of the
symbols.

Building with -fcommon, which until recently has the been the default for
GCC and clang, papers over the bug by allowing the linker to resolve the
weak/tentative definition to glibc's "real" definition.

Note, the symbol itself (or rather its address), not the value of the
symbol, is set to 0/NULL for unresolved weak symbol references, as the
symbol doesn't exist and thus can't have a value.  Check for a NULL rseq
size pointer to handle the scenario where the test is statically linked
against a libc that doesn't support rseq in any capacity.

Fixes: 3bcbc20942db ("selftests/rseq: Play nice with binaries statically linked against glibc 2.35+")
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/87frdoybk4.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/rseq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -40,9 +40,9 @@
  * Define weak versions to play nice with binaries that are statically linked
  * against a libc that doesn't support registering its own rseq.
  */
-__weak ptrdiff_t __rseq_offset;
-__weak unsigned int __rseq_size;
-__weak unsigned int __rseq_flags;
+extern __weak ptrdiff_t __rseq_offset;
+extern __weak unsigned int __rseq_size;
+extern __weak unsigned int __rseq_flags;
 
 static const ptrdiff_t *libc_rseq_offset_p = &__rseq_offset;
 static const unsigned int *libc_rseq_size_p = &__rseq_size;
@@ -198,7 +198,7 @@ void rseq_init(void)
 	 * libc not having registered a restartable sequence.  Try to find the
 	 * symbols if that's the case.
 	 */
-	if (!*libc_rseq_size_p) {
+	if (!libc_rseq_size_p || !*libc_rseq_size_p) {
 		libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
 		libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
 		libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");


