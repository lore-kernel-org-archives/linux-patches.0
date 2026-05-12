Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71893E0730;
	Tue, 12 May 2026 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608512; cv=none; b=qpzIVInTXfhKbZ4XVciYqm0t5cwx2iXO31nVevHMB6+s7A9r4zHZXjySkyRaOcKKtsSUB5neMrxrdgnmd3joJ/4BiGbIDW6aFF9KsDSP6aTl9b2B9p2HtJEEYOX2NCVu86J11p0mx+o8+usgdUoHPeU0KeXMXruY/vuhg7rQgNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608512; c=relaxed/simple;
	bh=/n58lZmzYToF+7ts9CyYD2AELQni4kMl5N3XIznS234=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3JqnKXWOhaU074RehYF6M8uOFyzmVDWTEYDN+ygXqvIlJPB7loSiXQ1vUfe5UTu8aMcPHnLNexjbTP38CIC4NrNYKWHRa19huBuWkjyReSgz2urF08PPf9iJJkuvESRp7S+ch8DtfUULVChl0bZn0wFPhKKgi4xsVOlEXaAqm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAecmyKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAecmyKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D203C2BCB0;
	Tue, 12 May 2026 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608512;
	bh=/n58lZmzYToF+7ts9CyYD2AELQni4kMl5N3XIznS234=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAecmyKerzcT5nMtA81fm9OxeaqGMYSCbxaQBAHhhpVJVOGRrKMZ4ZOGiqduSIu4M
	 V+RGspjN92QbxDwYg7N853PM1Moerhp56qd6s64l+gZqaIu/MHJG51QzB8fv9wQFiY
	 Jc9Hj9UN9zRbnPOjW10GMxUe3sGxJH+Z6ZY6PpSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18 107/270] x86/efi: Fix graceful fault handling after FPU softirq changes
Date: Tue, 12 May 2026 19:38:28 +0200
Message-ID: <20260512173940.711301135@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


