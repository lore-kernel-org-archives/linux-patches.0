Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8A4128816;
	Tue, 30 Apr 2024 10:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474656; cv=none; b=qf2M9+cwSLYPZCcW27WkuMpdVpvrUotnVyLN4t1pkgWWAQ+wqdWXsQZk1gilVjARwMTUz8CCu4kaqLs3wuY9O/h6+TA/wFLBorDPlXj1N8kynlRZteGcRN7+Bp/n8L9MmfzFo6OAO8rebi95wTbX62Q+96qJPUYraNLA/VQKU/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474656; c=relaxed/simple;
	bh=WMfvIpjnDsdbCIEZvwI410ILxwMxzDo+VbOFQo2H7jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7IDaYQ5bnD6DAYrily9rHxEFE3QzdUcZFvPsRMQNSOOz7GXsjMfD/mKYEwnbJFgWFbYai4/tTTXzInAoXSZMq5BfolRNZ5UO+kJ1uaucNha1+r7BdaRDaDF7nEY3K0uDiYFt1g7Pb0VNV9fCHwXRX52EhAGC7ptVU1BClWl4J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShwTEWRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShwTEWRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591D7C4AF19;
	Tue, 30 Apr 2024 10:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474656;
	bh=WMfvIpjnDsdbCIEZvwI410ILxwMxzDo+VbOFQo2H7jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShwTEWRWa/XdCK+re/8oyh0vCuyn/gjqKfGG9dfWqt15W6YSSRcDuSWpQ4ZHBsxTJ
	 jab0E1kFityo0pghpGDdexKshnsYDQVaATfiIROnadsOx14p/Yg14F5mFROlcZ6uxu
	 /5gARfpRKAyJKjGqGjoqqF9aMp4MpdCOIi/LOcxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 221/228] riscv: hwprobe: fix invalid sign extension for RISCV_HWPROBE_EXT_ZVFHMIN
Date: Tue, 30 Apr 2024 12:39:59 +0200
Message-ID: <20240430103110.180657241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 5ea6764d9095e234b024054f75ebbccc4f0eb146 ]

The current definition yields a negative 32bits signed value which
result in a mask with is obviously incorrect. Replace it by using a
1ULL bit shift value to obtain a single set bit mask.

Fixes: 5dadda5e6a59 ("riscv: hwprobe: export Zvfh[min] ISA extensions")
Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240409143839.558784-1-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/uapi/asm/hwprobe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 9f2a8e3ff2048..2902f68dc913a 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -54,7 +54,7 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZFHMIN	(1 << 28)
 #define		RISCV_HWPROBE_EXT_ZIHINTNTL	(1 << 29)
 #define		RISCV_HWPROBE_EXT_ZVFH		(1 << 30)
-#define		RISCV_HWPROBE_EXT_ZVFHMIN	(1 << 31)
+#define		RISCV_HWPROBE_EXT_ZVFHMIN	(1ULL << 31)
 #define		RISCV_HWPROBE_EXT_ZFA		(1ULL << 32)
 #define		RISCV_HWPROBE_EXT_ZTSO		(1ULL << 33)
 #define		RISCV_HWPROBE_EXT_ZACAS		(1ULL << 34)
-- 
2.43.0



