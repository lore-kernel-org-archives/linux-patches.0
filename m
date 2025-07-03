Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620682E7F1A;
	Thu,  3 Jul 2025 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554749; cv=none; b=hYTPfr3TnyHJLS0Q/4+RvK1/OKsNS1Q3B3O3G9v0kJcF5dH4YfFm/7i05QCAWHMv2I3j3G+Iqh6VcwOcD8SiRXX0VItOp84QohRPYBYnV0g2S6sKwdGugphvplt1+KKquSRaAjw2ABIimDBEeWKq7gU5/EJhfScTB4XPTEae66o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554749; c=relaxed/simple;
	bh=fMKzM9fprQ2koZ+UYcDtwKpjZV9DOJZXZFlp8P6IM8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MxI/SpSg++2DLAeuhjAAI5wHUmqSgok4hc3KlStydBJE5CLgwOk9LF9JeactzRO15hI5ZTm+7PU3fwwVUWIODnzzvIim5xiDPhx/VhB9kLQcsEZ204LKSQ7orwp5iAp5rUh3oOzQitsxWqKYShCA56801fVAZjOFaGdH7EHaLPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USoIJ1g+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USoIJ1g+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC920C4CEE3;
	Thu,  3 Jul 2025 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554749;
	bh=fMKzM9fprQ2koZ+UYcDtwKpjZV9DOJZXZFlp8P6IM8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USoIJ1g+5+yvHUL/l7W+ggmHepfUemxK/45Nzxv+0wPgtMYhbd9sCjqMftDNF5vG8
	 YnhAYnehjCDDiGB6tDnIYJx+VKIQ103ran7Hox+Q8GpfRls8hb5XUOxhtyD/hunAPB
	 TgcVnTCofqK5pKkxhys8Pe1oep3RCF2CKOHMaIaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andybnac@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 067/263] riscv: add a data fence for CMODX in the kernel mode
Date: Thu,  3 Jul 2025 16:39:47 +0200
Message-ID: <20250703144006.992939863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chiu <andybnac@gmail.com>

[ Upstream commit ca358692de41b273468e625f96926fa53e13bd8c ]

RISC-V spec explicitly calls out that a local fence.i is not enough for
the code modification to be visble from a remote hart. In fact, it
states:

To make a store to instruction memory visible to all RISC-V harts, the
writing hart also has to execute a data FENCE before requesting that all
remote RISC-V harts execute a FENCE.I.

Although current riscv drivers for IPI use ordered MMIO when sending IPIs
in order to synchronize the action between previous csd writes, riscv
does not restrict itself to any particular flavor of IPI. Any driver or
firmware implementation that does not order data writes before the IPI
may pose a risk for code-modifying race.

Thus, add a fence here to order data writes before making the IPI.

Signed-off-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20250407180838.42877-8-andybnac@gmail.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/cacheflush.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/cacheflush.c b/arch/riscv/mm/cacheflush.c
index b816727298872..b2e4b81763f88 100644
--- a/arch/riscv/mm/cacheflush.c
+++ b/arch/riscv/mm/cacheflush.c
@@ -24,7 +24,20 @@ void flush_icache_all(void)
 
 	if (num_online_cpus() < 2)
 		return;
-	else if (riscv_use_sbi_for_rfence())
+
+	/*
+	 * Make sure all previous writes to the D$ are ordered before making
+	 * the IPI. The RISC-V spec states that a hart must execute a data fence
+	 * before triggering a remote fence.i in order to make the modification
+	 * visable for remote harts.
+	 *
+	 * IPIs on RISC-V are triggered by MMIO writes to either CLINT or
+	 * S-IMSIC, so the fence ensures previous data writes "happen before"
+	 * the MMIO.
+	 */
+	RISCV_FENCE(w, o);
+
+	if (riscv_use_sbi_for_rfence())
 		sbi_remote_fence_i(NULL);
 	else
 		on_each_cpu(ipi_remote_fence_i, NULL, 1);
-- 
2.39.5



