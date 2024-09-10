Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4630B14D280;
	Tue, 10 Sep 2024 10:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964668; cv=none; b=inZaUqnskkJhbZZ02B6+FBYrcBbInDgR8IfKe0dvY6JzXMUV2J9x/pmqZmEnUCZReHpfRv7U83sEnAvnKaMAMpgxflzYr+/yw7Calx3WD5wcHD5Vq0i22orJcyD8YZtXuKJ6rGzoUxuFhofcPbaDjaRYGG5fYF+V9EOIK0yOpaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964668; c=relaxed/simple;
	bh=sCrs1z6vTtAnWtAGl6uQ+6lnafSpVHRo6X4KtMZ0lPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNyb+wNyFQfDXlJbzSio2ct4+snlkXDjZxA8ylvsLNPD60mpeeaUMZOK7e+4KXJnyhKrB9J01NUpyS4hTsTcePzsvrKkigp0Pi9nS6UTb54b7Fwl7GbPQbdB0nMpAGk0fj2ShuOCYLPs+0JD88htcDwqLE9F/0S0fKIaiBmZ41s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHa+QIaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHa+QIaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CF1C4CEC3;
	Tue, 10 Sep 2024 10:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964668;
	bh=sCrs1z6vTtAnWtAGl6uQ+6lnafSpVHRo6X4KtMZ0lPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHa+QIaCPB5nrLbKihxiGtFB/M6sIJaP+hfzW/cC/1aYe88wCmwLTDJXjQQzHsT/x
	 fHZmORNtfFgN1TepFxLTNSz8tsJO2tiCK+3+HP2rnqwHgUtWOCLu9ogPrQjEaj4650
	 elNTjEfOVRLaoGfoXuZvWwPFrA3s2od8KIb4jXHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Blanchard <antonb@tenstorrent.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/269] riscv: Fix toolchain vector detection
Date: Tue, 10 Sep 2024 11:34:07 +0200
Message-ID: <20240910092617.039728312@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Anton Blanchard <antonb@tenstorrent.com>

[ Upstream commit 5ba7a75a53dffbf727e842b5847859bb482ac4aa ]

A recent change to gcc flags rv64iv as no longer valid:

   cc1: sorry, unimplemented: Currently the 'V' implementation
   requires the 'M' extension

and as a result vector support is disabled. Fix this by adding m
to our toolchain vector detection code.

Signed-off-by: Anton Blanchard <antonb@tenstorrent.com>
Fixes: fa8e7cce55da ("riscv: Enable Vector code to be built")
Link: https://lore.kernel.org/r/20240819001131.1738806-1-antonb@tenstorrent.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index c785a0200573..d5d70dc5656e 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -489,8 +489,8 @@ config RISCV_ISA_SVPBMT
 config TOOLCHAIN_HAS_V
 	bool
 	default y
-	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64iv)
-	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32iv)
+	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64imv)
+	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32imv)
 	depends on LLD_VERSION >= 140000 || LD_VERSION >= 23800
 	depends on AS_HAS_OPTION_ARCH
 
-- 
2.43.0



