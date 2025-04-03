Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B7B188A3A;
	Thu,  3 Apr 2025 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694024; cv=none; b=sP7nplL7G4nGlxCKTW5ZsErRwdLanlWg2hRrxKw3hhhMNHLsRS+Wsi7LT/8m6KJacT3nRbB90VpVt6QMg2UavZMb66wnEKHrvLoEJH48dPmBUpe095vpWzW85mw/vLsheFgCh1pe4JSiyyH4Toax9XBCRdtL0MocC1ejqZJJ/uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694024; c=relaxed/simple;
	bh=/zibdpqmJ1nCP4osSTA4fUXyPWmPD7xKubfj6XPKNLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dN8JkYbEp+rPSGTjZJK5R+AkbVbFcRIWsLiqud4hzNNRsJngUHcFHl/uiV6z5aXSEJagrOPQvcUmra7trN5jBWs3garaCFu2dyQ70BuIs3hqZGiRoyX7RpMHgA5cQqsL0YsXjyWCqzyKpj7pEju4tRZxPhq+dGrm2QZjml5Pj7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODfsuB9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODfsuB9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11F7C4CEE8;
	Thu,  3 Apr 2025 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743694024;
	bh=/zibdpqmJ1nCP4osSTA4fUXyPWmPD7xKubfj6XPKNLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODfsuB9WQ/Jo6s7cXdQz4HqaXAEBmgYmYG17Kulm/NeiA/rbHxPMuLo87ze+EO+80
	 mDXsyhBrHHgIA4e1BX5KO9hk+upO/bN1dR2HqOiuHTeYgGZeyO9MZrjpKTtiWlERQ8
	 +Y3ka2TefSHAfJePUmjqCkxHihhnpZJQHePWQiyc=
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
Subject: [PATCH 6.6 05/26] ARM: 9351/1: fault: Add "cut here" line for prefetch aborts
Date: Thu,  3 Apr 2025 16:20:26 +0100
Message-ID: <20250403151622.571146287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -563,6 +563,7 @@ do_PrefetchAbort(unsigned long addr, uns
 	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
 		return;
 
+	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
 		inf->name, ifsr, addr);
 


