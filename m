Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9B432C95F;
	Fri, 17 Oct 2025 15:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713269; cv=none; b=MRwV5Wcu9DsGO6lH+NFNBlbuBd9XA0RX5FapxC8KNCq6SRpiBudLGOGU2pF+iBbDvAFr39UG3m2fhcFZ6lIQcAk63Dmr1bD0E89aO0IoFYnRmbBWgD/WtJTKWGCcKDDK3CX5N8RrYMIaLFB8CqHraXsaCp35uIn6wWWGSlwU5bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713269; c=relaxed/simple;
	bh=jw/AbJxykaJO4Tk6qygruA4e5gLqIewdkxjIjkvNcQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6eTd55q43+1tpOHY0ah/VuiWIzhQ8UI4cJUeVPYLz9gSRmgdzXb6Jvh2QGha9rMNZr93nyXknd8noasFIzdx5I9e7C727PzakKyb+14eAivPwj8f47+gRKSpZ0Addps6rsHK/IIszpAprgRCkXuHERRzR2ZBwVMyhmasRBk1KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLhoZ1Dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLhoZ1Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB6AC116D0;
	Fri, 17 Oct 2025 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713268;
	bh=jw/AbJxykaJO4Tk6qygruA4e5gLqIewdkxjIjkvNcQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLhoZ1DvR6id3T2uu5weKuz2N+/zgeeutjT2ZIb9u1aUBz+CLWw/80blJZckl2AO1
	 ohCyaNbnDuLJnNURI/TJoEB3OlAAZ1k7vtTguvjGw5D+z4DzyWDhRk99dIJcH+Ceb7
	 BrLS9OOFkatsHrCS7tn76AAqvblJeJm6M3rluxsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Weimer <fweimer@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 6.1 107/168] rseq/selftests: Use weak symbol reference, not definition, to link with glibc
Date: Fri, 17 Oct 2025 16:53:06 +0200
Message-ID: <20251017145132.967404353@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,9 +38,9 @@
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
@@ -124,7 +124,7 @@ void rseq_init(void)
 	 * libc not having registered a restartable sequence.  Try to find the
 	 * symbols if that's the case.
 	 */
-	if (!*libc_rseq_size_p) {
+	if (!libc_rseq_size_p || !*libc_rseq_size_p) {
 		libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
 		libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
 		libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");


