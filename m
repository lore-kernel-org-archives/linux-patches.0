Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A6D1E6DE1;
	Mon, 21 Oct 2024 10:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507858; cv=none; b=Akpsj4urUSCHJUs88GGaiZ1sK2AyeN8TMHSKw1DO02HdE0unBYc/Nr9idb8sdvfu3uw1NtRK2lRMtxT6fR6Kbq2LJtcvGHmfwsR9o8DcurPaQLXAaESr4LUqoCre7cRN4Iv+9nXHFPwoYDrwPwU1yFEEVoAjanwG23r9CNXo4qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507858; c=relaxed/simple;
	bh=GhM+mxnRVsuJlePRYHVpg5WrewGFUQeLsT6nfY1BKWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEqFHAnVk9UGhWU70Bet6VDnQq8geIle8Kow2OXxG/OiJ/NMZvH8UgGArGvty5WnDPDTs6YixZYNGDnPKx98scvJvS5Fst+9BH+WPYBy7+vG779IOOI/GznJSgu2x0aR/ptYO0TN6ynN2Rdp5XXWFtDhDlaxwrrSxF3JUm26Xr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6Uh7M0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6Uh7M0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A674FC4CEC3;
	Mon, 21 Oct 2024 10:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507858;
	bh=GhM+mxnRVsuJlePRYHVpg5WrewGFUQeLsT6nfY1BKWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6Uh7M0wWWsKK9ZF3KlGGz2rzEohNEJ/H71JoHnXXc0zcldaxUy+7+78fYrCmDiYz
	 dFW0jqp+2I6HmKlrLFOFj89no7YT6CEG2+s/T5jziE/RwyfblbcILPt+7BxtNbP1IS
	 CNbd7S68QwOmgzM8TFXW2JgP5Ee0kXgnKLE4yG1s=
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
Subject: [PATCH 5.10 43/52] x86/apic: Always explicitly disarm TSC-deadline timer
Date: Mon, 21 Oct 2024 12:26:04 +0200
Message-ID: <20241021102243.312526932@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -491,7 +491,19 @@ static int lapic_timer_shutdown(struct c
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
 


