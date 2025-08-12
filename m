Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF232F90C8;
	Tue, 12 Aug 2025 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022453; cv=none; b=eHWs2+8rEIEn4eq4wSwckIqAMKLLTrPYFHQZZMv/mY9aweRyFwZNiO5w0JRMNMWf9miISlKZfzah3PYc79rLHq+0/A0yZJRVgi55d4FlzjLYMcY7lEr1zd4a5y4tW/QM/lZ67KAzRRa/eX25yMtyIlL+vD8HrA9sPscI508BzJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022453; c=relaxed/simple;
	bh=83jB/9jPyWL8b72FpOtLBqjemlAQn9BAjHhTwgsXvCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBgccyDK+xbTlX84X+0qvNwIti4k4np8Ydn1IkThkw3zXNdUCksJYPycODb5jEFZKlribC6fxrJkuPOkthpGQnw28l3GInu6d40QXNqbX8bwdc5sETdb6gVSpNoNOKEVGi2BdOF+m7TKVV4n1BxgO755hNp5ytphyolEFrLAD48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8JjcOqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8JjcOqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7911BC4CEF7;
	Tue, 12 Aug 2025 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022453;
	bh=83jB/9jPyWL8b72FpOtLBqjemlAQn9BAjHhTwgsXvCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8JjcOqjP0p6on3Avbiyq4j9UIxPpsm9jt4Rpr9znjw4jhtTYyR6eMLkuWv015qRn
	 BqnQVeNPz7M+jfV7Dxv3CGvG90jWTYUZu6BQqHlLJrZ3inuT3PJFVzu/Kw8C54Edxv
	 11wAUPzoC+cyfholaDFRro4PgIcmC6WQnX6IeGtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/369] crypto: qat - fix state restore for banks with exceptions
Date: Tue, 12 Aug 2025 19:27:36 +0200
Message-ID: <20250812173020.748547244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

[ Upstream commit 254923ca8715f623704378266815b6d14eb26194 ]

Change the logic in the restore function to properly handle bank
exceptions.

The check for exceptions in the saved state should be performed before
conducting any other ringstat register checks.
If a bank was saved with an exception, the ringstat will have the
appropriate rp_halt/rp_exception bits set, causing the driver to exit
the restore process with an error. Instead, the restore routine should
first check the ringexpstat register, and if any exception was raised,
it should stop further checks and return without any error. In other
words, if a ring pair is in an exception state at the source, it should
be restored the same way at the destination but without raising an error.

Even though this approach might lead to losing the exception state
during migration, the driver will log the exception from the saved state
during the restore process.

Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Fixes: bbfdde7d195f ("crypto: qat - add bank save and restore flows")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 29 ++++++++++++++-----
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 41a0979e68c1..e70adb90e5e4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -585,6 +585,28 @@ static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
 	ops->write_csr_int_srcsel_w_val(base, bank, state->iaintflagsrcsel0);
 	ops->write_csr_exp_int_en(base, bank, state->ringexpintenable);
 	ops->write_csr_int_col_ctl(base, bank, state->iaintcolctl);
+
+	/*
+	 * Verify whether any exceptions were raised during the bank save process.
+	 * If exceptions occurred, the status and exception registers cannot
+	 * be directly restored. Consequently, further restoration is not
+	 * feasible, and the current state of the ring should be maintained.
+	 */
+	val = state->ringexpstat;
+	if (val) {
+		pr_info("QAT: Bank %u state not fully restored due to exception in saved state (%#x)\n",
+			bank, val);
+		return 0;
+	}
+
+	/* Ensure that the restoration process completed without exceptions */
+	tmp_val = ops->read_csr_exp_stat(base, bank);
+	if (tmp_val) {
+		pr_err("QAT: Bank %u restored with exception: %#x\n",
+		       bank, tmp_val);
+		return -EFAULT;
+	}
+
 	ops->write_csr_ring_srv_arb_en(base, bank, state->ringsrvarben);
 
 	/* Check that all ring statuses match the saved state. */
@@ -618,13 +640,6 @@ static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
 	if (ret)
 		return ret;
 
-	tmp_val = ops->read_csr_exp_stat(base, bank);
-	val = state->ringexpstat;
-	if (tmp_val && !val) {
-		pr_err("QAT: Bank was restored with exception: 0x%x\n", val);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
-- 
2.39.5



