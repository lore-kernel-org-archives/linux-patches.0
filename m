Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0AC1474C8;
	Wed, 19 Jun 2024 13:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802709; cv=none; b=boqcZc1rGVRQEtXSKN4ogInrZ4ohbmO5THdwCNL0+4jViXw01A7NJtUypsHkRtXF4ikCO3tlazkYK/czvIY0o4x9piuubyWopD1kWxtSDtjD4c3fMV68CazOUWD5lkyi5P2v8v1g8uqcLP2q45obYyIz+Ijxzz6SUfqMSbEtWDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802709; c=relaxed/simple;
	bh=PWelcHQVWD2rWxDaGRAYmAMJ2AArhYpoZJOwcpieo6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTR7+d1fc8+RvqAWBjDDzbHxsGc41FeBGTui/vq93l3cVBv6EqImVvHq3wVMEoeKGIN5JIuHI6uuTczkwel2TRCBA3ZJRTBfAK2KFGG7h4MkgcigPKuxVuAzD/Q3L1qJRqQe6WKZD6H8ivUN+UH/phX9EzR/9ls9KRX1m5fGB3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmULxd+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmULxd+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D96C2BBFC;
	Wed, 19 Jun 2024 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802709;
	bh=PWelcHQVWD2rWxDaGRAYmAMJ2AArhYpoZJOwcpieo6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmULxd+L6kQU9tIr3BxYFQmmXNHXWGU8/9aeIs54kDITE2iXBhwovgKwjK3UwAHLr
	 8/r3JIJ0d/E349/KNXws8t+jMtcfg0+/HtkMhouTc/n/VLucbUOJ/k2v8It0cM3r9A
	 bPglKX43rZq0JYc8aw6IKWNfwvhRxFq7ln6Nm0vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 021/281] RISC-V: KVM: No need to use mask when hart-index-bit is 0
Date: Wed, 19 Jun 2024 14:53:00 +0200
Message-ID: <20240619125610.664055925@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 2d707b4e37f9b0c37b8b2392f91b04c5b63ea538 ]

When the maximum hart number within groups is 1, hart-index-bit is set to
0. Consequently, there is no need to restore the hart ID from IMSIC
addresses and hart-index-bit settings. Currently, QEMU and kvmtool do not
pass correct hart-index-bit values when the maximum hart number is a
power of 2, thereby avoiding this issue. Corresponding patches for QEMU
and kvmtool will also be dispatched.

Fixes: 89d01306e34d ("RISC-V: KVM: Implement device interface for AIA irqchip")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20240415064905.25184-1-yongxuan.wang@sifive.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/aia_device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 0eb689351b7d0..5cd407c6a8e4f 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -237,10 +237,11 @@ static gpa_t aia_imsic_ppn(struct kvm_aia *aia, gpa_t addr)
 
 static u32 aia_imsic_hart_index(struct kvm_aia *aia, gpa_t addr)
 {
-	u32 hart, group = 0;
+	u32 hart = 0, group = 0;
 
-	hart = (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_SHIFT)) &
-		GENMASK_ULL(aia->nr_hart_bits - 1, 0);
+	if (aia->nr_hart_bits)
+		hart = (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_SHIFT)) &
+		       GENMASK_ULL(aia->nr_hart_bits - 1, 0);
 	if (aia->nr_group_bits)
 		group = (addr >> aia->nr_group_shift) &
 			GENMASK_ULL(aia->nr_group_bits - 1, 0);
-- 
2.43.0



