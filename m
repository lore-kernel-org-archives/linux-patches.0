Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9FB3ACA5D;
	Tue, 21 Jul 2026 17:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653976; cv=none; b=PRxB8JVaFnG/9nkaMQ6dCUFJHRISYFHX3Q9kzaZIDRMWnYeLkehkYeQToyagtlVl5YWNczD5ezWaRMQvFycOmUJlM7LUZwGeMiLDMvkHTxcoIYC3AVJmoi3FIdPa8bWGWdk+ecpMs8oSSrT4Qk8kMIssjFx0NeLwnjtLow/4ERE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653976; c=relaxed/simple;
	bh=TBHpU+A8OWstnF5UtqNxyQPzHjmrT1bH9+nFPkoCUC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCZz0ctVDDjXDbXGc830M6CNfjTFrNA3JY5YTDoqIcHzgjdTofFWYjSnMljamckgBOAIA5lHP1U0yt+w+wDl6xShAOOU5kRrNI5m2YWCTs47S+cz8Nfm0nDw7HPRGAHjeII6khk71s59Lm66/A0NBKbKVKGKih0ZXXhSXP+05tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4+buCU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4+buCU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F8F1F00A3A;
	Tue, 21 Jul 2026 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653975;
	bh=fJyvnSQ0laoP6/BtNZr7SCriT9QLTqFHP2K6wZCRHvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4+buCU9hTHpyQb3hoDm7liTQ430e+lSFF2FdUarw6o70y7dmp7elOcSdeKH9RtqQ
	 koj7JLQrVsud09upI2RLelOlf6Ah+/MlrMFhoZt/u8opNV3Qr2zgyy4FJgXSKXrwuu
	 QA4MCt/SWLkCjvfqUdw1Pe9CYYIl+qV230rgjT/E=
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
Subject: [PATCH 7.1 1531/2077] arm64: fpsimd: Fix type mismatch in sve_{save,load}_state()
Date: Tue, 21 Jul 2026 17:20:04 +0200
Message-ID: <20260721152628.890727052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


