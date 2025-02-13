Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD8338389;
	Thu, 13 Feb 2025 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457707; cv=none; b=DufXazwqgp4mcMmO/U9yyhVOn8KUWXnMV7NORMwBwvjjs04BPayiATrq82uY+jKCVrhgX+4+M0NZnKE+51SeV+7m0o98zJsN/z2Bffc10LQpYqq/UJ4/ud9bMQMrHjj4OALdRulhwInRu05a7c+CbuF5z1CEzB30uwNEEs1nP+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457707; c=relaxed/simple;
	bh=N4lKFpxBYlYcZhOz+PqE5lHhGLoqwI7hoBKWldB6Obw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASSbYCZhIcOsV0N/2JPpE6Jq11z+sW0qtj/8E4sKfnDE2v5CnaV+PAWkbFkEBLlC+bkI8A/LOA6ZZUgPuEyzsP1MxcClZvURow5OLoPgpuMGTY2rhnfS2n2mKQQoSypUwr2GQjOfP7Np1Li4YxoQXhggQo/ZY+r6LmlSb5hqrS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgE3cElu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgE3cElu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFDEC4CED1;
	Thu, 13 Feb 2025 14:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457707;
	bh=N4lKFpxBYlYcZhOz+PqE5lHhGLoqwI7hoBKWldB6Obw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgE3cElufKTXbQ0DVF10R4O7iao9pcExQyo30iEhU9jXBv9YEGqde8JXmCBDRigFW
	 p7UTI2FGNR8w5owr3v3ExF0otKtabHB42+oW79LlohcTFOJ8v1ZBq/nGyn7pCcxlLO
	 ccUVNl3u9hGdQKqBXMU8sSBToM2GApibEgilWf6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Buchbinder <rafi@rbk.io>,
	Eyal Birger <eyal.birger@gmail.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.12 189/422] seccomp: passthrough uretprobe systemcall without filtering
Date: Thu, 13 Feb 2025 15:25:38 +0100
Message-ID: <20250213142443.840424031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Birger <eyal.birger@gmail.com>

commit cf6cb56ef24410fb5308f9655087f1eddf4452e6 upstream.

When attaching uretprobes to processes running inside docker, the attached
process is segfaulted when encountering the retprobe.

The reason is that now that uretprobe is a system call the default seccomp
filters in docker block it as they only allow a specific set of known
syscalls. This is true for other userspace applications which use seccomp
to control their syscall surface.

Since uretprobe is a "kernel implementation detail" system call which is
not used by userspace application code directly, it is impractical and
there's very little point in forcing all userspace applications to
explicitly allow it in order to avoid crashing tracked processes.

Pass this systemcall through seccomp without depending on configuration.

Note: uretprobe is currently only x86_64 and isn't expected to ever be
supported in i386.

Fixes: ff474a78cef5 ("uprobe: Add uretprobe syscall to speed up return probe")
Reported-by: Rafael Buchbinder <rafi@rbk.io>
Closes: https://lore.kernel.org/lkml/CAHsH6Gs3Eh8DFU0wq58c_LF8A4_+o6z456J7BidmcVY2AqOnHQ@mail.gmail.com/
Link: https://lore.kernel.org/lkml/20250121182939.33d05470@gandalf.local.home/T/#me2676c378eff2d6a33f3054fed4a5f3afa64e65b
Link: https://lore.kernel.org/lkml/20250128145806.1849977-1-eyal.birger@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Link: https://lore.kernel.org/r/20250202162921.335813-2-eyal.birger@gmail.com
[kees: minimized changes for easier backporting, tweaked commit log]
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/seccomp.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -749,6 +749,15 @@ static bool seccomp_is_const_allow(struc
 	if (WARN_ON_ONCE(!fprog))
 		return false;
 
+	/* Our single exception to filtering. */
+#ifdef __NR_uretprobe
+#ifdef SECCOMP_ARCH_COMPAT
+	if (sd->arch == SECCOMP_ARCH_NATIVE)
+#endif
+		if (sd->nr == __NR_uretprobe)
+			return true;
+#endif
+
 	for (pc = 0; pc < fprog->len; pc++) {
 		struct sock_filter *insn = &fprog->filter[pc];
 		u16 code = insn->code;
@@ -1023,6 +1032,9 @@ static inline void seccomp_log(unsigned
  */
 static const int mode1_syscalls[] = {
 	__NR_seccomp_read, __NR_seccomp_write, __NR_seccomp_exit, __NR_seccomp_sigreturn,
+#ifdef __NR_uretprobe
+	__NR_uretprobe,
+#endif
 	-1, /* negative terminated */
 };
 


