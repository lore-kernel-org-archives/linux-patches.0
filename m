Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CDC3233E8;
	Mon, 27 Oct 2025 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591721; cv=none; b=ndM2oFgGAV4d7rwpGcepgfwCOyrv4nl9RqDMLtrATyeTjw4Ku9Le5AH/MhsT5yVYZLaRv5KPmU1orR/R6OntIYvw1Zq0VzsShyLlPdk1LhCLE4lUPgB2ItN+6FLzJug267DWcd9NGqZ7uyDkFflKhulBlOr11+mzHjCO9dxexpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591721; c=relaxed/simple;
	bh=u4vhUo+j1/I09q6cE+Lf48gPZA2YLX+kpmBWoOMUij0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxN9ZBZ6RgGENnwAOLKv/Cx2wAtFFOxRwF65H0AMiT6ujDq35UrsaUf1PzMbLAoHZREeg/UW1dpJtqRrBRbUu47SAG56B91Sgt/mwaWVkl3xrWw+WlZ+NHf38QxQrE2hQ58xe1a/8W0tWC/Z70P5k9x4sjdPfdpceqG5G+CNPKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiiEJOiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiiEJOiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22C7C4CEF1;
	Mon, 27 Oct 2025 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591721;
	bh=u4vhUo+j1/I09q6cE+Lf48gPZA2YLX+kpmBWoOMUij0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiiEJOiHYkKq7n3ITQ8zjbU864p/ecPudE70jxkHCGwhMk4Vek2Ecg3kXeEDlZi/d
	 4HGt+S1a2XeZdTlNY/cNU8SP0hcyfZ6S1EYJ4uC+fh7wF3W3G/BCD7vITN/2AmAhLx
	 Y6UN6hCnFBwYv6GQcRmNGDQhUyk6IrIY30UozSeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/332] m68k: bitops: Fix find_*_bit() signatures
Date: Mon, 27 Oct 2025 19:35:20 +0100
Message-ID: <20251027183531.908165411@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 6d5674090543b89aac0c177d67e5fb32ddc53804 ]

The function signatures of the m68k-optimized implementations of the
find_{first,next}_{,zero_}bit() helpers do not match the generic
variants.

Fix this by changing all non-pointer inputs and outputs to "unsigned
long", and updating a few local variables.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509092305.ncd9mzaZ-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Link: https://patch.msgid.link/de6919554fbb4cd1427155c6bafbac8a9df822c8.1757517135.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/bitops.h | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/m68k/include/asm/bitops.h b/arch/m68k/include/asm/bitops.h
index 10133a968c8e1..d2a9aa0485175 100644
--- a/arch/m68k/include/asm/bitops.h
+++ b/arch/m68k/include/asm/bitops.h
@@ -314,12 +314,12 @@ static inline int bfchg_mem_test_and_change_bit(int nr,
 #include <asm-generic/bitops/ffz.h>
 #else
 
-static inline int find_first_zero_bit(const unsigned long *vaddr,
-				      unsigned size)
+static inline unsigned long find_first_zero_bit(const unsigned long *vaddr,
+						unsigned long size)
 {
 	const unsigned long *p = vaddr;
-	int res = 32;
-	unsigned int words;
+	unsigned long res = 32;
+	unsigned long words;
 	unsigned long num;
 
 	if (!size)
@@ -340,8 +340,9 @@ static inline int find_first_zero_bit(const unsigned long *vaddr,
 }
 #define find_first_zero_bit find_first_zero_bit
 
-static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
-				     int offset)
+static inline unsigned long find_next_zero_bit(const unsigned long *vaddr,
+					       unsigned long size,
+					       unsigned long offset)
 {
 	const unsigned long *p = vaddr + (offset >> 5);
 	int bit = offset & 31UL, res;
@@ -370,11 +371,12 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
 }
 #define find_next_zero_bit find_next_zero_bit
 
-static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
+static inline unsigned long find_first_bit(const unsigned long *vaddr,
+					   unsigned long size)
 {
 	const unsigned long *p = vaddr;
-	int res = 32;
-	unsigned int words;
+	unsigned long res = 32;
+	unsigned long words;
 	unsigned long num;
 
 	if (!size)
@@ -395,8 +397,9 @@ static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
 }
 #define find_first_bit find_first_bit
 
-static inline int find_next_bit(const unsigned long *vaddr, int size,
-				int offset)
+static inline unsigned long find_next_bit(const unsigned long *vaddr,
+					  unsigned long size,
+					  unsigned long offset)
 {
 	const unsigned long *p = vaddr + (offset >> 5);
 	int bit = offset & 31UL, res;
-- 
2.51.0



