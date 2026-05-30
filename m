Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDC13546F6;
	Sat, 30 May 2026 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161437; cv=none; b=AaiRr/P7nOci+kP4Xnk72l+czI0z2+pfRRILzQluBg9zIAESRA6qw+6Jt4BRGTb++JWOUvW/fClI/pdUtGyxuuwuMhLNpyZQ6Zm464XS69TLl17GhGiz9OqciiX7mm2nrPREOnaBL4i2KQgrsz0SVglFJf1jpIdhkOC0SQD7yq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161437; c=relaxed/simple;
	bh=P3CKKG5sbuC+dLYC3qDeHQfaufkxyh3fU5kQ2KjxnHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=napDTdkbDzJaswFsqYDIBq1/ToHVDjqhNMIXtwu4gbyKd4sB10qiu6Og6gjdV+qZ9JPu+I4dOcSn7jtj0EZypw9IvjupBN088IYwHv29ufnJgEa3HzPoY7AI8l1wUcHMdEY3N41HmXFR7XtJFNd9bH169FZlmxkYj/3oW0EQ1yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWexbPk2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWexbPk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3489A1F00893;
	Sat, 30 May 2026 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161436;
	bh=hr1AZOhNcQyHq2ixEjArvZ9gIGf89zYG6lVEGeRYjI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWexbPk2SPNtf3jCw5iHD1MwGAx9a3Tcy1HwfC9PY+IwfWrf/fBNJxIWyOm8EJDFR
	 vgNcDR4+TAC7jGmugWcSKlsLsddnznf4E0fnEs6zWYp7/OFIdqbun7TH9AfA4uhXsk
	 AjbRYZBXcETudaKQoa6WcpSYjAdmSfIkehDfHFcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihan Ding <dingyihan@uniontech.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 623/969] bpf: allow UTF-8 literals in bpf_bprintf_prepare()
Date: Sat, 30 May 2026 18:02:27 +0200
Message-ID: <20260530160317.645321480@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Yihan Ding <dingyihan@uniontech.com>

[ Upstream commit b960430ea8862ef37ce53c8bf74a8dc79d3f2404 ]

bpf_bprintf_prepare() only needs ASCII parsing for conversion
specifiers. Plain text can safely carry bytes >= 0x80, so allow
UTF-8 literals outside '%' sequences while keeping ASCII control
bytes rejected and format specifiers ASCII-only.

This keeps existing parsing rules for format directives unchanged,
while allowing helpers such as bpf_trace_printk() to emit UTF-8
literal text.

Update test_snprintf_negative() in the same commit so selftests keep
matching the new plain-text vs format-specifier split during bisection.

Fixes: 48cac3f4a96d ("bpf: Implement formatted output helpers with bstr_printf")
Signed-off-by: Yihan Ding <dingyihan@uniontech.com>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260416120142.1420646-2-dingyihan@uniontech.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c                            | 17 ++++++++++++++++-
 .../testing/selftests/bpf/prog_tests/snprintf.c |  3 ++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index be9dc396537f1..a19524c672012 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -840,7 +840,13 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 		data->buf = buffers->buf;
 
 	for (i = 0; i < fmt_size; i++) {
-		if ((!isprint(fmt[i]) && !isspace(fmt[i])) || !isascii(fmt[i])) {
+		unsigned char c = fmt[i];
+
+		/*
+		 * Permit bytes >= 0x80 in plain text so UTF-8 literals can pass
+		 * through unchanged, while still rejecting ASCII control bytes.
+		 */
+		if (isascii(c) && !isprint(c) && !isspace(c)) {
 			err = -EINVAL;
 			goto out;
 		}
@@ -862,6 +868,15 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 		 * always access fmt[i + 1], in the worst case it will be a 0
 		 */
 		i++;
+		c = fmt[i];
+		/*
+		 * The format parser below only understands ASCII conversion
+		 * specifiers and modifiers, so reject non-ASCII after '%'.
+		 */
+		if (!isascii(c)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		/* skip optional "[0 +-][num]" width formatting field */
 		while (fmt[i] == '0' || fmt[i] == '+'  || fmt[i] == '-' ||
diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf.c b/tools/testing/selftests/bpf/prog_tests/snprintf.c
index 4be6fdb78c6a1..20a3c622bd28a 100644
--- a/tools/testing/selftests/bpf/prog_tests/snprintf.c
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf.c
@@ -114,7 +114,8 @@ static void test_snprintf_negative(void)
 	ASSERT_ERR(load_single_snprintf("%--------"), "invalid specifier 5");
 	ASSERT_ERR(load_single_snprintf("%lc"), "invalid specifier 6");
 	ASSERT_ERR(load_single_snprintf("%llc"), "invalid specifier 7");
-	ASSERT_ERR(load_single_snprintf("\x80"), "non ascii character");
+	ASSERT_OK(load_single_snprintf("\x80"), "non ascii plain text");
+	ASSERT_ERR(load_single_snprintf("%\x80"), "non ascii in specifier");
 	ASSERT_ERR(load_single_snprintf("\x1"), "non printable character");
 }
 
-- 
2.53.0



