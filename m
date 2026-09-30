Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695EA47A0DD;
	Wed, 30 Sep 2026 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785996; cv=none; b=SHzoy0HjEFVvM2Gjdka8byPAUU5cmSVt+DwNEiwsgCfQUIFlrQysFIFMmQWRtVVUOe937Y2Weu8PGjPb3ukIz734lGeG5/Deh2FeiQNOHkuzi0BrHHzpk3avxn+nY3t+HnimEhQE1KbXZsV1ku4KjYfW14o+EiWKnrOD8u9MGjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785996; c=relaxed/simple;
	bh=W6tsSMaj9jiGpIvgI+70YpvTtJCtNgK7aZ5dMBcUVjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YE15XbZig8Cz0WDnaL8d22Lcol1bfRijnfG81sbAlYcVqKSBiM92OuGKSVgyQUkZn1Cc16cwHLaNWzsCVdfobWESAsRhabViJFdJ532dyt5UyBlVJntpgNANVaOpanX+PXUmM8Zpe3CW8hVxQ6gS7k8gk+TbF3iTjVpMTXHJcbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRa5hYsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRa5hYsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0891F000FF;
	Wed, 30 Sep 2026 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785994;
	bh=2Hr0PQ1mz1iT1USXi+ioYFsdv66UnVyQYrbyEJXBHdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRa5hYsThE++s9smNkDwKXvvTyuvFbzwXZ8g3QJ36aanHUrzNQ68mVKrPudOQHWIo
	 54yvg0Syx+k3lOB8y7KgX1ikj1yUJP5hvlZErV9bygjf7aWkN6+mn35NNp+eZO95a1
	 Q6FpN0llAO/BjxMNGRQve287/PNIeZt0BELCUZys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 705/982] arm64: hibernate: pass HVC_SET_VECTORS args to the resume hvc
Date: Wed, 30 Sep 2026 17:24:01 +0200
Message-ID: <20260930152431.901201487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <include@grrlz.net>

commit 955d86e5f3b95b731991fdb84966c50b16314629 upstream.

swsusp_arch_suspend_exit() reinstalls the restored kernel's hyp stub
vectors with an hvc, but never passes the arguments. x0 is not set to
HVC_SET_VECTORS and x1 is not set to the vector address, so the stub
dispatch falls through and returns without writing vbar_el2. EL2 is
left pointing at the trans_pgd copy of the vectors, a page that
swsusp_free() releases right after resume.

Set the arguments up the same way __hyp_set_vectors() does.

Without this fix, Vladimir was able to trigger a hang when resuming from
hibernation with CONFIG_PAGE_POISONING=y and page_poison=on.

Fixes: 788bfdd97434 ("arm64: trans_pgd: hibernate: Add trans_pgd_copy_el2_vectors")
Cc: stable@vger.kernel.org
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/hibernate-asm.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/hibernate-asm.S b/arch/arm64/kernel/hibernate-asm.S
index 0e1d9c3c6a93..2baefe7a82d3 100644
--- a/arch/arm64/kernel/hibernate-asm.S
+++ b/arch/arm64/kernel/hibernate-asm.S
@@ -89,6 +89,8 @@ alternative_insn "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
 	isb
 
 	cbz	x24, 3f		/* Do we need to re-initialise EL2? */
+	mov	x1, x24
+	mov	x0, #HVC_SET_VECTORS
 	hvc	#0
 3:	ret
 SYM_CODE_END(swsusp_arch_suspend_exit)
-- 
2.55.0



