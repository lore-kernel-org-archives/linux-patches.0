Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB311C6AB;
	Mon,  4 Mar 2024 21:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588413; cv=none; b=Cr6De88WSV8o178yofqUsTtoSwcd3V4EZnGgAhVTSeV8Fw4kQHdcRTj2mFUu824eNHqgOnXGwHM7NkmqW4HPf40aMqNu8tMmarszrc3N/ChKBXxPOcvQQggzofCozESgVJiId+K9IcCKNRyFTecCeCg1lo8sj143U0zU871BmSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588413; c=relaxed/simple;
	bh=tKzvwcFIkIev3AQnqS0CwZTVXOI5nuuL7SHscmlfsYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZAOueG6b86YeTPKk5yBetWRo++lq2mimnFxmyYoFzjkisWa8v/fnlsBPPbW+f4V1kjpeoy/GpUc7xUUqdsV9WVtZklIEBrb/Gf1HavGbeiKa6wV0qzGCoXeAWkmW/ZGwujf9TwCbtc4Rj4G5T6p3Vk48SiomL145JjgFMmb6zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TReKj8fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TReKj8fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0259EC433F1;
	Mon,  4 Mar 2024 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588413;
	bh=tKzvwcFIkIev3AQnqS0CwZTVXOI5nuuL7SHscmlfsYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TReKj8fqokfYiJpSzjL/KqXvOELqX1aZYt6qYiduXhLBBKP3UEzjivwXiDlDjflI3
	 wQwk+ZtaSbyBtQvtBWAUu1ssRulmxSs0+qg+vTVLeYs+Fig9Uhj0AIiyS52c7skXeo
	 AYjx6mhZ9rMxeQD9nr52ot2TYxL8QDF2/RgDlWmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Andy Chiu <andybnac@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 097/143] RISC-V: Drop invalid test from CONFIG_AS_HAS_OPTION_ARCH
Date: Mon,  4 Mar 2024 21:23:37 +0000
Message-ID: <20240304211553.013618744@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

commit 3aff0c459e77ac0fb1c4d6884433467f797f7357 upstream.

Commit e4bb020f3dbb ("riscv: detect assembler support for .option arch")
added two tests, one for a valid value to '.option arch' that should
succeed and one for an invalid value that is expected to fail to make
sure that support for '.option arch' is properly detected because Clang
does not error when '.option arch' is not supported:

  $ clang --target=riscv64-linux-gnu -Werror -x assembler -c -o /dev/null <(echo '.option arch, +m')
  /dev/fd/63:1:9: warning: unknown option, expected 'push', 'pop', 'rvc', 'norvc', 'relax' or 'norelax'
  .option arch, +m
          ^
  $ echo $?
  0

Unfortunately, the invalid test started being accepted by Clang after
the linked llvm-project change, which causes CONFIG_AS_HAS_OPTION_ARCH
and configurations that depend on it to be silently disabled, even
though those versions do support '.option arch'.

The invalid test can be avoided altogether by using
'-Wa,--fatal-warnings', which will turn all assembler warnings into
errors, like '-Werror' does for the compiler:

  $ clang --target=riscv64-linux-gnu -Werror -Wa,--fatal-warnings -x assembler -c -o /dev/null <(echo '.option arch, +m')
  /dev/fd/63:1:9: error: unknown option, expected 'push', 'pop', 'rvc', 'norvc', 'relax' or 'norelax'
  .option arch, +m
          ^
  $ echo $?
  1

The as-instr macros have been updated to make use of this flag, so
remove the invalid test, which allows CONFIG_AS_HAS_OPTION_ARCH to work
for all compiler versions.

Cc: stable@vger.kernel.org
Fixes: e4bb020f3dbb ("riscv: detect assembler support for .option arch")
Link: https://github.com/llvm/llvm-project/commit/3ac9fe69f70a2b3541266daedbaaa7dc9c007a2a
Reported-by: Eric Biggers <ebiggers@kernel.org>
Closes: https://lore.kernel.org/r/20240121011341.GA97368@sol.localdomain/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Eric Biggers <ebiggers@google.com>
Tested-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20240125-fix-riscv-option-arch-llvm-18-v1-2-390ac9cc3cd0@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -287,7 +287,6 @@ config AS_HAS_OPTION_ARCH
 	# https://reviews.llvm.org/D123515
 	def_bool y
 	depends on $(as-instr, .option arch$(comma) +m)
-	depends on !$(as-instr, .option arch$(comma) -i)
 
 source "arch/riscv/Kconfig.socs"
 source "arch/riscv/Kconfig.errata"


