Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F82188A1E;
	Tue, 10 Sep 2024 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962284; cv=none; b=efAdqWMtWMXgeHcFglAiZ/RAzH2Q9NUBrYJcKSumYjmmpT/RgMsuPBeNEjMCJZkBReuaCioPe/7WAfqXcpEpoMXvO89LwgVOboWLBVh9j78cbAbLsysdiXlkk+OpPI1RafzHddimCR5h4QY1UIg3rc1amznhWEEurE5q/oqWimI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962284; c=relaxed/simple;
	bh=Z3baw4p3LQqNsy1Rx9pUBXUw/AS2zmZ64f7TUkC7FFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNmIb5y0SXJG3pL3MEO5nSxKS+azlTmbXis1UQ96h6iv3OB+NJkt1lof/lvUj0Esq2L85wSCMpF/wIhMX0XzWKES9dhUP6mzgFQCTWQktfni7YJnAcQQM9qWGKw5FyRPaaeAq2nLE0lLQ5s71ZESCjF7fcoo++0dBYBt0umN4I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afuLcrD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afuLcrD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F61CC4CEC3;
	Tue, 10 Sep 2024 09:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962284;
	bh=Z3baw4p3LQqNsy1Rx9pUBXUw/AS2zmZ64f7TUkC7FFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afuLcrD92sgk+R9Ct1aYWb+7/r1mz68MzTH8e1YWC+EgsQotkUavryOTgXFp9Mns8
	 iEKDHDKu6qpMUfcllONRLWwcy6AUuOOeXE0soopLfScBk7aA/ncU3a8ClhZkMQPePI
	 IsBOarKx1hUQtIUDT7pqRoO3/NhN3AkcHedTAa70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Blanchard <antonb@tenstorrent.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 358/375] riscv: Fix toolchain vector detection
Date: Tue, 10 Sep 2024 11:32:35 +0200
Message-ID: <20240910092634.630835135@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0525ee2d63c7..006232b67b46 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -545,8 +545,8 @@ config RISCV_ISA_SVPBMT
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



