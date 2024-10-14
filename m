Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763F21AAE02;
	Mon, 14 Oct 2024 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916845; cv=none; b=ETfknoDyB6+gN1MA98oOrBvyiLv7mVtrNYuIZSNgzrCamNn6uBZfKFq6ORpJT2Dz5z5XOiGzJdCQFRBfacOxlicoaKaqw02cufFPeVFOMqsq8ej+kKXtKEldun2Rez7Df7twr/Ogyqh97BRVyb45E7vExEjUwrNLZIurytrxox0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916845; c=relaxed/simple;
	bh=x08vG0fTSPW1ZqUObQmiKfH9Rxh46tF6HLgVPccN3w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNKMN/BO3QflWuARUiHuqrtEvutGu2bbuElShoXKGJ+u98DCqK1vKhCUvmC9w4nT7/haJTvVHTuWVyBIRMGfOvka9YzX2nQ+vBuLzsvQlg9X8qYnyw2q81RYKv1quu7KlGgE/v788Y4A6LlT7GiAL425JzjY8sYSowpv+GH30JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRAslA6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRAslA6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692E4C4CEC3;
	Mon, 14 Oct 2024 14:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916845;
	bh=x08vG0fTSPW1ZqUObQmiKfH9Rxh46tF6HLgVPccN3w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRAslA6Vv4mk8B0ZZRa6CBzq65vVevkj5bs/A/Ren1JiXi9zinHWnyshXgyhFwMsx
	 F6C/puiqI8VjrR3xk75ySpxbT04C54yJTGqGRAVyh3Rg1zTRWHAENQRj/Be9zF2Y0Z
	 k1/QX2HhHQbhp1LAZKV1D/R69TfFyRLiqfbFWKuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Cyril Bur <cyrilbur@tenstorrent.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/213] riscv: avoid Imbalance in RAS
Date: Mon, 14 Oct 2024 16:19:47 +0200
Message-ID: <20241014141046.140595341@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
index ed7baf2cf7e87..1f90fee24a8ba 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -219,8 +219,8 @@ SYM_CODE_START(ret_from_fork)
 	jalr s0
 1:
 	move a0, sp /* pt_regs */
-	la ra, ret_from_exception
-	tail syscall_exit_to_user_mode
+	call syscall_exit_to_user_mode
+	j ret_from_exception
 SYM_CODE_END(ret_from_fork)
 
 /*
-- 
2.43.0



