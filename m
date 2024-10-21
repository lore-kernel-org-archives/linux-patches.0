Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F291139FD6;
	Mon, 21 Oct 2024 10:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506767; cv=none; b=ooFtVr3tz+kb/fVgtVZMaWIIXBwGg8oeWVtF10Ug8kF4RBqNl4rRWGC5amoDf3l1dc4nR40qlRuPPBTw7CIlHdTY5WaawbvrBBT9dxq1IJPXydQNFBusR24VkAVZ9lO3LnHYR6dbR/Uxk0Sgdg646a++P9Tn+i2sq3rQLhgDk1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506767; c=relaxed/simple;
	bh=jhfVmdL53pyKjWtkacl7ML7pxqXLunyjdzPDlMFNB/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRbMNk72IT9uyX0c4n1mSn27IvUnOyMzz+GS0UE6nh5dbWxJIwO6WIyY9auCEUVmVCJ0vQTZ0lF3ilgLYpCC1J8OUCsYPbthmDmaOjMVtFOUZZ2n7gW6gzQTF1/gFQqRz/sc1GinYMR2CZ2vp9rFAuv/iKNabL7EzGbRE3mnVQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOQi1gFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOQi1gFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A31DC4CEC3;
	Mon, 21 Oct 2024 10:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506766;
	bh=jhfVmdL53pyKjWtkacl7ML7pxqXLunyjdzPDlMFNB/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOQi1gFsPkrAHy1HEz4xNncg2CzTox2gNGjcVzxfN8cm0jxJ/Sqjy1F0Oqvk2o0te
	 XiNqNqGLsxvO6VSYclEHw1AKY9mebfVUwnq7imRxpwDa93l3qjTY3CsTY2A2VDKL4f
	 18COSW0AHZiaho5UwlnKY65YYbTzALIVH1OzXLd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Todd Brandt <todd.e.brandt@intel.com>
Subject: [PATCH 6.11 115/135] x86/apic: Always explicitly disarm TSC-deadline timer
Date: Mon, 21 Oct 2024 12:24:31 +0200
Message-ID: <20241021102303.827715379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit ffd95846c6ec6cf1f93da411ea10d504036cab42 upstream.

New processors have become pickier about the local APIC timer state
before entering low power modes. These low power modes are used (for
example) when you close your laptop lid and suspend. If you put your
laptop in a bag and it is not in this low power mode, it is likely
to get quite toasty while it quickly sucks the battery dry.

The problem boils down to some CPUs' inability to power down until the
CPU recognizes that the local APIC timer is shut down. The current
kernel code works in one-shot and periodic modes but does not work for
deadline mode. Deadline mode has been the supported and preferred mode
on Intel CPUs for over a decade and uses an MSR to drive the timer
instead of an APIC register.

Disable the TSC Deadline timer in lapic_timer_shutdown() by writing to
MSR_IA32_TSC_DEADLINE when in TSC-deadline mode. Also avoid writing
to the initial-count register (APIC_TMICT) which is ignored in
TSC-deadline mode.

Note: The APIC_LVTT|=APIC_LVT_MASKED operation should theoretically be
enough to tell the hardware that the timer will not fire in any of the
timer modes. But mitigating AMD erratum 411[1] also requires clearing
out APIC_TMICT. Solely setting APIC_LVT_MASKED is also ineffective in
practice on Intel Lunar Lake systems, which is the motivation for this
change.

1. 411 Processor May Exit Message-Triggered C1E State Without an Interrupt if Local APIC Timer Reaches Zero - https://www.amd.com/content/dam/amd/en/documents/archived-tech-docs/revision-guides/41322_10h_Rev_Gd.pdf

Fixes: 279f1461432c ("x86: apic: Use tsc deadline for oneshot when available")
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Todd Brandt <todd.e.brandt@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241015061522.25288-1-rui.zhang%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/apic.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -440,7 +440,19 @@ static int lapic_timer_shutdown(struct c
 	v = apic_read(APIC_LVTT);
 	v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 	apic_write(APIC_LVTT, v);
-	apic_write(APIC_TMICT, 0);
+
+	/*
+	 * Setting APIC_LVT_MASKED (above) should be enough to tell
+	 * the hardware that this timer will never fire. But AMD
+	 * erratum 411 and some Intel CPU behavior circa 2024 say
+	 * otherwise.  Time for belt and suspenders programming: mask
+	 * the timer _and_ zero the counter registers:
+	 */
+	if (v & APIC_LVT_TIMER_TSCDEADLINE)
+		wrmsrl(MSR_IA32_TSC_DEADLINE, 0);
+	else
+		apic_write(APIC_TMICT, 0);
+
 	return 0;
 }
 


