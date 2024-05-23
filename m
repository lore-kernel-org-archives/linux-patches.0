Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD091D545;
	Thu, 23 May 2024 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470832; cv=none; b=P6+f+PESaKv/h+wM4oK0Iqflnfzb8bkBD17+gG3vfUk5ARUYgdjnRMFkd+q/bfIGppl4H8V5f1AyGdnsEPbhv2wQYv/AgqbCsPID+qXiP7RcaiQQ6loLPc+Sh+i9krIZIpH3UFTSylossmcI3qDhAuIt4VqOqQ0/LEo+zespido=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470832; c=relaxed/simple;
	bh=u6VTWi9tbt9J2AzlcQV0VrMfgub8cwFl/V/SOHCbp2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPQcB33rKAOOQfFxJfds8/OTMjf6orY6PpXFNG02Wzll7OfHwbno3ivabdtYBiPrwCx7vqTSXaTIILie5adXlJPD/XRVyIoHajVq6orckHGK3UnbwrxBkN8u4h7M6LVYoIuI8Zc3an39Z77wF9kEURbfsBa3OsNegmpm5StrYmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRVyttiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRVyttiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA96C2BD10;
	Thu, 23 May 2024 13:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470832;
	bh=u6VTWi9tbt9J2AzlcQV0VrMfgub8cwFl/V/SOHCbp2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRVyttiGa4U2yekaMJEtTLWvT8vArI4H7jf9eE3JHZGN4G/DLxAlr/GjDXvurpgd8
	 4KW6dM8HMNl+9J+9oNwPj6ANtVnuBtcFeyr8pvYIOkbKoWK2w8aPwmCzM8InApW4ZO
	 bHyB3lK54tMCZ3iaUx3RclzebdoVzP9gk8SLS0Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Edward Liaw <edliaw@google.com>
Subject: [PATCH 6.6 085/102] kselftest: Add a ksft_perror() helper
Date: Thu, 23 May 2024 15:13:50 +0200
Message-ID: <20240523130345.675393858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 907f33028871fa7c9a3db1efd467b78ef82cce20 upstream.

The standard library perror() function provides a convenient way to print
an error message based on the current errno but this doesn't play nicely
with KTAP output. Provide a helper which does an equivalent thing in a KTAP
compatible format.

nolibc doesn't have a strerror() and adding the table of strings required
doesn't seem like a good fit for what it's trying to do so when we're using
that only print the errno.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 071af0c9e582 ("selftests: timers: Convert posix_timers test to generate KTAP output")
Signed-off-by: Edward Liaw <edliaw@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kselftest.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -48,6 +48,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdarg.h>
+#include <string.h>
 #include <stdio.h>
 #include <sys/utsname.h>
 #endif
@@ -156,6 +157,19 @@ static inline void ksft_print_msg(const
 	va_end(args);
 }
 
+static inline void ksft_perror(const char *msg)
+{
+#ifndef NOLIBC
+	ksft_print_msg("%s: %s (%d)\n", msg, strerror(errno), errno);
+#else
+	/*
+	 * nolibc doesn't provide strerror() and it seems
+	 * inappropriate to add one, just print the errno.
+	 */
+	ksft_print_msg("%s: %d)\n", msg, errno);
+#endif
+}
+
 static inline void ksft_test_result_pass(const char *msg, ...)
 {
 	int saved_errno = errno;


