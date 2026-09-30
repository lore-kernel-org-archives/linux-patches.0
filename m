Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225CB4DD3D1;
	Wed, 30 Sep 2026 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784558; cv=none; b=pgyM6a0COso5QYNhBEY6wKKwm0RR8uqPEpFCxmO+6ofpaVOCf7865P5a1bpJji32uvt1v5ht3yMh6LHDnLjDIH/2Cm0PnDC1MPbp+L4tKINpQilOnzHHKJrY638WTsIcm56NJWdJta/MEqEffFZw/C03bvYyu1RIaxDCkGlCfjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784558; c=relaxed/simple;
	bh=OVCEKfBC6t52KWxW5GFftdE0rzILqiz6gHL18BTqItE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qczfl2gF5Tv/pYGmG7+/2Y+af2kIc5bS/5Zszo2yHGVqswaw1u0m48dp8uRe5rqz4/3LlvU/zO6vEOhNmGwC0NICgvd/oFbCUtvwV+Kca46+eGt7pyBP9MROfLBLjqCTDDHqkHNzZPGPsPiebTk2vUR4AXFE9fdTCqY7e0NI9do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xp2klPv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xp2klPv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B581F00A08;
	Wed, 30 Sep 2026 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784552;
	bh=SEM5ZFpI/PAIBXpfSUV5/cHH74WIf7CqgqkOIczv+tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xp2klPv77/tTanT6ixYqrOvWsYZjWI8qM8Oc6zfvF0+YqH766ai/XIRMoosJenAO1
	 FkOF90jeHpSg7qVSQ9QXUq+0HfUVVZULS/4JoTFFVnp2Qx93+7Tl3apJMUmrG8Z8uX
	 uM7/zOrSpDUx/GAsyWbP5F3wnnYl5vX6I4diEuGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/982] sparc: Disable compat support with LLD
Date: Wed, 30 Sep 2026 17:15:31 +0200
Message-ID: <20260930152421.002686605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 852fed2e8bfe195351fb0078ba7245d41154e7a5 ]

An LLVM=1 sparc64 allmodconfig enables COMPAT and then tries to
build the 32-bit vDSO. That path cannot be linked with ld.lld:

  ld.lld: error: unknown emulation: elf32_sparc

ld.lld does not support the 32-bit SPARC ELF emulation used for
the compat vDSO, so keep COMPAT disabled when LLD is the linker.
This avoids selecting an unsupported build path while leaving the
existing GNU ld configuration unchanged.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20260508000834.834824-1-rosenp@gmail.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index b67d96e3392e5..deb664e7d0142 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -487,6 +487,7 @@ endmenu
 config COMPAT
 	bool
 	depends on SPARC64
+	depends on !LD_IS_LLD
 	default y
 	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
-- 
2.53.0



