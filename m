Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478CE32BF5D;
	Thu, 28 May 2026 19:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998237; cv=none; b=RoNpfAqDBUMXc/pVs8F6KtQfz+8zSqnu/dFdHWQs/zw1ZW4XdlPubFYV3g6ag9McftmJib0rVj/XAI9Sb/YME1ih4yBvbS/LkdOZ1tImOX69kkFEgaa5G2JBHVcdH13OJAIqRU0qkxIvclEw99g2HTK6yIsIZBuQCHK/AGj1wtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998237; c=relaxed/simple;
	bh=KOeQdaJUjdrLB4oLY34rnWvRCoAa1G5AQsueiGSFgqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKWsj6DSqkCh9yX6a78SFIMvlgj2mNRW9bL5nGapcyXmNVkq+G4V/rw4hZgveWny5BADJAJvkzG1Ag2CONv2rBlh081hwJGCepSwgP5oGk5uS8A8SxnLr3LEU7DWlQfIX4zJA12g4zJqnXwBEkfRDKiehRL791rwGfQDl1NPSIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMwEJsQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMwEJsQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D3F1F000E9;
	Thu, 28 May 2026 19:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998236;
	bh=G/OwyHKNbrcmbIZgcoyQcrQLBtVUwN0/9N63BhDGEYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMwEJsQr/bNfIHsILHnSfJZRKjJWaOZQ9AVN4ntipc9TCN6Bf0YUrbHrbyjwLyHRj
	 SPaNAtyZxa7Byy1Sg5bafd9i5Vm1k8HtJOd37i5qORe3XVReCHptrAcF90G4fOzL+h
	 iXWM5ZvAdUfMYxLShGJ1t6Qb3MHMS78CXv945w+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tina Zhang <zhang_wei@open-hieco.net>
Subject: [PATCH 7.0 102/461] KVM: SVM: Disable AVIC IPI virtualization on Hygon Family 18h (erratum #1235)
Date: Thu, 28 May 2026 21:43:51 +0200
Message-ID: <20260528194649.908611217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Tina Zhang <zhang_wei@open-hieco.net>

commit 9a12fa5213cfc391e0eed63902d3be98f0913765 upstream.

Hygon Family 18h CPUs are derived from AMD Family 17h (Zen1) silicon and
share the same erratum #1235: hardware may read a stale IsRunning=1 bit
during ICR write emulation and silently fail to generate an
AVIC_IPI_FAILURE_TARGET_NOT_RUNNING VM-Exit on the sending vCPU.

The absence of the VM-Exit causes KVM to miss the required wakeup of
blocking target vCPUs, leading to hung vCPUs and unbounded delays in
guest execution.

Extend the existing AMD Family 17h erratum #1235 workaround to also cover
Hygon Family 18h.  With IPI virtualization disabled, KVM never sets
IsRunning=1 in the Physical ID table, so every non-self IPI generates a
VM-Exit and is correctly emulated.

Fixes: 8de4a1c8164e ("KVM: SVM: Disable (x2)AVIC IPI virtualization if CPU has erratum #1235")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tina Zhang <zhang_wei@open-hieco.net>
Message-ID: <20260522040014.3380201-1-zhang_wei@open-hieco.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1289,12 +1289,14 @@ bool __init avic_hardware_setup(void)
 	}
 
 	/*
-	 * Disable IPI virtualization for AMD Family 17h CPUs (Zen1 and Zen2)
-	 * due to erratum 1235, which results in missed VM-Exits on the sender
-	 * and thus missed wake events for blocking vCPUs due to the CPU
-	 * failing to see a software update to clear IsRunning.
+	 * Disable IPI virtualization for AMD Family 17h (Zen1 and Zen2) and
+	 * Hygon Family 18h (derived from AMD Zen1) CPUs due to erratum 1235,
+	 * which results in missed VM-Exits on the sender and thus missed wake
+	 * events for blocking vCPUs due to the CPU failing to see a software
+	 * update to clear IsRunning.
 	 */
-	enable_ipiv = enable_ipiv && boot_cpu_data.x86 != 0x17;
+	if (boot_cpu_data.x86 == 0x17 || boot_cpu_data.x86 == 0x18)
+		enable_ipiv = false;
 
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 


