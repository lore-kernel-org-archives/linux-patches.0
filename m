Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6783E075D;
	Tue, 12 May 2026 17:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608152; cv=none; b=ul0OZyRhhBGAYk0ExdmYW1sVuyACE3k2Wzqgyf+idkK0HaHxiaRIWHxc9RgNkzRAAaR3YPb1WAe3Ru8qIG+u+LwxW2swfxtV88lJHfntbazmzzNoluIOPiOTBbkrRMrmduzJjRE/ikYUnZ2W3MVe5AgJo9ro17txMoY0a9FcLPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608152; c=relaxed/simple;
	bh=3GCPiJjy+D0ccA6NI9pMO6qLCIojLFYRVOw2E6SjXkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0bisHhH3OGmBOderdChe4U6YNQFGO2K8qzyArvzgpRW+OjTigmBamNI+zR496mP9fps+iksXLLydVGHCG4O0HQGZr+q+34QU7wneV9RIa9axjRNGFW5RryVpxNlfK1RQ4u8oxBPL1XAz5kqtqzEFZJCLpDmPQc4CbO/TECF1gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZ1hLrVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ1hLrVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155DDC2BCB0;
	Tue, 12 May 2026 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608152;
	bh=3GCPiJjy+D0ccA6NI9pMO6qLCIojLFYRVOw2E6SjXkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZ1hLrVts5b73vDkEUc+j6VuKV0sTaEMgCjy3UsWkbZE4fzJZUiEyXdqrHZlF/kPp
	 rKLdj9cwgHes6jGuDTgWcPuloPUY/M5cERZITvGcrpmb1NUnfyUC9GI+dPdBwf/VOl
	 aUHdPuAWS5xMlQWD6vQfGTq808di0b87FsQVpbnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 175/206] LoongArch: KVM: Move unconditional delay into timer clear scenery
Date: Tue, 12 May 2026 19:40:27 +0200
Message-ID: <20260512173936.566912747@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


