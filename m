Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4393D250C0C;
	Thu,  3 Apr 2025 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693787; cv=none; b=ZYoL55O07rdja6uyqApzIRCLIwx7dv9t30NGt5PU5HPxVO4X7wbhw5wNsRf93rc9Yzuap1/Segom9g+NTyIggonnWYvOB6YdXRzaGI3qNQ9bj5Jx3GTLyOFyPp7uHCvWA33tXB8rtSOfDET77on9H1Z+gcv6UxQe07v0KzX4Qi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693787; c=relaxed/simple;
	bh=3VTqbVG/HazYgLFpakJ2Bconzo3PtWaoRmUqQrVjbaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkX1VG/sZlFTIcVCCVNRDahgGBYqCYo2DKyzBX/KlW6cD8bnIK+rch3pQgvkumZ0FB9HzWcYG9dc+gbHsmWfWTYp146yQgls2GUdw2eUb0tEDAoP9EozLfi2fCoIl4r6kRnbNX5O/bdgv/yU6I4yojAZTfBnJMnjTOlgyPaW1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAFZzW9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAFZzW9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D02C4CEE3;
	Thu,  3 Apr 2025 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693787;
	bh=3VTqbVG/HazYgLFpakJ2Bconzo3PtWaoRmUqQrVjbaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAFZzW9YqbTGjwn84pawRCoQlIptoruP2FO9x7rEfFBzbvWkRb7o4uAjR+TW3JyW7
	 WJ4dn8e0ZxAv7FTCq3I10lIZvRaawj2eJBqLkZ2uFYyoxq6iqVCdfr/u7iFj0ZD9Xp
	 KdiuOhITXZGeZzmp7gBkEbgimbZNzO+ZNR3DXWOc=
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
Subject: [PATCH 6.1 05/22] ARM: 9351/1: fault: Add "cut here" line for prefetch aborts
Date: Thu,  3 Apr 2025 16:20:00 +0100
Message-ID: <20250403151621.099836965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


