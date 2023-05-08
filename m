Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B85210C
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BF4C433D2;
	Mon,  8 May 2023 10:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541136;
	bh=ZFRK8jiGYOCs5wAhqWnSdxJfdodA4PcK7ZFCYNL7ZZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZpvCZNKqvKdcTEWmCZXIbq4ugSZmlf16rQMEMmFmNHxqPpQ/MB/IWTn+rgIYLjRE
	 EUJkZMjvFpJWbhGNqme/urKhsWoeFNQ0iIp0SEpmKp/OV2w5YbfgrF/0il/ZEyiPSW
	 HAAGoWswiNvJdCk2oPT3ScFHh/8JY9Z1DFAGst1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 018/663] asm-generic/io.h: suppress endianness warnings for relaxed accessors
Date: Mon,  8 May 2023 11:37:24 +0200
Message-Id: <20230508094429.015767988@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 05d3855b4d21ef3c2df26be1cbba9d2c68915fcb ]

Copy the forced type casts from the normal MMIO accessors to suppress
the sparse warnings that point out __raw_readl() returns a native endian
word (just like readl()).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/io.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index d78c3056c98f9..587e7e9b9a375 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -319,7 +319,7 @@ static inline u16 readw_relaxed(const volatile void __iomem *addr)
 	u16 val;
 
 	log_read_mmio(16, addr, _THIS_IP_, _RET_IP_);
-	val = __le16_to_cpu(__raw_readw(addr));
+	val = __le16_to_cpu((__le16 __force)__raw_readw(addr));
 	log_post_read_mmio(val, 16, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -332,7 +332,7 @@ static inline u32 readl_relaxed(const volatile void __iomem *addr)
 	u32 val;
 
 	log_read_mmio(32, addr, _THIS_IP_, _RET_IP_);
-	val = __le32_to_cpu(__raw_readl(addr));
+	val = __le32_to_cpu((__le32 __force)__raw_readl(addr));
 	log_post_read_mmio(val, 32, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -345,7 +345,7 @@ static inline u64 readq_relaxed(const volatile void __iomem *addr)
 	u64 val;
 
 	log_read_mmio(64, addr, _THIS_IP_, _RET_IP_);
-	val = __le64_to_cpu(__raw_readq(addr));
+	val = __le64_to_cpu((__le64 __force)__raw_readq(addr));
 	log_post_read_mmio(val, 64, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -366,7 +366,7 @@ static inline void writeb_relaxed(u8 value, volatile void __iomem *addr)
 static inline void writew_relaxed(u16 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
-	__raw_writew(cpu_to_le16(value), addr);
+	__raw_writew((u16 __force)cpu_to_le16(value), addr);
 	log_post_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
@@ -376,7 +376,7 @@ static inline void writew_relaxed(u16 value, volatile void __iomem *addr)
 static inline void writel_relaxed(u32 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
-	__raw_writel(__cpu_to_le32(value), addr);
+	__raw_writel((u32 __force)__cpu_to_le32(value), addr);
 	log_post_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
@@ -386,7 +386,7 @@ static inline void writel_relaxed(u32 value, volatile void __iomem *addr)
 static inline void writeq_relaxed(u64 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
-	__raw_writeq(__cpu_to_le64(value), addr);
+	__raw_writeq((u64 __force)__cpu_to_le64(value), addr);
 	log_post_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
-- 
2.39.2



