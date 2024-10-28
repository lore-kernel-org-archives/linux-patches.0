Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40232AF07;
	Mon, 28 Oct 2024 06:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098442; cv=none; b=CC6uvorv8O/g0bkHn9VacfgYIq6igeiI7iaDTeOoq1uzu4NHCni2Nwj0gQIv2npEHD21BW5r4sRSTEn8i1FzF1vjm7iEnIrGflZuZtWlhNNxjba+L6Qn4CyclN6eKZd38vp7/65M/WQDspquJCgZnhrgAo16v/oHTezGVcgLwhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098442; c=relaxed/simple;
	bh=FHs/J0EKQEXvxNFfbVPalYoYztR9TpXRWoP8TNLVGSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quPv6w3wjYz2NmKG+7QiPbEtYQ0voBiTL3U9QLKtlsqhObcnvJa0F10QPAXII7mI0Y2VApdiGZ93187E1EVC62fQI5hPtAcvxjM38wJfB9sFOsa/h8lEzOT50nv51AabcnM1/r8IOrYAj1bLnu7mEph/WtpVLQZE7x8JrbX/Ho0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7FF4Yg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7FF4Yg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EA1C4CEC3;
	Mon, 28 Oct 2024 06:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098441;
	bh=FHs/J0EKQEXvxNFfbVPalYoYztR9TpXRWoP8TNLVGSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7FF4Yg+OE3AhMH5TLpp6aYeItuQjBFaMVA+sBkxE5RdlYeiMKMjqN1XQX+5YWmsE
	 9q03phq+Jadkfr0mHazt74QVkLFmRvFkuKeS4F7qCsKdMMCz/+T1o06K8KA97+mvQx
	 Z0ApjWcwnED0iVPsgBdliEXEn7/GMt/l23adnsKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanglong Wang <wangkanglong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.11 229/261] LoongArch: Make KASAN usable for variable cpu_vabits
Date: Mon, 28 Oct 2024 07:26:11 +0100
Message-ID: <20241028062317.854209753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 3c252263be801f937f56b4bcd8e8e2b5307c1ce5 upstream.

Currently, KASAN on LoongArch assume the CPU VA bits is 48, which is
true for Loongson-3 series, but not for Loongson-2 series (only 40 or
lower), this patch fix that issue and make KASAN usable for variable
cpu_vabits.

Solution is very simple: Just define XRANGE_SHADOW_SHIFT which means
valid address length from VA_BITS to min(cpu_vabits, VA_BITS).

Cc: stable@vger.kernel.org
Signed-off-by: Kanglong Wang <wangkanglong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/kasan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/kasan.h
+++ b/arch/loongarch/include/asm/kasan.h
@@ -16,7 +16,7 @@
 #define XRANGE_SHIFT (48)
 
 /* Valid address length */
-#define XRANGE_SHADOW_SHIFT	(PGDIR_SHIFT + PAGE_SHIFT - 3)
+#define XRANGE_SHADOW_SHIFT	min(cpu_vabits, VA_BITS)
 /* Used for taking out the valid address */
 #define XRANGE_SHADOW_MASK	GENMASK_ULL(XRANGE_SHADOW_SHIFT - 1, 0)
 /* One segment whole address space size */


