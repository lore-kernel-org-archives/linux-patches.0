Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9F330BB80;
	Tue, 12 May 2026 18:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608863; cv=none; b=B6gn/Ks/eEKXTawB0bA9KEQjzMfHa2QReDabz0QIYWh0zb3tSRUG68Ovoo0zIkA2aKilihTXd5VlejcmJiLNtY/Z7wrWnq3JBeLk2Z4hX1jlpq5Dido/onbmHK636xrV2TmeA+33rGMEK+zqQGNgAXfItIQ25w3kSoCbRgdmbec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608863; c=relaxed/simple;
	bh=1Jt7thX3w4zDGeS4EvVO98FcqQNNo8gFDlCbMzvTIN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inE8SPbBHz61I5CbthF+tarKa/LBr7DRaYefndkbTDc9/WrOvf8mRe9PhVTFQ7LMKVyMzV7ffd03zRECV4HzCt28oJhLYQEi/gBM8yBYTYO+H5n9OaRkFJbVoIDUkXvwsxNO3NBP5Tulp0HK00QZG2yeohnPiAj3PSPIBSv0eMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAj07BZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAj07BZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C06BC2BCB0;
	Tue, 12 May 2026 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608863;
	bh=1Jt7thX3w4zDGeS4EvVO98FcqQNNo8gFDlCbMzvTIN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAj07BZyBpr0QYFIUbwh2fuh7TYvUQdWusljgP2AAb1QWf1RQa/lBwNg65hRHZYEn
	 HHXhy2ZFVj32tdtGCBRDREmjLk7crsD4BurloelwSHYygkY7rZKUo2Df4BhkAA24FL
	 qrDwgo+LhUF1YP9MDG1HLqdbrPPnRy7KY25TXvHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 243/270] LoongArch: KVM: Move unconditional delay into timer clear scenery
Date: Tue, 12 May 2026 19:40:44 +0200
Message-ID: <20260512173943.554946800@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

commit 5a873d77ba792410a796595a917be6a440f9b7d2 upstream.

When timer interrupt arrives in guest kernel, guest kernel clears the
timer interrupt and program timer with the next incoming event.

During this stage, timer tick is -1 and timer interrupt status is
disabled in ESTAT register. KVM hypervisor need write zero with timer
tick register and wait timer interrupt injection from HW side, and
then clear timer interrupt.

So there is 2 cycle delay in KVM hypervisor to emulate such scenery,
and the delay is unnecessary if there is no need to clear the timer
interrupt.

Here move 2 cycle delay into timer clear scenery and add timer ESTAT
checking after delay, and set max timer expire value if timer interrupt
does not arrive still.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/timer.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -96,15 +96,21 @@ void kvm_restore_timer(struct kvm_vcpu *
 		 * and set CSR TVAL with -1
 		 */
 		write_gcsr_timertick(0);
-		__delay(2); /* Wait cycles until timer interrupt injected */
 
 		/*
 		 * Writing CSR_TINTCLR_TI to LOONGARCH_CSR_TINTCLR will clear
 		 * timer interrupt, and CSR TVAL keeps unchanged with -1, it
 		 * avoids spurious timer interrupt
 		 */
-		if (!(estat & CPU_TIMER))
+		if (!(estat & CPU_TIMER)) {
+			__delay(2); /* Wait cycles until timer interrupt injected */
+
+			/* Write TVAL with max value if no TI shot */
+			estat = kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT);
+			if (!(estat & CPU_TIMER))
+				write_gcsr_timertick(CSR_TCFG_VAL);
 			gcsr_write(CSR_TINTCLR_TI, LOONGARCH_CSR_TINTCLR);
+		}
 		return;
 	}
 


