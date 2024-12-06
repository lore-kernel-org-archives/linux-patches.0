Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEDE53A7;
	Fri,  6 Dec 2024 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497452; cv=none; b=hZxwS4Sn46OoMc9ATtzHTPyGw2M0WmmJOo8YU6y73LXRIJH9neG5+59Cd753ft2DSjJvF0DA8h6rhrnVcIzb9HFJPYNFgPJNeVS6GgeudGFC7pJv4tqsH89lDoLVZHJKLUFj/sXrtDQWbBZHm8nylArAd6BeEG/ZSc9aIf3phUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497452; c=relaxed/simple;
	bh=Kr+iWPkFJjxnbqZmO59XvHgDmOk1Emxni5W6EzeiBHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5/R0LziHvVC4yQKWa7nrfa0wWzOSEuD8En6cQDlDLZhM1E2reqvfV72G9/ARifWwAzqskq4wSOLwG8rkfmnWWwUkXl4yyqzORwpAnBftnwROtG3YA6zAf3zhqsjBDRRoWiN157X7S0w1DpKQCwadEQqDIW8Oo0W2Qof3b0vcOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HJ8EUZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HJ8EUZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017C3C4CED1;
	Fri,  6 Dec 2024 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497452;
	bh=Kr+iWPkFJjxnbqZmO59XvHgDmOk1Emxni5W6EzeiBHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HJ8EUZn7us7HySWIg9xmhyky0X0mqKGxgyGvXZFiUHQqzoTO3YVcg5qCboBjNOt7
	 aIlq7lot72z5/KtW5oN7e5IdWaS5IKlBEHNYuGC4AL3poMi16eSdIX9njMR3azsVoT
	 I4AQJbPJbHQNVQW7vjUnratxYfYRtLfKC+5ps+20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Whitcroft <apw@canonical.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Joe Perches <joe@perches.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 297/676] checkpatch: check for missing Fixes tags
Date: Fri,  6 Dec 2024 15:31:56 +0100
Message-ID: <20241206143704.941321370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d5d6281ae8e0c929c3ff188652f5b12c680fe8bf ]

This check looks for common words that probably indicate a patch
is a fix.  For now the regex is:

	(?:(?:BUG: K.|UB)SAN: |Call Trace:|stable\@|syzkaller)/)

Why are stable patches encouraged to have a fixes tag?  Some people mark
their stable patches as "# 5.10" etc.  This is useful but a Fixes tag is
still a good idea.  For example, the Fixes tag helps in review.  It
helps people to not cherry-pick buggy patches without also
cherry-picking the fix.

Also if a bug affects the 5.7 kernel some people will round it up to
5.10+ because 5.7 is not supported on kernel.org.  It's possible the Bad
Binder bug was caused by this sort of gap where companies outside of
kernel.org are supporting different kernels from kernel.org.

Should it be counted as a Fix when a patch just silences harmless
WARN_ON() stack trace.  Yes.  Definitely.

Is silencing compiler warnings a fix?  It seems unfair to the original
authors, but we use -Werror now, and warnings break the build so let's
just add Fixes tags.  I tell people that silencing static checker
warnings is not a fix but the rules on this vary by subsystem.

Is fixing a minor LTP issue (Linux Test Project) a fix?  Probably?  It's
hard to know what to do if the LTP test has technically always been
broken.

One clear false positive from this check is when someone updated their
debug output and included before and after Call Traces.  Or when crashes
are introduced deliberately for testing.  In those cases, you should
just ignore checkpatch.

Link: https://lkml.kernel.org/r/ZmhUgZBKeF_8ixA6@moroto
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2f07b6523849 ("checkpatch: always parse orig_commit in fixes tag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkpatch.pl | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7d16f863edf1c..6b598f0858392 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -28,6 +28,7 @@ my %verbose_messages = ();
 my %verbose_emitted = ();
 my $tree = 1;
 my $chk_signoff = 1;
+my $chk_fixes_tag = 1;
 my $chk_patch = 1;
 my $tst_only;
 my $emacs = 0;
@@ -88,6 +89,7 @@ Options:
   -v, --verbose              verbose mode
   --no-tree                  run without a kernel tree
   --no-signoff               do not check for 'Signed-off-by' line
+  --no-fixes-tag             do not check for 'Fixes:' tag
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
@@ -295,6 +297,7 @@ GetOptions(
 	'v|verbose!'	=> \$verbose,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
+	'fixes-tag!'	=> \$chk_fixes_tag,
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
@@ -1256,6 +1259,7 @@ sub git_commit_info {
 }
 
 $chk_signoff = 0 if ($file);
+$chk_fixes_tag = 0 if ($file);
 
 my @rawlines = ();
 my @lines = ();
@@ -2635,6 +2639,9 @@ sub process {
 
 	our $clean = 1;
 	my $signoff = 0;
+	my $fixes_tag = 0;
+	my $is_revert = 0;
+	my $needs_fixes_tag = "";
 	my $author = '';
 	my $authorsignoff = 0;
 	my $author_sob = '';
@@ -3188,6 +3195,16 @@ sub process {
 			}
 		}
 
+# These indicate a bug fix
+		if (!$in_header_lines && !$is_patch &&
+			$line =~ /^This reverts commit/) {
+			$is_revert = 1;
+		}
+
+		if (!$in_header_lines && !$is_patch &&
+		    $line =~ /((?:(?:BUG: K.|UB)SAN: |Call Trace:|stable\@|syzkaller))/) {
+			$needs_fixes_tag = $1;
+		}
 
 # Check Fixes: styles is correct
 		if (!$in_header_lines &&
@@ -3200,6 +3217,7 @@ sub process {
 			my $id_length = 1;
 			my $id_case = 1;
 			my $title_has_quotes = 0;
+			$fixes_tag = 1;
 
 			if ($line =~ /(\s*fixes:?)\s+([0-9a-f]{5,})\s+($balanced_parens)/i) {
 				my $tag = $1;
@@ -7680,6 +7698,12 @@ sub process {
 		ERROR("NOT_UNIFIED_DIFF",
 		      "Does not appear to be a unified-diff format patch\n");
 	}
+	if ($is_patch && $has_commit_log && $chk_fixes_tag) {
+		if ($needs_fixes_tag ne "" && !$is_revert && !$fixes_tag) {
+			WARN("MISSING_FIXES_TAG",
+				 "The commit message has '$needs_fixes_tag', perhaps it also needs a 'Fixes:' tag?\n");
+		}
+	}
 	if ($is_patch && $has_commit_log && $chk_signoff) {
 		if ($signoff == 0) {
 			ERROR("MISSING_SIGN_OFF",
-- 
2.43.0



