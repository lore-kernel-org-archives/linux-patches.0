Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61BD5237A2;
	Wed, 30 Sep 2026 17:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791013; cv=none; b=UjJjWyVx9T2wRrDCjVaLhNnQZFZDF6gDBA+8dAAMkvwJaouNm1RUDv7JWK6IKNyWltTRPcWFOCU3P8stJEVvjpynoVqWMFFvFL7Cg2dP2tOqK1zxZ5HkWbwZ0HbyLMFaIT4CLR0V5GAfREUSBBeCkT7nrNUT2YUeYbiosEjxKYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791013; c=relaxed/simple;
	bh=LfM8hWp0yYocx8cLfhp7Zc6gkdBhR4TtGoIAX+Drpq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2PYAlx6g+YUaP5Lhpz1tnoFzg3IWZtd0L1VyGmskwuE9QIM2iz2hvX/3FIkDQll5U7CC9zQetCWrqfm+iSGc9hxg+tdYLw/gm7RsmpERfiHsEdKCGAwGWym2za7108yXi3in+waRabigPqqHV/maHSrFbMkDd7SYVtF2bpa0xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Brf5bHiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Brf5bHiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABAA1F000FF;
	Wed, 30 Sep 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791011;
	bh=n0JELUgKbF3A2rk0Tb0Rmbxxtkvv/1Gn1Q92N7jGHI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Brf5bHiEFvM5+virCd7RjhLL4Kww9A3v157eciPZ8awFkNHVFiby0egxJuKjQsYmW
	 qLLOYzsHZZDDgYf2GN0yY95cTpZCJyElci3Uj9Q69t9D6cJlrzAM5F+6KtRxxMfGJP
	 mOoeCOisLBrN6UA7dPcjwxq/jGn4sv1ijZWy7kBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/752] sparc: Disable compat support with LLD
Date: Wed, 30 Sep 2026 17:20:23 +0200
Message-ID: <20260930152401.499056261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1176f0de6a0f4..41338e7b300d1 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -489,6 +489,7 @@ endmenu
 config COMPAT
 	bool
 	depends on SPARC64
+	depends on !LD_IS_LLD
 	default y
 	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
-- 
2.53.0



