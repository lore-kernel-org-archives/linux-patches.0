Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75000332907;
	Fri, 17 Oct 2025 15:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713420; cv=none; b=NMajXOJoRLHL/213NPnQD9qi8bOPOSc+QGiK+cMD6qTiEs2AEKyCNU5fxORN/MKQ2oCP93sWUUsTpgg2JdNnrAVtv6Ayvc3ndLnFsEeQxgxUl1eWECoGlN+DqTsUXVp1+sKUk4VeVh+9xz60QCKyc5MOhV7BFmnxHeVOtMxdz0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713420; c=relaxed/simple;
	bh=vQ8DU6G1+n/KSHZaFhWCwa7+1Y+ajtZqAXKIX3H5ATs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFo2S7lJbUyRlO2GJBETF3eN46mVJBldGfBQxq9itCYJSTUhSiRh9UdYgg6gI6h2scVlMbA3ri7o0mOlhniw6/FdMETANFc+uRwZOPGdHulm+rt5qVoyjl7Q1jwm1IXx/eEh2Td0+MYweCqcMsz87rFiAAY21JbFYjaG0SpLfTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Izd11bGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Izd11bGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58CEC4CEE7;
	Fri, 17 Oct 2025 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713420;
	bh=vQ8DU6G1+n/KSHZaFhWCwa7+1Y+ajtZqAXKIX3H5ATs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Izd11bGZDNcG5GDwKJjnBc03ZwMM5Q2uBCR1kCIwOTMTrNo14Ee2lDTR0QgBJ+7yf
	 ezTEcguZCptkuYd2R8018WDeP+0p+L4PqLuAWkO8Sr/k92an6XufDNHn2tdzEPW9da
	 z0Gmh0Jc1TEJRLnK/CnrHpXnz6YlitvX80FcgrrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/168] asm-generic/io.h: suppress endianness warnings for relaxed accessors
Date: Fri, 17 Oct 2025 16:53:57 +0200
Message-ID: <20251017145134.867889832@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 05d3855b4d21ef3c2df26be1cbba9d2c68915fcb ]

Copy the forced type casts from the normal MMIO accessors to suppress
the sparse warnings that point out __raw_readl() returns a native endian
word (just like readl()).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Stable-dep-of: 8327bd4fcb6c ("asm-generic/io.h: Skip trace helpers if rwmmio events are disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/io.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -319,7 +319,7 @@ static inline u16 readw_relaxed(const vo
 	u16 val;
 
 	log_read_mmio(16, addr, _THIS_IP_, _RET_IP_);
-	val = __le16_to_cpu(__raw_readw(addr));
+	val = __le16_to_cpu((__le16 __force)__raw_readw(addr));
 	log_post_read_mmio(val, 16, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -332,7 +332,7 @@ static inline u32 readl_relaxed(const vo
 	u32 val;
 
 	log_read_mmio(32, addr, _THIS_IP_, _RET_IP_);
-	val = __le32_to_cpu(__raw_readl(addr));
+	val = __le32_to_cpu((__le32 __force)__raw_readl(addr));
 	log_post_read_mmio(val, 32, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -345,7 +345,7 @@ static inline u64 readq_relaxed(const vo
 	u64 val;
 
 	log_read_mmio(64, addr, _THIS_IP_, _RET_IP_);
-	val = __le64_to_cpu(__raw_readq(addr));
+	val = __le64_to_cpu((__le64 __force)__raw_readq(addr));
 	log_post_read_mmio(val, 64, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -366,7 +366,7 @@ static inline void writeb_relaxed(u8 val
 static inline void writew_relaxed(u16 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
-	__raw_writew(cpu_to_le16(value), addr);
+	__raw_writew((u16 __force)cpu_to_le16(value), addr);
 	log_post_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
@@ -376,7 +376,7 @@ static inline void writew_relaxed(u16 va
 static inline void writel_relaxed(u32 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
-	__raw_writel(__cpu_to_le32(value), addr);
+	__raw_writel((u32 __force)__cpu_to_le32(value), addr);
 	log_post_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
@@ -386,7 +386,7 @@ static inline void writel_relaxed(u32 va
 static inline void writeq_relaxed(u64 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
-	__raw_writeq(__cpu_to_le64(value), addr);
+	__raw_writeq((u64 __force)__cpu_to_le64(value), addr);
 	log_post_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
 }
 #endif


