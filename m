Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2AF17F4F6;
	Mon, 27 Oct 2025 19:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592565; cv=none; b=fM5NsHoAWf8IGMV7BE6VFjHLL415rhUBNFOIQvbIDQdBqeMvudm4+WNFw2h4MkBFV4FlQVRLGDbkCm0D9/xBdPxKXURkYraAcJuu/4aOvB+Ua5wEUpMWKl8Wm+EgOUSdzNFpYI7Afv2yB/Tizf9ALVOQHH6/rdqoQzP0AEqMbEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592565; c=relaxed/simple;
	bh=jTQdlf8W4DHi1unpICKEsWBR0CL6+E7rNivNq6q1grY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQdJeJZ54g5QQiNENobl7pBi9+CtzP0YAfvu9wKxpiWDBq/Ol/I+tE6mM7VFjwmrSS+sDwRYgJbC1pZntlEYw+a9tYTZr0pOaQLLzGIwMPqE5NqCSUSfWDJ6iqJPz9usaP7bhtFYo30wJOzsWOAWtWrcVfModkM2rTcTQOhqzRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVM88QWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVM88QWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F529C116B1;
	Mon, 27 Oct 2025 19:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592565;
	bh=jTQdlf8W4DHi1unpICKEsWBR0CL6+E7rNivNq6q1grY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVM88QWRaTA6H6zqTuVQyGSGv868CzD8epbwwVOTvUiZo72YP4Zpox3Uxu3Om266n
	 JFlJxc6Nk2jE+sdgDusT1mPMWuXkA4BaB48XWDVQqVv/9R2dhEU2KOrrSX2pxwCyg0
	 4RKKjw5tlO9BzuDe+b5LE2UQE58iD+p1CflUkAfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/84] m68k: bitops: Fix find_*_bit() signatures
Date: Mon, 27 Oct 2025 19:36:01 +0100
Message-ID: <20251027183439.144942377@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e984af71df6be..d86aa744cb8fc 100644
--- a/arch/m68k/include/asm/bitops.h
+++ b/arch/m68k/include/asm/bitops.h
@@ -329,12 +329,12 @@ arch___test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
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
@@ -355,8 +355,9 @@ static inline int find_first_zero_bit(const unsigned long *vaddr,
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
@@ -385,11 +386,12 @@ static inline int find_next_zero_bit(const unsigned long *vaddr, int size,
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
@@ -410,8 +412,9 @@ static inline int find_first_bit(const unsigned long *vaddr, unsigned size)
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



