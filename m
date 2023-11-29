Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CC24CB3A;
	Wed, 29 Nov 2023 22:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJ0ns3++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD26C433C8;
	Wed, 29 Nov 2023 22:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701296277;
	bh=74LhTABn8Ubk9ieFOEy4R2tqnyjhM65THl7KF6XezcQ=;
	h=From:Subject:Date:To:Cc:From;
	b=FJ0ns3++bDvTJv2QiKG6+uBAGDj1tXwgdo3WbTd4SdVxCjJi7UVchGzodADzaa7zL
	 LUu6tWED79+8CBYqJ5UD7q0HanJKxzxY8HMVO9l+ik19WiPEiDtf5OBsJV3wLfZlxD
	 16ers0Gu6hariCkPLzBbsV1TCkhYADvrRZwF59ymqqDMNU97v1Rwm34qbGfxYxLZ/a
	 kuhquA0M97bLojh/onnhvWUP95sqZMy/J9PbBio/B2j2g+shje0G7SsDLiP1Ky5K9y
	 Ol93UO8LzebkG8Y7akzg84Esa1dsfnX6W7Z51VPsiWx8MkilGZTQ9WDMMVuZjlF/Ok
	 EsETNx2TdLMZw==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v3 0/3] x86: Support llvm-objdump in instruction decoder
 selftest
Date: Wed, 29 Nov 2023 15:17:40 -0700
Message-Id: <20231129-objdump-reformat-llvm-v3-0-0d855e79314d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIS4Z2UC/zXMQQ6CMBCF4auYWTukLYjgynsYFwUGqOlQMgViJ
 NzdxsTln5f37RBJHEW4nXYQ2lx0YUqRn0/QjnYaCF2XGowyudamxtC8upVnFOqDsF3Q+43RdFf
 d1H2hbGsgfec0u/fPfTxT9xIYl1HI/jWjE6dqVegqM1VRXkrUGC2v5D+0kNwHts5nbWA4ji8mU
 LRXpwAAAA==
To: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, ndesaulniers@google.com, keescook@chromium.org, 
 samuelzeter@gmail.com, mhiramat@kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2017; i=nathan@kernel.org;
 h=from:subject:message-id; bh=74LhTABn8Ubk9ieFOEy4R2tqnyjhM65THl7KF6XezcQ=;
 b=kA0DAAoWHWsmkXHAGpYByyZiAGVnuJOiilSy2BoDFgBjpMRKBBqEOrK2JR4ehGkacCdsQefA5
 4h1BAAWCgAdFiEEe+MlxzExnM0B2MqSHWsmkXHAGpYFAmVnuJMACgkQHWsmkXHAGpY5KgEA+tGu
 d7E0XT4d9u36JifpCqz/Z+T+oT12r4IJf1pZ4gAA/0V71W427HPPA9xFQ30j4g8lyxtM8KmvfNr
 ETl+co/cI
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

I have taken up this series from Sam to try and drive this forward.

Currently, the instruction decoder selftest does not work with
llvm-objdump because chkobjdump.awk is GNU binutils specific.
chkobjdump.awk can be eliminated altogether because the minimum
supported version of GNU binutils has been bumped to 2.25.

However, with chkobjdump.awk removed, the selftest does not actually
work properly with llvm-objdump:

  $ make -skj"$(nproc)" LLVM=1 defconfig
  $ scripts/config -e X86_DECODER_SELFTEST
  $ make -skj"$(nproc)" LLVM=1 olddefconfig bzImage
  ...
  arch/x86/tools/insn_decoder_test: warning: objdump says 0 bytes, but insn_get_length() says 2
  ...

Upon inspection it turned out llvm-objdump was formatting its output
differently, which caused objdump_reformat.awk to incorrectly output its
values.

After fixing that bug, a second one was seen where the instruction
"wait" was incorrectly matched with "fwait", which again caused
insn_decoder_test to fail.

Changes in v3:
- Further commit message and cover letter formatting and improvements.
- Add patch 3, which is the ultimate catalyst for the first two changes
- Link to v2: https://lore.kernel.org/r/20221112090418.284656-1-samuelzeter@gmail.com/

Changes in v2:
- Coding style commit message amendments
- Link to v1: https://lore.kernel.org/r/20220106023606.283953-1-samuelzeter@gmail.com/

---
Nathan Chancellor (1):
      x86/tools: Remove chkobjdump.awk

Samuel Zeter (2):
      x86/tools: objdump_reformat.awk: Ensure regex matches fwait
      x86/tools: objdump_reformat.awk: Allow for spaces

 arch/x86/tools/Makefile             |  2 +-
 arch/x86/tools/chkobjdump.awk       | 34 ----------------------------------
 arch/x86/tools/objdump_reformat.awk |  4 ++--
 3 files changed, 3 insertions(+), 37 deletions(-)
---
base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
change-id: 20231129-objdump-reformat-llvm-2d71b9f40ac2

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

