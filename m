Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8981509BF;
	Tue, 20 Feb 2024 21:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462962; cv=none; b=arIC9x3c8FM/0vMfFDBNZeN02TzmX0tXhMRSRPdkfgUi+97qnS8XyFwPAB+qnBTVoNh4ox5Y6dGmmF72Bixlt4MyH6YpdS0yVD//27cD4hQXtKZpGF84g7ZAeSrCYnvjYEkwoDsH/5HgL4xqp/E0qbuCZPJp6eF+ERFLlvuRvnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462962; c=relaxed/simple;
	bh=DF3MjrnKLlckyGfyYrv9Q1Ct8sMVMUXs5NRmN3YkuUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxYD8U5e0+MjrOp52JN1T6BcaSUXOdy/KDyuWzW/zHxwFka8StJSD1qzED3wbQTIYyyMDHz4Ycmtg5wMGiVMLFLA4tqNVf+DtsRXbwtxU1aRKkJJhisLJMepF6c1w5o7izgFuvFdIMKw081dX3dieEAQ9MjB3jKcuyuRtz4ay2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01+lcsl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01+lcsl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41ECC433C7;
	Tue, 20 Feb 2024 21:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462962;
	bh=DF3MjrnKLlckyGfyYrv9Q1Ct8sMVMUXs5NRmN3YkuUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01+lcsl80Mj8slUMp6ONHiX7TSV8LEbWkv944kZQ7I5kntiGAOMzmdF9PRw2vZagY
	 neSDmSi28/LaRzdhmELeC6eg3ZNwuuASe5K83wULW8CQ1Kr1bi8QHWoYQRCkof1WRv
	 tx3sdDFl5j22G1J9QKn+VSVc/lOuD00mK8ZKimak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 091/197] modpost: Add .ltext and .ltext.* to TEXT_SECTIONS
Date: Tue, 20 Feb 2024 21:50:50 +0100
Message-ID: <20240220204843.809772604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -825,7 +825,8 @@ static void check_section(const char *mo
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.*", ".sched.text", \
-		".kprobes.text", ".cpuidle.text", ".noinstr.text"
+		".kprobes.text", ".cpuidle.text", ".noinstr.text", \
+		".ltext", ".ltext.*"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", \
 		".coldtext", ".softirqentry.text"


