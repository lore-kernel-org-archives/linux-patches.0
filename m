Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B692A2745E;
	Fri, 21 Nov 2025 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731866; cv=none; b=YgaY/9Lk1UKmOXD4JBwYTneWa7Au/Xro5l3N3cz+z2EGRI320pDEoFHu6rlKsXeV4VQX6Ls9JW5aeKFG8+G19hVK4yjj2HPwNIVNn8dqCVLSO47tq3AQeTW526EmKH+PASwWAMDFVnHjBsdtCGQeNY4EyRkhXLLgLg38HL/sdjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731866; c=relaxed/simple;
	bh=UJzzoSxgUk2czMG+3/1xIsyuPB/AaJX9VENSnB5LImM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJMn3+a/EAd9HodutyK2jXbPgQ1gP98PuUwDmGMsB3td+2l9TOHfx//es3PTTogG4DfFovlOGQA6X5sSeIFJw7ausisHc5Y4NuZX7aXy+ltIjrITVAnYGBGV/vF9x9I/Zpc7zeQIDSsUnXafQl6hw9Ss089aalB2PtMR7zRmEFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGW0LCtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGW0LCtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C39C4CEF1;
	Fri, 21 Nov 2025 13:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731866;
	bh=UJzzoSxgUk2czMG+3/1xIsyuPB/AaJX9VENSnB5LImM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGW0LCtgJtQQgYeACXo+TWSPuuYt7F59n7oFGPEJfXxQ527lTTZcbv0bwGCyOR9Dg
	 mYS7W3LHnhS5zrj5ZjA0azhfokVfAcZEZ9lVU12RWfrIUk89JB9bNMmsl/05xV7JI8
	 tEUT8Cv/RJSRCrWnI6NpqIYNRtzON2YjMrWT8Eh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 108/185] LoongArch: KVM: Add delay until timer interrupt injected
Date: Fri, 21 Nov 2025 14:12:15 +0100
Message-ID: <20251121130147.771610087@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

commit d3c9515e4f9d10ccb113adb4809db5cc31e7ef65 upstream.

When timer is fired in oneshot mode, CSR.TVAL will stop with value -1
rather than 0. However when the register CSR.TVAL is restored, it will
continue to count down rather than stop there.

Now the method is to write 0 to CSR.TVAL, wait to count down for 1 cycle
at least, which is 10ns with a timer freq 100MHz, and then retore timer
interrupt status. Here add 2 cycles delay to assure that timer interrupt
is injected.

With this patch, timer selftest case passes to run always.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/timer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <asm/delay.h>
 #include <asm/kvm_csr.h>
 #include <asm/kvm_vcpu.h>
 
@@ -95,6 +96,7 @@ void kvm_restore_timer(struct kvm_vcpu *
 		 * and set CSR TVAL with -1
 		 */
 		write_gcsr_timertick(0);
+		__delay(2); /* Wait cycles until timer interrupt injected */
 
 		/*
 		 * Writing CSR_TINTCLR_TI to LOONGARCH_CSR_TINTCLR will clear


