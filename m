Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D1E4248DC;
	Tue, 21 Jul 2026 19:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663423; cv=none; b=XfVz7u2kkmSPURpMurzRAdqe62Slm6/Ux84gaFriQHDnUiaOWJWvFGi0OnSD/qj4gTxB6yqvOgKyySE2dnZxejTLOZTrUBvU8UTxAA1FDUAGpvSmAyaBU3Ux3OUgfB8hu3slHRyD1j1g8ia9iDCBlv1WJuCanYU+cOyF8RfVdpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663423; c=relaxed/simple;
	bh=oW/uX4da6ZpjZEu73ePEgEOeGczViUg0bkjG0/50dyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpvLmtVhytKlNaN//4hUA+v0lDxuajPZgma8gd8SGLFsfpXRbzukDIqCw28CGvF3m8H+oNXWrHULcH/Kb2QoFOFq81B8loAPghPvvfopv3vgKhFtVfkTGz9ihyz51eVdYtjRKZdJaep7OajXqY6T+sKmrHW7GMV0RnP1ZiNmnIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcI6m9GX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcI6m9GX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73911F000E9;
	Tue, 21 Jul 2026 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663422;
	bh=QVOR0ioyZNWjhzaTd7QRRkERW9xQjKe6T+Utk8cUF6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcI6m9GXaxcFvdssib45mTukrr91R64VwXtaJ45hvct+0iTd3+l2KnU5ix097oxd8
	 W4Ys8vDhseQ89PFWXPGnSYWSdsObbv3P6Uyk9xMFQYBdu3cqzstHvzpdlQJvJX6Opu
	 BVb/f4+IsUQaPVlr2ddp22vUIAsSLJpJSNb9tlL8=
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
Subject: [PATCH 6.12 0816/1276] arm64: fpsimd: Fix type mismatch in sve_{save,load}_state()
Date: Tue, 21 Jul 2026 17:20:59 +0200
Message-ID: <20260721152504.326260760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

commit ae24f6b06e90681ec36b9c21c3f5c09618350f5a upstream.

The sve_save_state() and sve_load_state() functions take a 32-bit int
argument that describes whether to save/restore the FFR. Their assembly
implementations consume the entire 64-bit register containing this
32-bit value, and will attempt to save/restore the FFR if any bit of
that 64-bit register is non-zero.

Per the AAPCS64 parameter passing rules, the callee is responsible for
any necessary widening, and the upper 32-bits are permitted to contain
arbitrary values. If the upper 32 bits are non-zero, this could result
in an unexpected attempt to save/restore the FFR, and consequently could
lead to unexpected traps/undefs/faults.

In practice compilers are very unlikely to generate code where the upper
32-bits would be non-zero, but they are permitted to do so.

Fix this by only consuming the low 32 bits of the register, and update
comments accordingly.

The hyp code __sve_save_state() and __sve_restore_state() functions
don't have the same latent bug as they override the full 64-bit register
containing the argument.

Fixes: 9f5848665788 ("arm64/sve: Make access to FFR optional")
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
@@ -38,10 +38,10 @@ SYM_FUNC_END(fpsimd_load_state)
  *
  * x0 - pointer to buffer for state
  * x1 - pointer to storage for FPSR
- * x2 - Save FFR if non-zero
+ * w2 - Save FFR if non-zero
  */
 SYM_FUNC_START(sve_save_state)
-	sve_save 0, x1, x2, 3
+	sve_save 0, x1, w2, 3
 	ret
 SYM_FUNC_END(sve_save_state)
 
@@ -50,10 +50,10 @@ SYM_FUNC_END(sve_save_state)
  *
  * x0 - pointer to buffer for state
  * x1 - pointer to storage for FPSR
- * x2 - Restore FFR if non-zero
+ * w2 - Restore FFR if non-zero
  */
 SYM_FUNC_START(sve_load_state)
-	sve_load 0, x1, x2, 4
+	sve_load 0, x1, w2, 4
 	ret
 SYM_FUNC_END(sve_load_state)
 


