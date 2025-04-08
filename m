Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091CD266EEA;
	Tue,  8 Apr 2025 12:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113967; cv=none; b=X0P9mmt3oE6znNzq2ctdvhvLl4n0UAWgrcX3fQ3+SP1avJbvzfHjA8aChohAeex/heK9x+QIOMfXEHiA4Ys9GyDJ963wvJlYEpCFQ9crAjRPjVLYtj9h+Vpda/m7Krz4hN5/+6mtBSv7MooDn9eef8DwkJ3YphJYrosTxgkObWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113967; c=relaxed/simple;
	bh=8IzS13onBkNorLOdkcwuDygjn5SjBt9/3Xqjltj3gXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDsCsIRe+SOfE0AL/r2z+CMVvaJ+oQOXz+pNUslarFhKVbCCGrX8PuJIbCz0C06hDkpX/MSTcJPU+S0t2BSdCRvS6UZTN04IrxI7+L3wcMFKbF7sxUW+gzQCgK2ajuzXtxV+9pajVwiTyP9aDrL2DUxg1/rAnVI6+/JtzvMZBNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnZFpgnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnZFpgnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB0FC4CEE5;
	Tue,  8 Apr 2025 12:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113966;
	bh=8IzS13onBkNorLOdkcwuDygjn5SjBt9/3Xqjltj3gXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnZFpgnjqbVXOKGlhjGoTXjqX/EL05rA9j4l+lnQCA1nzR5V8HE7tQBAOb4+0J8tJ
	 AGRoIJdVmuo0NLCtMHGb5QbJ/Qfrm0pkDE7NTjAz8L0PE1EsCgDCfeBeyspRYi8ET+
	 8zOSBL8h5IUqGJgvI3zoRgJs6x58/dQ0AqvmDw1E=
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
Subject: [PATCH 5.4 070/154] ARM: 9351/1: fault: Add "cut here" line for prefetch aborts
Date: Tue,  8 Apr 2025 12:50:11 +0200
Message-ID: <20250408104817.544750371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -570,6 +570,7 @@ do_PrefetchAbort(unsigned long addr, uns
 	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
 		return;
 
+	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
 		inf->name, ifsr, addr);
 


