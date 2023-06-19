Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F6E5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D536C433C0;
	Mon, 19 Jun 2023 10:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171572;
	bh=AgtMoc3hDCvaFoRn4pqUG+5F/TCxfhfutLmB626EauU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+cfR8n8U/7r1wAHNnf+9zp/Xtpc/v16pX28J0XTewkxoVK8saQqjHyMIa7ol8slx
	 IFYc0XDOt1kJ3VdggK52FPhifbDWD+9W1oZ3Cdkz7JQwGBJsaDt38dMAOSk/rB8sfO
	 2DuPcgKqxhhjcwiEy/8R3NptQ71T4gyl5LEOg/As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Baoquan He <bhe@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Young <dyoung@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Philipp Rudo <prudo@redhat.com>,
	Ross Zwisler <zwisler@google.com>,
	Simon Horman <horms@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tom Rix <trix@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 056/166] x86/purgatory: remove PGO flags
Date: Mon, 19 Jun 2023 12:28:53 +0200
Message-ID: <20230619102157.465989008@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

commit 97b6b9cbba40a21c1d9a344d5c1991f8cfbf136e upstream.

If profile-guided optimization is enabled, the purgatory ends up with
multiple .text sections.  This is not supported by kexec and crashes the
system.

Link: https://lkml.kernel.org/r/20230321-kexec_clang16-v7-2-b05c520b7296@chromium.org
Fixes: 930457057abe ("kernel/kexec_file.c: split up __kexec_load_puragory")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: <stable@vger.kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/purgatory/Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -14,6 +14,11 @@ $(obj)/sha256.o: $(srctree)/lib/crypto/s
 
 CFLAGS_sha256.o := -D__DISABLE_EXPORTS
 
+# When profile-guided optimization is enabled, llvm emits two different
+# overlapping text sections, which is not supported by kexec. Remove profile
+# optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%,$(KBUILD_CFLAGS))
+
 # When linking purgatory.ro with -r unresolved symbols are not checked,
 # also link a purgatory.chk binary without -r to check for unresolved symbols.
 PURGATORY_LDFLAGS := -e purgatory_start -z nodefaultlib


