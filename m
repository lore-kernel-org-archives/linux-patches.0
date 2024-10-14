Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE196E571;
	Mon, 14 Oct 2024 14:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915949; cv=none; b=rvCGqmyYBH+v7AWRlkkQGjE3aeG2BZpiU2xv8fSj9pWEDh32dHIJGnhwPAoBx3jZoZMdwgUvvsUl28oyiTRvWRvsV8wcB0IRIewy/ZggiE1bqrfC11GQVdCd0h6Q22W+5bWJ6kjyEzkwXlpDSIBhbk41XuDx3Y/9os7UOabzTbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915949; c=relaxed/simple;
	bh=jCCwPxd193T4RNaKuGytM6wLcHuBPrHPAW6Q0K3vD/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCVQr8Grx8g4bxyyu4Bf4DwFACdMObJXwqM/Off7iSPCZGMu8HOC/0ysrpzGcMhloUcARQ+D8hZdzlKxglEOBQBQ9D9H5VHlYUdnXafPd829kDKpoxU9REyCgTt2diLieGAOarEzx5Tq0nr5iTgAAb3tQa7vfQbzO/M+ahzIBlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mom1KAnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mom1KAnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E112C4CEC3;
	Mon, 14 Oct 2024 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915948;
	bh=jCCwPxd193T4RNaKuGytM6wLcHuBPrHPAW6Q0K3vD/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mom1KAnr+zbj8DBs4r8eHDSaiqfwS/hT2eR+pXLPCc7ajFlLx1azig1JJIGkO97W+
	 3bSIGiLroucMBQ50ZtO4WgNycNj7cMXeu8I3qqC7kKZMUCz5Zv5s2dMQKXhvCWhCC+
	 M+G2Ifew0oo9G0jHMXBAcXBTcyFn3NzJj86Ixgg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Cyril Bur <cyrilbur@tenstorrent.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 045/214] riscv: avoid Imbalance in RAS
Date: Mon, 14 Oct 2024 16:18:28 +0200
Message-ID: <20241014141046.748313367@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 8f1534e7440382d118c3d655d3a6014128b2086d ]

Inspired by[1], modify the code to remove the code of modifying ra to
avoid imbalance RAS (return address stack) which may lead to incorret
predictions on return.

Link: https://lore.kernel.org/linux-riscv/20240607061335.2197383-1-cyrilbur@tenstorrent.com/ [1]
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Cyril Bur <cyrilbur@tenstorrent.com>
Link: https://lore.kernel.org/r/20240720170659.1522-1-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index ac2e908d4418d..fefb8e7d957a0 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -239,8 +239,8 @@ SYM_CODE_START(ret_from_fork)
 	jalr s0
 1:
 	move a0, sp /* pt_regs */
-	la ra, ret_from_exception
-	tail syscall_exit_to_user_mode
+	call syscall_exit_to_user_mode
+	j ret_from_exception
 SYM_CODE_END(ret_from_fork)
 
 #ifdef CONFIG_IRQ_STACKS
-- 
2.43.0



