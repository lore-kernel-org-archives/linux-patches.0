Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33403400969;
	Thu, 16 Jul 2026 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212357; cv=none; b=Fp4X3nwIKsGJ2YSN5h19LKUzoDe6hhniRL8xX2MszJi8s/WvVSwmtL7UZcVVwCYERpUN0RNPb9sIe4hFzf2euqyzDnLAaWmPaXEHYSMaZfFtvTjNrC01zV3XRai8Z7q4fti3Qbboa+fUawmdSZhK9RFCVaEYBkzLixzBM9amTS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212357; c=relaxed/simple;
	bh=oIdyfTuJtj8HuadjJ1qNBFQMbh/S2VIl/0M2V/7mhI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/LFP6eDr6lgOG78q185l/QylyICj1pK+jRU1gJfHe7gKahxwGElu7r1ZtKWXZTUEZE0V5jT6YqkUZLatAMAwmyoG4f0iH9vcIPmrUtltZYxT/S5lR5bFrwBIFkKT8HhLaxds94K07a6P9oWEn8eWt2b7s2o9PLtmXaISpsCH8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9gmz7Ok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9gmz7Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C25D1F00A3A;
	Thu, 16 Jul 2026 14:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212355;
	bh=pfU4PZ7vos43eggDqGj9JGFOptj8R+J65LgYUXcRXEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9gmz7OkOKnyCu4x1l2KvylIHy2q+lIfoUF5lZXn0hxotP8EvZBUUUOtJln3iu0zb
	 gRRmt0vwtMb/94Bh1bVB46qAbeHrzvDsRPSuYPe5q+MX8VW1njGxk+ybwOTZLeomjS
	 tE1LhndwM68J5qBCXLG802py7al5RcbVk7WpraYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 297/349] arm64: fpsimd: Fix type mismatch in sme_{save,load}_state()
Date: Thu, 16 Jul 2026 15:33:51 +0200
Message-ID: <20260716133039.969540698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit 247bd153905085c18ff9006cca1ccb96dfd18e7f upstream.

The sme_save_state() and sme_load_state() functions take a 32-bit int
argument that describes whether to save/restore ZT0. Their assembly
implementations consume the entire 64-bit register containing this
32-bit value, and will attempt to save/restore ZT0 if any bit of
that 64-bit register is non-zero.

Per the AAPCS64 parameter passing rules, the callee is responsible for
any necessary widening, and the upper 32-bits are permitted to contain
arbitrary values. If the upper 32 bits are non-zero, this could result
in an unexpected attempt to save/restore ZT0, and consequently could
lead to unexpected traps/undefs/faults.

In practice compilers are very unlikely to generate code where the upper
32-bits would be non-zero, but they are permitted to do so.

Fix this by only consuming the low 32 bits of the register, and update
comments accordingly.

Fixes: 95fcec713259 ("arm64/sme: Implement context switching for ZT0")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry-fpsimd.S |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/entry-fpsimd.S
+++ b/arch/arm64/kernel/entry-fpsimd.S
@@ -103,13 +103,13 @@ SYM_FUNC_END(sme_set_vq)
  * Save the ZA and ZT state
  *
  * x0 - pointer to buffer for state
- * x1 - number of ZT registers to save
+ * w1 - number of ZT registers to save
  */
 SYM_FUNC_START(sme_save_state)
 	_sme_rdsvl	2, 1		// x2 = VL/8
 	sme_save_za 0, x2, 12		// Leaves x0 pointing to the end of ZA
 
-	cbz	x1, 1f
+	cbz	w1, 1f
 	_str_zt 0
 1:
 	ret
@@ -119,13 +119,13 @@ SYM_FUNC_END(sme_save_state)
  * Load the ZA and ZT state
  *
  * x0 - pointer to buffer for state
- * x1 - number of ZT registers to save
+ * w1 - number of ZT registers to save
  */
 SYM_FUNC_START(sme_load_state)
 	_sme_rdsvl	2, 1		// x2 = VL/8
 	sme_load_za 0, x2, 12		// Leaves x0 pointing to the end of ZA
 
-	cbz	x1, 1f
+	cbz	w1, 1f
 	_ldr_zt 0
 1:
 	ret


