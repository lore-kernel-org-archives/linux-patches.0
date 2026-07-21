Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D543634C;
	Tue, 21 Jul 2026 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665396; cv=none; b=dPWw87DKLICihuqyoIacIkbsjGOfBEabpnbmWfBaE0m83ht4Hchr9k+6S5rdNDXBJwD5hW8Gsh+wniC/fYbKCxc2CTKo4WIKeJGAo5XTIMrSXq//FgY7U/7cwE1XDPoaF85cu7G8pIyO8Aj1s0Cle7/Gu+8TXGEThrBMlBhj3j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665396; c=relaxed/simple;
	bh=deHtDYB5s7XL2sp4+iP9X3MtbAbBFkF6EKDKoqnA9qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpihTa/LkH3HaU3jY/mg9VBnUUReOexwuavnb4ski4MO6qptQN6jx7bT5H2qRtRNcsu34lx+NnB/jvU/NurgYHbJl+aGWe9CQ+ToLpAowPCq+t0gUxHBHBT401qHY7N+omyanalfiEuzv/+T2yE43jKbpkNJ7wrRYRMkZNMYH2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEt0JUpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEt0JUpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEC61F000E9;
	Tue, 21 Jul 2026 20:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665395;
	bh=+whYWNt3hpeJAicTE6HaRi5aN3NRysgOupRkpNBShvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEt0JUpvwPh5HWxvp4f1H3UqV2shqR57vC6Mlv0uK9wt9BrtX3/H72Y1gzsIwQmxF
	 VXW4YC5jn2plYnUSOztkvnS1hmkLCd8cKVOhMyNOBFwsfV8ShZ10sQ10PpcETXkfUU
	 jOozIKzk8VyZTVj82rlJkhjgPF+6P1tfGH0hXrd8=
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
Subject: [PATCH 6.6 0289/1266] arm64: fpsimd: Fix type mismatch in sme_{save,load}_state()
Date: Tue, 21 Jul 2026 17:12:06 +0200
Message-ID: <20260721152448.291857354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


