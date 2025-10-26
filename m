Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB7C2DF15E;
	Sun, 26 Oct 2025 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490278; cv=none; b=TWdWg8r+Xp2PU1bJ/2LHRf6rJvKZzzOIZWFORXuTEsXiwNGjGhfsYzAMrDInNgBmK8z5+wbcS5wlGMN4xddS5XpgrdZKSoXNE+WqoORfPXV/Ia3N4GmxEuedv+8WBb4HNsM8DnljDkNGjMxLmyLfMkYZ0kWbiUj5HNDNXlBu4xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490278; c=relaxed/simple;
	bh=CO271cMTHjOrQExKio0CuZqTZM9HnmWERCP1CIEwTxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DS2tIAIW8CJpBDyJAoI+hOhUeryvcDK7sUvZTIzHCPADYvFrgCVCQ1sKxdB1BYrSGmdCG3JcEw8rS0J71dY0DFZhKanyuWwRI82wdot9VnelxSkaqAAHT3ByvqA1kvnjJt2EkHU9AlMN38M0TCCMNHUUFhMoQubihbBN8CsQKEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHt6DLZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHt6DLZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E26C4CEF1;
	Sun, 26 Oct 2025 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490277;
	bh=CO271cMTHjOrQExKio0CuZqTZM9HnmWERCP1CIEwTxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHt6DLZ2DhaqImJ5E7TM/ZEhjagZel+mbWEfsEHMJxYJFEpN/nK4eSloMMaIAHV1k
	 RGttVXLX7yV4SgzGpA7jRS9s5k9SSrlWVK4ZzMXlDrwK4vVv2Qg/lR/b+eYafooRN4
	 U5Dp3lZqInSTBxiyHe5NyjzOhvcdzakiMuP5HgYIGdgacollDJDaaGM58JtkmkNSLJ
	 Fxrs6KmPsXycMRMSPpZGHVu0eL3HNt44heOTYsqXGPwaEFuSPMlvps8NCeTmdfnZXE
	 dAClmlzcpXJh56Z8MYyJ/tZxqrmsVUwSiuC4AsRSerRzAsXQa9grmM1vdxFnv4pUFe
	 ZyYNwbAaa+RyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nsc@kernel.org,
	masahiroy@kernel.org,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.1] kbuild: uapi: Strip comments before size type check
Date: Sun, 26 Oct 2025 10:49:13 -0400
Message-ID: <20251026144958.26750-35-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 66128f4287b04aef4d4db9bf5035985ab51487d5 ]

On m68k, check_sizetypes in headers_check reports:

    ./usr/include/asm/bootinfo-amiga.h:17: found __[us]{8,16,32,64} type without #include <linux/types.h>

This header file does not use any of the Linux-specific integer types,
but merely refers to them from comments, so this is a false positive.
As of commit c3a9d74ee413bdb3 ("kbuild: uapi: upgrade check_sizetypes()
warning to error"), this check was promoted to an error, breaking m68k
all{mod,yes}config builds.

Fix this by stripping simple comments before looking for Linux-specific
integer types.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/949f096337e28d50510e970ae3ba3ec9c1342ec0.1759753998.git.geert@linux-m68k.org
[nathan: Adjust comment and remove unnecessary escaping from slashes in
         regex]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – removing the in-line `/* … */` fragments before running the size-
type regex prevents the false-positive that currently stops m68k
`all{mod,yes}config` builds after the warning was promoted to an error.

- The added substitution in `usr/include/headers_check.pl:152` strips
  same-line block comments so references like `/* size (__be32) */`
  disappear before the `__[us](8|16|32|64)` check, one of which triggers
  today in `arch/m68k/include/uapi/asm/bootinfo-amiga.h` purely from
  comments. Because only the comment text is removed, genuine usages
  (e.g., `__u32 foo;`) remain intact, so real missing-include problems
  are still caught.
- The failure being addressed was introduced by c3a9d74ee413bdb3, which
  turned the diagnostic into an error and now breaks
  headers_check/all*config for m68k; this change is the minimal fix to
  restore buildability.
- The change is tightly scoped (a single Perl substitution), has no
  dependencies, and does not affect kernel runtime behavior, so
  regression risk is negligible.

 usr/include/headers_check.pl | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/usr/include/headers_check.pl b/usr/include/headers_check.pl
index 2b70bfa5558e6..02767e8bf22d0 100755
--- a/usr/include/headers_check.pl
+++ b/usr/include/headers_check.pl
@@ -155,6 +155,8 @@ sub check_sizetypes
 	if (my $included = ($line =~ /^\s*#\s*include\s+[<"](\S+)[>"]/)[0]) {
 		check_include_typesh($included);
 	}
+	# strip single-line comments, as types may be referenced within them
+	$line =~ s@/\*.*?\*/@@;
 	if ($line =~ m/__[us](8|16|32|64)\b/) {
 		printf STDERR "$filename:$lineno: " .
 		              "found __[us]{8,16,32,64} type " .
-- 
2.51.0

