Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D55B253326;
	Wed,  5 Mar 2025 18:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198786; cv=none; b=CUMkWG7rYpiMg59ZmcRofIKRDEehV1QpkACrueUByxYiRVLv4pswLa1PIH16HiYWec1e82uI3cg9h8zrDsGSIcTiWXMaWZ7VcE66IG2na0KVVubYlFpqgL1sVINj8zXgveBKMVzfBD0xuJbUhKSTQPWzq+tItWaErmpuVmStvfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198786; c=relaxed/simple;
	bh=qmRk0N7DZtpDyKGPKzfitTUKHAuNeMybTFYDj1cYNng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuaV1br5DrrmoXGyfpizf1I0uHGzdONDn7Sh1la/qxxGN2OIQxQujWZYJmFGnM4QogVmZsECNjn4uv1FYPs4va8DWXVB+S8yd3yZ+UnozSDSMLBAezZgUcNzBUxOzeftcBZs02H5xQIZ6P5SgUZbRRoONKurVjZ+dLe0sfDVQXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+9zSh6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+9zSh6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282B3C4CED1;
	Wed,  5 Mar 2025 18:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198786;
	bh=qmRk0N7DZtpDyKGPKzfitTUKHAuNeMybTFYDj1cYNng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+9zSh6MvarTxvvNvyFaxYmVD2zEzhjT+cEiicg2nc/EcOdS/pIB4enJTseTPkJy6
	 szilOOZDsGuP2aANWYNagrWPpetiWBEzDwQYQzoYgUOfHuXWSV7zKBspwx4b2Z8krA
	 XJAPIIwsDx3jzWVTGtHsi/LqMSZi8jGl5FOr/cCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Zong Li <zong.li@sifive.com>,
	Andy Chiu <andybnac@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.13 147/157] riscv: signal: fix signal_minsigstksz
Date: Wed,  5 Mar 2025 18:49:43 +0100
Message-ID: <20250305174511.204591598@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -324,8 +324,8 @@ void __init setup_arch(char **cmdline_p)
 
 	riscv_init_cbo_blocksizes();
 	riscv_fill_hwcap();
-	init_rt_signal_env();
 	apply_boot_alternatives();
+	init_rt_signal_env();
 
 	if (IS_ENABLED(CONFIG_RISCV_ISA_ZICBOM) &&
 	    riscv_isa_extension_available(NULL, ZICBOM))


