Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56D03EDE45;
	Tue, 12 May 2026 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609256; cv=none; b=HxQz6lEjo4rWw0apLs534LxmYxsXUzZmBPm9ST7yTu6BMNoxXSVF0Kw/hbaFtmRd5F6fgRqDmOB+92eYOjWojwoSt1g+v52jIAsSk1SWHHG1oKiGfT++C8jTOTUFTG6BTGi23WDAuzj341jwtAnkQhS+IBJgk7HnGtSAlMJmuQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609256; c=relaxed/simple;
	bh=C+v71hdQin6KItS7BeYdVxPUNM7TSpUBh0j/RQdRjrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cB7x1N9g/EQgrmBjcHwzmQvm9eJQyw3+UBzbYVZyRLHelLEzYgIhHkRmRqDKn99NgCH8HzzNF74tLBbVolZEmb+bm7AR8rg7BGUbS6pZ8ZoZYGTbVbErLT0tZ007TgbM6+IdEpKqsDpaQ0geucsVSojCcOmQNkfA+1PAu0mtphU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxP9BQpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxP9BQpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D466C2BCB0;
	Tue, 12 May 2026 18:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609256;
	bh=C+v71hdQin6KItS7BeYdVxPUNM7TSpUBh0j/RQdRjrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxP9BQpcqDeVHI87j4xxiEBdPPRuRBxVG84amHxJ4hr9UHSb7hUHIY8XgHt5R/H/+
	 mETW9pCZPcEBlHFIqTLjkjU6UPIfoNzbH1UtIvdHpO26nUAm2ocnc0tRbDXL3TdlHD
	 EJbCiiiTMWN5/K7Wr7pErn/NYAMFwpzScTWvDlCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 7.0 126/307] x86/efi: Fix graceful fault handling after FPU softirq changes
Date: Tue, 12 May 2026 19:38:41 +0200
Message-ID: <20260512173942.788387824@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Hu <ivan.hu@canonical.com>

commit 088f65e206087bf903743bd18417261d7a4c9644 upstream.

Since commit d02198550423 ("x86/fpu: Improve crypto performance by
making kernel-mode FPU reliably usable in softirqs"), kernel_fpu_begin()
calls fpregs_lock() which uses local_bh_disable() instead of the
previous preempt_disable(). This sets SOFTIRQ_OFFSET in preempt_count
during the entire EFI runtime service call, causing in_interrupt() to
return true in normal task context.

The graceful page fault handler efi_crash_gracefully_on_page_fault()
uses in_interrupt() to bail out for faults in real interrupt context.
With SOFTIRQ_OFFSET now set, the handler always bails out, leaving EFI
firmware page faults unhandled. This escalates to die() which also sees
in_interrupt() as true and calls panic("Fatal exception in interrupt"),
resulting in a hard system freeze. On systems with buggy firmware that
triggers page faults during EFI runtime calls (e.g., accessing unmapped
memory in GetTime()), this causes an unrecoverable hang instead of the
expected graceful EFI_ABORTED recovery.

Fix by replacing in_interrupt() with !in_task(). This preserves the
original intent of bailing for interrupts or NMI faults, while no longer
falsely triggering from the FPU code path's local_bh_disable().

Fixes: d02198550423 ("x86/fpu: Improve crypto performance by making kernel-mode FPU reliably usable in softirqs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
[ardb: Sashiko spotted that using 'in_hardirq() || in_nmi()' leaves a
       window where a softirq may be taken before fpregs_lock() is
       called, but after efi_rts_work.efi_rts_id has been assigned,
       and any page faults occurring in that window will then be
       misidentified as having been caused by the firmware. Instead,
       use !in_task(), which incorporates in_serving_softirq(). ]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/platform/efi/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -771,7 +771,7 @@ void efi_crash_gracefully_on_page_fault(
 	 * If we get an interrupt/NMI while processing an EFI runtime service
 	 * then this is a regular OOPS, not an EFI failure.
 	 */
-	if (in_interrupt())
+	if (!in_task())
 		return;
 
 	/*


