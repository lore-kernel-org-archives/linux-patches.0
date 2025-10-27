Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352601FBC92;
	Mon, 27 Oct 2025 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592795; cv=none; b=G4ee/XnXHCBF5PEnoB4UNNivzIytrr2d64oeGl1b7iYv+9cyUAZ4cFZ0rTlgs5GMHN4dqAAC4VDwaw9mfWdmZ5SHg6dFnnfOQHwGnmSqMi9BltmwLQwaLKZaET3qE37+gF5j8sRP/o36wr+1sw7g1z/U/6JnV4MxyTogydVZNKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592795; c=relaxed/simple;
	bh=R4lU7XLzFMjYgJC5ErH7eIbmEDczDtokM6nvCeh+6sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/+ppY8ga1qkbeh0w0qyYVnMdYgiw1jcN19uWZuEoiPpM1pjwaAfpB+imRQeksH26eD/I1diTUF6Dp2EguEEnVH9ZaaXmIzwxvu4eSLMd24oP5axQnQltoqzH0T7QZFHTR/PPvZ/M0VCP6OWmZfkzbpSyIiRkbVb49mlpTyGnGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zx4Kn4Xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zx4Kn4Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55DFC4CEF1;
	Mon, 27 Oct 2025 19:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592795;
	bh=R4lU7XLzFMjYgJC5ErH7eIbmEDczDtokM6nvCeh+6sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zx4Kn4XxjQE9PnLPNqi2czbqwsDadepwPMjWhUNbanRCILtpjpLxlWH8kl3oUTEe3
	 Lrd09qIHtFPPDRw4AwvXItp9ahECYTknH438dwLLNxrKTmzZvy040MhpY3mYA2Ea+Q
	 Z7gHwZy6ohqU/v4me9Nv+SAnrqOomYcuiJ6USLbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/117] m68k: bitops: Fix find_*_bit() signatures
Date: Mon, 27 Oct 2025 19:35:41 +0100
Message-ID: <20251027183454.354415452@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 14c64a6f12176..50ec92651d5a5 100644
--- a/arch/m68k/include/asm/bitops.h
+++ b/arch/m68k/include/asm/bitops.h
@@ -350,12 +350,12 @@ static inline bool xor_unlock_is_negative_byte(unsigned long mask,
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
@@ -376,8 +376,9 @@ static inline int find_first_zero_bit(const unsigned long *vaddr,
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
@@ -406,11 +407,12 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
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
@@ -431,8 +433,9 @@ static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
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



