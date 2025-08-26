Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA38A1A256B;
	Tue, 26 Aug 2025 11:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207472; cv=none; b=fmFg1XIdJigQcyOwSa/J8qzM6f49A/m2NkBWgeGf7zNDTr9berXoFjFVFE9Up98mZ0ZmTRf50Oj+RPkdIwY/1fOEyrgkKOOIN/xF4S5smheFoJmBwLDlS2q7cm3Wscn2PhiWR4A44YKnv4kD5jGWXUIaf9m28wT9Wtej7vNujAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207472; c=relaxed/simple;
	bh=nffwfhQcrR8xClBf0e7iJxzWQj+yFECqae8tyAJYiQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTQGhNGXM4d6C7iE8gLtkFNg50BJL5eWPrmODK500+F3mkrg9nBPN6nu3qZhjgbXYOC9F9m32a6wpuvkIEtQven+L3cPecd8zBaPBztWw2sYpDCpDxza6qdQPMkWGcJHjZn2iafmG1VnPl+9cD41pS1EHjHzVTaUz2Ge3EbxIFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwGxjV70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwGxjV70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38FAC4CEF1;
	Tue, 26 Aug 2025 11:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207471;
	bh=nffwfhQcrR8xClBf0e7iJxzWQj+yFECqae8tyAJYiQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwGxjV70N39Z2MtfIDQABSlTUlrDhVRiHjrDCZvRc+W021rXST7wB8yJ88IOAgfAz
	 aPHBNHdwxf8xNn+9mJxnurtMIlEj4kVdoNSi0tqmtPAEREq2j6dpKz72GyzEepGwkH
	 EPCfr0ifAKLkkAdJl5zdi7CCdg7L+Fd4Oo9de5js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 195/457] LoongArch: KVM: Fix stack protector issue in send_ipi_data()
Date: Tue, 26 Aug 2025 13:07:59 +0200
Message-ID: <20250826110942.187217489@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 5c68549c81bcca70fc464e305ffeefd9af968287 upstream.

Function kvm_io_bus_read() is called in function send_ipi_data(), buffer
size of parameter *val should be at least 8 bytes. Since some emulation
functions like loongarch_ipi_readl() and kvm_eiointc_read() will write
the buffer *val with 8 bytes signed extension regardless parameter len.

Otherwise there will be buffer overflow issue when CONFIG_STACKPROTECTOR
is enabled. The bug report is shown as follows:

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: send_ipi_data+0x194/0x1a0 [kvm]
CPU: 11 UID: 107 PID: 2692 Comm: CPU 0/KVM Not tainted 6.17.0-rc1+ #102 PREEMPT(full)
Stack : 9000000005901568 0000000000000000 9000000003af371c 900000013c68c000
        900000013c68f850 900000013c68f858 0000000000000000 900000013c68f998
        900000013c68f990 900000013c68f990 900000013c68f6c0 fffffffffffdb058
        fffffffffffdb0e0 900000013c68f858 911e1d4d39cf0ec2 9000000105657a00
        0000000000000001 fffffffffffffffe 0000000000000578 282049464555206e
        6f73676e6f6f4c20 0000000000000001 00000000086b4000 0000000000000000
        0000000000000000 0000000000000000 9000000005709968 90000000058f9000
        900000013c68fa68 900000013c68fab4 90000000029279f0 900000010153f940
        900000010001f360 0000000000000000 9000000003af3734 000000004390000c
        00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
        ...
Call Trace:
[<9000000003af3734>] show_stack+0x5c/0x180
[<9000000003aed168>] dump_stack_lvl+0x6c/0x9c
[<9000000003ad0ab0>] vpanic+0x108/0x2c4
[<9000000003ad0ca8>] panic+0x3c/0x40
[<9000000004eb0a1c>] __stack_chk_fail+0x14/0x18
[<ffff8000023473f8>] send_ipi_data+0x190/0x1a0 [kvm]
[<ffff8000023313e4>] __kvm_io_bus_write+0xa4/0xe8 [kvm]
[<ffff80000233147c>] kvm_io_bus_write+0x54/0x90 [kvm]
[<ffff80000233f9f8>] kvm_emu_iocsr+0x180/0x310 [kvm]
[<ffff80000233fe08>] kvm_handle_gspr+0x280/0x478 [kvm]
[<ffff8000023443e8>] kvm_handle_exit+0xc0/0x130 [kvm]

Cc: stable@vger.kernel.org
Fixes: daee2f9cae551 ("LoongArch: KVM: Add IPI read and write function")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/ipi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -99,7 +99,7 @@ static void write_mailbox(struct kvm_vcp
 static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 {
 	int i, idx, ret;
-	uint32_t val = 0, mask = 0;
+	uint64_t val = 0, mask = 0;
 
 	/*
 	 * Bit 27-30 is mask for byte writing.
@@ -108,7 +108,7 @@ static int send_ipi_data(struct kvm_vcpu
 	if ((data >> 27) & 0xf) {
 		/* Read the old val */
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, 4, &val);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (unlikely(ret)) {
 			kvm_err("%s: : read data from addr %llx failed\n", __func__, addr);
@@ -124,7 +124,7 @@ static int send_ipi_data(struct kvm_vcpu
 	}
 	val |= ((uint32_t)(data >> 32) & ~mask);
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, 4, &val);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	if (unlikely(ret))
 		kvm_err("%s: : write data to addr %llx failed\n", __func__, addr);


