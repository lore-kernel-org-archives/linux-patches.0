Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06AD188CC1;
	Tue, 10 Sep 2024 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961382; cv=none; b=nTE3vyyrzAo1C9WdOR8MM7ALOEDhTaeAKzzOMzTnulkWCvC78G/wOH8w1DvCfQX94eeZiVrvd9WqtEAM1AkvL46qT3LxIg9OuXvj+CMlAWIaRV7aMWB5tT1a1ifpWo3TeMk1aWjq4WoLYevuFIrs7hNF+DhuEeRaWkd5PnIMFZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961382; c=relaxed/simple;
	bh=HeUfKrp9recOQa1Z2dDsqRuM91Z8h4N8ZgyfhKqMqys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioPdEzfcLEJKyn0DPYBcqIff0r0ZAJfFFiJUTk0X/8Mc3V3T7fW/zqKHNI18TVBTCIVQkEAEO8KqE/XJV6m83dt1E17P1Jdg/YlyL3cwNZ9CuaCXq5UsuNc554BOG1BLOBHbpa/Vl60W13ULOzfJjZhN1OiGIFVnszKtsmCPYFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI1Zzbnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI1Zzbnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEFEC4CEC3;
	Tue, 10 Sep 2024 09:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961382;
	bh=HeUfKrp9recOQa1Z2dDsqRuM91Z8h4N8ZgyfhKqMqys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fI1ZzbnwiIhP+hing3fKlqaYoImA2lgoznpqdAOv5tOuxswPS6ZRz0KLakqevMFHl
	 WCLZiWWonERMCWAQYkimjUk5525bZ9U9GB+ocAMvkzHyPVb6dRJbyab0x0YXKmXbqQ
	 gcCteeqmElxJCgQinXJwi6ApLt81H1wRt17mLKxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.10 044/375] riscv: misaligned: Restrict user access to kernel memory
Date: Tue, 10 Sep 2024 11:27:21 +0200
Message-ID: <20240910092623.728873565@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

commit b686ecdeacf6658e1348c1a32a08e2e72f7c0f00 upstream.

raw_copy_{to,from}_user() do not call access_ok(), so this code allowed
userspace to access any virtual memory address.

Cc: stable@vger.kernel.org
Fixes: 7c83232161f6 ("riscv: add support for misaligned trap handling in S-mode")
Fixes: 441381506ba7 ("riscv: misaligned: remove CONFIG_RISCV_M_MODE specific code")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240815005714.1163136-1-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/traps_misaligned.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 192cd5603e95..d4fd8af7aaf5 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -417,7 +417,7 @@ int handle_misaligned_load(struct pt_regs *regs)
 
 	val.data_u64 = 0;
 	if (user_mode(regs)) {
-		if (raw_copy_from_user(&val, (u8 __user *)addr, len))
+		if (copy_from_user(&val, (u8 __user *)addr, len))
 			return -1;
 	} else {
 		memcpy(&val, (u8 *)addr, len);
@@ -515,7 +515,7 @@ int handle_misaligned_store(struct pt_regs *regs)
 		return -EOPNOTSUPP;
 
 	if (user_mode(regs)) {
-		if (raw_copy_to_user((u8 __user *)addr, &val, len))
+		if (copy_to_user((u8 __user *)addr, &val, len))
 			return -1;
 	} else {
 		memcpy((u8 *)addr, &val, len);
-- 
2.46.0



