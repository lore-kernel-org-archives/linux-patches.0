Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF6915484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGZN3P16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAA3C433C7;
	Mon, 23 Oct 2023 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060008;
	bh=kgDRL7snNTQuyWmm3RKRPS43F0WouPB/+xIT8dkuUGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGZN3P16+3dBYi86Jrl35flJdnmhAOxIpp1meYDxr6+kXUkIJdqlXcN8VAVS7jFVi
	 FsBaJFaNi0RA7W6Zx7MwO/1fwp/c4GouMWOZli7NXBkypGeRApxFa7+7DExsZKPOa1
	 eLyJbuG8DEIpBltx9rORGC8Mnp4DckkrvuV/n9uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 020/196] KVM: x86: Mask LVTPC when handling a PMI
Date: Mon, 23 Oct 2023 12:54:45 +0200
Message-ID: <20231023104829.058093502@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Mattson <jmattson@google.com>

commit a16eb25b09c02a54c1c1b449d4b6cfa2cf3f013a upstream.

Per the SDM, "When the local APIC handles a performance-monitoring
counters interrupt, it automatically sets the mask flag in the LVT
performance counter register."  Add this behavior to KVM's local APIC
emulation.

Failure to mask the LVTPC entry results in spurious PMIs, e.g. when
running Linux as a guest, PMI handlers that do a "late_ack" spew a large
number of "dazed and confused" spurious NMI warnings.

Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Cc: stable@vger.kernel.org
Signed-off-by: Jim Mattson <jmattson@google.com>
Tested-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Link: https://lore.kernel.org/r/20230925173448.3518223-3-mizhang@google.com
[sean: massage changelog, correct Fixes]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2535,13 +2535,17 @@ int kvm_apic_local_deliver(struct kvm_la
 {
 	u32 reg = kvm_lapic_get_reg(apic, lvt_type);
 	int vector, mode, trig_mode;
+	int r;
 
 	if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
 		vector = reg & APIC_VECTOR_MASK;
 		mode = reg & APIC_MODE_MASK;
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
-		return __apic_accept_irq(apic, mode, vector, 1, trig_mode,
-					NULL);
+
+		r = __apic_accept_irq(apic, mode, vector, 1, trig_mode, NULL);
+		if (r && lvt_type == APIC_LVTPC)
+			kvm_lapic_set_reg(apic, APIC_LVTPC, reg | APIC_LVT_MASKED);
+		return r;
 	}
 	return 0;
 }


