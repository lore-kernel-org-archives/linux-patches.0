Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D941990C7;
	Tue, 13 Oct 2026 11:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892728; cv=none; b=A8rmw2y4SmvD86FAf7O4hcC/pl78EzNNt8cbkLcwaBbGnqc/NlAj/9dloyiW/X68xlcMBWZD6H/07IRH86xdYgoAqSl0mJ4jLuYnWLRGGzCzvM2HVGUypLnpbaneNKL8czGHRNSXmFjcm/P1lWNj0JYHFZf87pnD/hzlyddY/IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892728; c=relaxed/simple;
	bh=YRBkpAntgMKqblPgGQzPphUIsJQufjBaNHe15MSneIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/DTpUE6sXCEjUdaUGJdS/NewzHhWanALInwrjeHDW3gJYTJDF07M1qcCxunDFCxQfqA11DFH7kixB9Dmv6HoRaysW8041TBaH9Wz5r30L+q4FxZ9xnmIHJj9HXstu4xDJx4jY/CU4Ri7zCorjnZfM8D8fWJMozm8gGyuz3mxrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bodBhIqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bodBhIqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD5A1F000FF;
	Tue, 13 Oct 2026 11:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892725;
	bh=SQiqgrvxY49IeBylgo5NmCSWUw+1aB2/Ua5wgyuCcV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bodBhIqqIhym2bCdaPAGWWHtZBQ6rFh4i7V/QckpQiSSB7Mapvysq9gSMXCJx+0aR
	 8U0Gn9rI8J9XjkpR5j3La8KD81FfGDcRmY2xj9Kpe6xe2Yt9c5e7ZC3If/cnH+ASpa
	 OZvogVkkHpsjbS2N1pU3IUAE50SytJsJ/GAdYlSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 225/281] riscv: vector: Fix output operands in context save
Date: Tue, 13 Oct 2026 13:39:01 +0200
Message-ID: <20261013112900.615005698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit 55b1276ef9c1c27e8a2b2c5e8ef0515b5ad0332c ]

The __vstate_csr_save() inline assembly declares vcsr as an output
operand while the assembly only writes vstart, vtype, and vl. Remove it
as it is later saved by the C code.

Fixes: d863910eabaf ("riscv: vector: Support xtheadvector save/restore")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Link: https://patch.msgid.link/20260911194218.3379486-1-aurelien@aurel32.net
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/vector.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index e94f81cedda56..8d736e826d84d 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -132,8 +132,8 @@ static __always_inline void __vstate_csr_save(struct __riscv_v_ext_state *dest)
 		"csrr	%0, " __stringify(CSR_VSTART) "\n\t"
 		"csrr	%1, " __stringify(CSR_VTYPE) "\n\t"
 		"csrr	%2, " __stringify(CSR_VL) "\n\t"
-		: "=r" (dest->vstart), "=r" (dest->vtype), "=r" (dest->vl),
-		"=r" (dest->vcsr) : :);
+		: "=r" (dest->vstart), "=r" (dest->vtype), "=r" (dest->vl)
+		: :);
 
 	if (has_xtheadvector()) {
 		unsigned long status;
-- 
2.53.0



