Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9265330B2D;
	Fri, 17 Oct 2025 15:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716477; cv=none; b=QW2qyhuCcQO43JLAnfI8vWoZAZ5/3DhqJ6ExuznEJs8kst6qbz1DkD28DnOHPhnOPrnrkIAstGDKdtMoXSjFT5OTyGpHLojUcOTThrYQ6uM6mfhunitQQa6vkdm1ld3jdZoLSJ+tMfrFgW1GcgfOpFxA0BDRjXotr1cUxWSC7gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716477; c=relaxed/simple;
	bh=JwZXfW1ck3W7wxLfrfkEe4w/8iSlcq11uBNgwrYfoGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP0/CIp1uR3khvWo+7dbkq7kZTJ7H8ZIknJZcKWxeFVf6dOFpqhdKvt1rXtYs+cJQdBm5ZWRRy3CdxOoL5iJdxWnpgYu6pYFFan08sHjZPha02AYD7WyvYpnHEhqB+vKTw/J+kp6eg/GoJlSAqbYfVmxL+/VY6uSyJfFA9k9jvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+ju2+OJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+ju2+OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5339CC4CEE7;
	Fri, 17 Oct 2025 15:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716477;
	bh=JwZXfW1ck3W7wxLfrfkEe4w/8iSlcq11uBNgwrYfoGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+ju2+OJSKDaRFcBBjL906LeAXcM6nDHusjInleCWzbklmX2wmJ5MHJRTw/J+P6R1
	 MCfV6oXkzWMktAO6RrSG/+m8oymL94B1WGuRK0CDXyVmLz30n6vEadUYwD59tpdsnO
	 +hV2i/xKNnVyoFmm4U1ikFICEBplQMTyYN/EmnZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Weimer <fweimer@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5.15 204/276] rseq/selftests: Use weak symbol reference, not definition, to link with glibc
Date: Fri, 17 Oct 2025 16:54:57 +0200
Message-ID: <20251017145149.914863674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


