Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D48E22171A;
	Tue,  8 Apr 2025 10:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109905; cv=none; b=mDM7kIvOnTGAHsK5Ckxsc/fO2YoB+zIN3bs1j9BqhhFzlDkbdtPHlyeXsTkBTTAd3fpxQjxK/uHWHhYXeHjv+6A3HNcHH53/KGbyuriz+X8Gnw+J3qyZM7JtRlRC2Jj/3z3CuZsQEE3FDn2Wj7XGclRREOFwMz+sTLNYUreZPMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109905; c=relaxed/simple;
	bh=2dXaRaSVF3MOXMor/ZA49nW7VYYnM8YxTKw2RmdENSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC1EB5o7Tu1aM7cTF+6mDdWt5GJvLYXU4VEjd+EBvLpsCJAgvTID9qhras/RTTcXL85R6/Q3RX2Mg3J0PWos7WWnh+EmOgGTfZ/FI5OMaZAc1S9WBHeAoqWf0ir1HI8IVt1h6eK8C+oGs1O3/mSenUleknPOp57qtxQCQ9t/8OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0mK0d6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0mK0d6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD16C4CEE5;
	Tue,  8 Apr 2025 10:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109905;
	bh=2dXaRaSVF3MOXMor/ZA49nW7VYYnM8YxTKw2RmdENSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0mK0d6GlFUYA6LkyIZ867AzatLTZLlaq0L2b8PaVsDe1yFFxN+/d5Krr4mKsn/w6
	 gad4kVc+BG8JEncQHMJn4d+oqW2TzA2pTvTr61sGu7pS4xYYaHJTPr0DOTDbIPdAL+
	 lGYP2oZCo0H47Pa5sbA4wGuEtI6nWVBEQ+NOLXdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Kefeng <wangkefeng.wang@huawei.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 097/227] ARM: 9351/1: fault: Add "cut here" line for prefetch aborts
Date: Tue,  8 Apr 2025 12:47:55 +0200
Message-ID: <20250408104823.273574164@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 8f09b8b4fa58e99cbfd9a650b31d65cdbd8e4276 upstream.

The common pattern in arm is to emit a "8<--- cut here ---" line for
faults, but it was missing for do_PrefetchAbort(). Add it.

Cc: Wang Kefeng <wangkefeng.wang@huawei.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/fault.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -559,6 +559,7 @@ do_PrefetchAbort(unsigned long addr, uns
 	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
 		return;
 
+	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
 		inf->name, ifsr, addr);
 


