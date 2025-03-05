Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FE71A5BB7;
	Wed,  5 Mar 2025 18:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198323; cv=none; b=iFBy324WYrZuRR0tUTsRRqJRadL1OYEMWNV6jqBUXnywqxj7nDFNBWETnYp1t0cUI6C0ppLtEWp/jQo7YBND59qJ5kZr1+ynmiUrrds4YpjoBr1ZE4womuu5V/cagDUxe+2uZ8KWfSeNKMrChY98des/9ey+iRUGjntJGZY2vfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198323; c=relaxed/simple;
	bh=wQym7W+gAblvX0Pm4Jcq9wYuNUeBmi5b+FetBvXFG2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um0KavySQGh4wH6SQYaszuG4qEY/ZaLYkBASCNP7G8mIiwCBESh0zbWYV5MzplmMkJJFCW6UzpbUts5O/HLC3T08vMEvaxV5+kWxwPNSYhpgqu3qeYzVTQFpPNLYj0oQoCzSm4MFPEQTkdA59S+iSnJh7EiwWVGbj8DHHKwBciQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpJWqig3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpJWqig3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAC1C4CEE9;
	Wed,  5 Mar 2025 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198323;
	bh=wQym7W+gAblvX0Pm4Jcq9wYuNUeBmi5b+FetBvXFG2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpJWqig3NhwxdNvzLG11THDmwYY5ZiieXR883l1HE0ODHJzoBiFVSCHoOMPTiK3QM
	 CgKlPt3dmVTTWs1yvYb3g71xhd8clrZN5ogPtXn03cUjTkzW6nT9s/bBH4rbZLspAh
	 cF856nLaNYMk98qslYd3+Sn1jZUv/TtriKBSeAxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Zong Li <zong.li@sifive.com>,
	Andy Chiu <andybnac@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.12 139/150] riscv: signal: fix signal_minsigstksz
Date: Wed,  5 Mar 2025 18:49:28 +0100
Message-ID: <20250305174509.400036440@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

commit 564fc8eb6f78e01292ff10801f318feae6153fdd upstream.

The init_rt_signal_env() funciton is called before the alternative patch
is applied, so using the alternative-related API to check the availability
of an extension within this function doesn't have the intended effect.
This patch reorders the init_rt_signal_env() and apply_boot_alternatives()
to get the correct signal_minsigstksz.

Fixes: e92f469b0771 ("riscv: signal: Report signal frame size to userspace via auxv")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241220083926.19453-3-yongxuan.wang@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -288,8 +288,8 @@ void __init setup_arch(char **cmdline_p)
 
 	riscv_init_cbo_blocksizes();
 	riscv_fill_hwcap();
-	init_rt_signal_env();
 	apply_boot_alternatives();
+	init_rt_signal_env();
 
 	if (IS_ENABLED(CONFIG_RISCV_ISA_ZICBOM) &&
 	    riscv_isa_extension_available(NULL, ZICBOM))


