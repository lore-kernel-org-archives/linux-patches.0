Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA116166D;
	Mon, 29 Jan 2024 17:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548075; cv=none; b=XwyxKQNKcSDj35J+BNi7QbjhQXnOrKCObFH26CiXZLI2Aq9po0+wPJ7kQnqrjUSKBrFEMhVxqTwbFFUnJOIoq6zfOLOTB4eua3GMcBZIFu5I1m/fZoDbR5ESpjlEJqpvO3Sj5Kvgt7D/eECGx5XNOzc6sInch55j84eb/1AXMrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548075; c=relaxed/simple;
	bh=GE3mqNHyFnD0ZrOXrHofPaX4rHMEGBIqLWQnrxwVkOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFP9O4TKiQecTxwv0wmQ1pDho25wjSQgJx5z9dPGUCyZdqT3S32n+OMcro0bsvyH4LXsPKSG+QgLVmh0hgaTqiOr08SbN53wUOxWDJJhZmJuDjyL8l2gWQlBqkJr6Q6xZ1FpSHGAHA4NY6wKZZaqlezIBaZbqOQrMSJT1s1MlOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHS0qo+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHS0qo+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C68C433C7;
	Mon, 29 Jan 2024 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548075;
	bh=GE3mqNHyFnD0ZrOXrHofPaX4rHMEGBIqLWQnrxwVkOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHS0qo+vk55AX07dcYG7aEGdpoSDCOL++kBrxy2E9SboKuh6bBtasiuR1cOll1Xds
	 vcs9hzRmRLIFBoUgmqMRs1nRnBAwHp9zVxHI/TIzeNqQ2RYSVe0r/ZXgNVOcxzt2LS
	 sZRosVt2ywYmgurCHswQwnYfpZCfPKaMdcSs++WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 059/346] riscv: Fix an off-by-one in get_early_cmdline()
Date: Mon, 29 Jan 2024 09:01:30 -0800
Message-ID: <20240129170018.132310615@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit adb1f95d388a43c4c564ef3e436f18900dde978e ]

The ending NULL is not taken into account by strncat(), so switch to
strlcat() to correctly compute the size of the available memory when
appending CONFIG_CMDLINE to 'early_cmdline'.

Fixes: 26e7aacb83df ("riscv: Allow to downgrade paging mode from the command line")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/9f66d2b58c8052d4055e90b8477ee55d9a0914f9.1698564026.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/pi/cmdline_early.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/pi/cmdline_early.c b/arch/riscv/kernel/pi/cmdline_early.c
index 68e786c84c94..f6d4dedffb84 100644
--- a/arch/riscv/kernel/pi/cmdline_early.c
+++ b/arch/riscv/kernel/pi/cmdline_early.c
@@ -38,8 +38,7 @@ static char *get_early_cmdline(uintptr_t dtb_pa)
 	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
 	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
 	    fdt_cmdline_size == 0 /* CONFIG_CMDLINE_FALLBACK */) {
-		strncat(early_cmdline, CONFIG_CMDLINE,
-			COMMAND_LINE_SIZE - fdt_cmdline_size);
+		strlcat(early_cmdline, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
 	}
 
 	return early_cmdline;
-- 
2.43.0



