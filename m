Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AB47E107;
	Sun,  7 Sep 2025 20:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277954; cv=none; b=cmK3gRLC26gGOG1o5qGu4pWHP8i+YnzB1HYcfQ/YT2KRJLRN903fxN8AqTlaV9HneGRvGqos777jjn0NmYYG44LUoDdrrTd3iab4k8Pi5dv7K9al5Xcdz2HPo6MtwYyApX2rjwOxvg8bgNBis6Q+skFGpz1USP2urvxqA5zBJQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277954; c=relaxed/simple;
	bh=3wbJEQEiWV5NSgELhUIAZOO7DwShXREed4IbkkAng/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvUKYY36sGrZVfaW9//XHMdoFy+Sp2+jlICqhvyHcmEndUoISIXamGHuKt6KHTmHJ0/OAZHZfO6iwWfhEQ8JDuukdT/TbfQYraoomYP6qOo1wU78bTbnldlne1pK1dWtPiJHcv6HC7T6dTRMnHzzfC4jww+f0kaiqLcPrmzdMGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGmHlp3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGmHlp3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD27C4CEF0;
	Sun,  7 Sep 2025 20:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277954;
	bh=3wbJEQEiWV5NSgELhUIAZOO7DwShXREed4IbkkAng/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGmHlp3uRzsUx6MxBvOyxx5LqlgIOLQkbZw6/dK3/2FqTqtfJPTf0JVsW5dvSDJ7L
	 tJl2y1evW7FdmOiVNk3f+7STXMYqkHs38g/ejuszX2XFl/N23oPcgYiKHUFktuAbFV
	 c4j7emkNfLXTGraRb1Tj8rxSY/mNkr2fJFzCjGxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 176/183] riscv: use lw when reading int cpu in new_vmalloc_check
Date: Sun,  7 Sep 2025 22:00:03 +0200
Message-ID: <20250907195620.008812457@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@ventanamicro.com>

commit e108c8a94f3f958c877f6ec7a6052a893ae4aa98 upstream.

REG_L is wrong, because thread_info.cpu is 32-bit, not xlen-bit wide.
The struct currently has a hole after cpu, so little endian accesses
seemed fine.

Fixes: 503638e0babf ("riscv: Stop emitting preventive sfence.vma for new vmalloc mappings")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Link: https://lore.kernel.org/r/20250725165410.2896641-4-rkrcmar@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -46,7 +46,7 @@
 	 * a0 = &new_vmalloc[BIT_WORD(cpu)]
 	 * a1 = BIT_MASK(cpu)
 	 */
-	REG_L 	a2, TASK_TI_CPU(tp)
+	lw	a2, TASK_TI_CPU(tp)
 	/*
 	 * Compute the new_vmalloc element position:
 	 * (cpu / 64) * 8 = (cpu >> 6) << 3


