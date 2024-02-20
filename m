Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CCC152DE5;
	Tue, 20 Feb 2024 21:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463739; cv=none; b=ix5/AuIo2jh4bTQ+NT6i8jlGtRvrY1GWwJmxzvgFV1NqAmBXTj2Sx1Mq8R9ExlqRKfPi2TNIPngLD/a3lSZWxpDfCjb8qwg5aSmx0/rGrOWwWAqZqbCWolJqEG/0W0DpvTYpmjBovigC2I7w8I0xRT1McPZhScamKxYnBJRWf44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463739; c=relaxed/simple;
	bh=k4m8Cqca5O4Edtu7UYbB9gGDnbwzq2d6UflaVhTEQps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPnZHvScc6ldtDvp5paR2OAV5uzdA5cbPZpj/hLfcLz9RI7EnPn4H7f914emydhMOcTFa1u2M3SwoNY9Zh6q28euoWwAiZAlX8bnlbjW2rO6hFZE97rvHf6ln7nUbDCqUR2MzxyNCkGKoqLj2F4/w/OnLplA6dFKfFMEx4hQKp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oelMB7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oelMB7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EF4C433F1;
	Tue, 20 Feb 2024 21:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463739;
	bh=k4m8Cqca5O4Edtu7UYbB9gGDnbwzq2d6UflaVhTEQps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0oelMB7Dc8CEqzabkHu3M+C9yKfLWNQHIM33RIk+jdRQVS1eHrrGthjYr4c/MbFOs
	 vZZ3TE4acBKz75o23Lxg6QvSzGO4iCf7UnQCFoklApwmbAJe4vQa6h7BDpv0LB7B2y
	 or3UxyGtYp+UhAFXEdv2l9T+2L3qt71b7I4UmtAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.6 137/331] modpost: Add .ltext and .ltext.* to TEXT_SECTIONS
Date: Tue, 20 Feb 2024 21:54:13 +0100
Message-ID: <20240220205641.868796447@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 397586506c3da005b9333ce5947ad01e8018a3be upstream.

After the linked LLVM change, building ARCH=um defconfig results in a
segmentation fault in modpost. Prior to commit a23e7584ecf3 ("modpost:
unify 'sym' and 'to' in default_mismatch_handler()"), there was a
warning:

  WARNING: modpost: vmlinux.o(__ex_table+0x88): Section mismatch in reference to the .ltext:(unknown)
  WARNING: modpost: The relocation at __ex_table+0x88 references
  section ".ltext" which is not in the list of
  authorized sections.  If you're adding a new section
  and/or if this reference is valid, add ".ltext" to the
  list of authorized sections to jump to on fault.
  This can be achieved by adding ".ltext" to
  OTHER_TEXT_SECTIONS in scripts/mod/modpost.c.

The linked LLVM change moves global objects to the '.ltext' (and
'.ltext.*' with '-ffunction-sections') sections with '-mcmodel=large',
which ARCH=um uses. These sections should be handled just as '.text'
and '.text.*' are, so add them to TEXT_SECTIONS.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/1981
Link: https://github.com/llvm/llvm-project/commit/4bf8a688956a759b7b6b8d94f42d25c13c7af130
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -812,7 +812,8 @@ static void check_section(const char *mo
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.*", ".sched.text", \
-		".kprobes.text", ".cpuidle.text", ".noinstr.text"
+		".kprobes.text", ".cpuidle.text", ".noinstr.text", \
+		".ltext", ".ltext.*"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", \
 		".coldtext", ".softirqentry.text"


