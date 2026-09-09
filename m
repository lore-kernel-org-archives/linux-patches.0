Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C392D9780;
	Wed,  9 Sep 2026 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962568; cv=none; b=uYq0HSVb2Gei6+gNcP0e0DO6kyGe7tPez6hEFB3yWt+xJce7xn0abEXgc8zd/ztSq/r23AFOyFpbN3g0TklPh4dVuu3UScR/HZUC+bX0K5yJm6Yh1SMKKOqLhWIF+yq4bAzKDkUWUFL24kyL5wqrNRA+wUrJnK34H6YDrniqVJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962568; c=relaxed/simple;
	bh=VaqWMyM2xkC364gp9Q70TROmdE6fcAvwivdaliqIMuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N53+4A4U3Uv6n6C08vPoByS3r4Zfb8rEIJMi1H6ttY2O8DA7hHyV2zqbu4hloDufQPRbC7mhqzfz5TTlbAFl6xXElXMvsXdK+D+XQMjM4Kb5VEPmXZJTR/Pk5n6X4ZAKH2H66OcWf2GXlaLE/FJ5Lr6bdahvKUFhs1vvLu/vegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdJPcPWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdJPcPWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E781F00A3A;
	Wed,  9 Sep 2026 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962567;
	bh=ZzvTObVEr5Le6dPKu3u/7WXiQ86ZPwHR5uYj+DB/JK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdJPcPWnZ9LuFjhQdKkdSJBjtsacsfbGO8GaBY1G7RtcYglg23hOeOHq1t6SJXXQh
	 rG0mvE4q9qjzfpK3RWLLJWnWwbCFEYWEIpgidtXf0xp12lXK6JRbsqXnEvKqnwdYrl
	 oVpE78vmlk7+9u5QfLwyCMWxutVd6e7kHnikeLwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Zeng Chi <zengchi@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 334/556] LoongArch: KVM: Validate MSI data before routing it to EIOINTC
Date: Wed,  9 Sep 2026 15:40:14 +0200
Message-ID: <20260909134242.407170863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Chi <zengchi@kylinos.cn>

commit 501514d6ebd2111c353a1296f25dbe22fbd64657 upstream.

pch_msi_set_irq() passes e->msi.data straight into eiointc_set_irq() as
the irq number. The MSI data comes from userspace, that either via a
KVM_IRQ_ROUTING_MSI entry set with KVM_SET_GSI_ROUTING (used by irqfd
and KVM_IRQ_LINE) or directly via KVM_SIGNAL_MSI, and is never checked
against EIOINTC_IRQS.

eiointc_set_irq() uses the value with __set_bit()/__clear_bit() on the
256-bit isr bitmap, eiointc_update_irq() then indexes sw_coremap[] and
the per-cpu coreisr/sw_coreisr bitmaps with it. Therefore a data value
>= 256 reads and writes memory past the end of those arrays, i.e. any
process holding a VM fd can corrupt kernel memory beyond the allocation
of loongarch_eiointc.

Reject MSI data that doesn't fit in the EIOINTC irq space. The DMSINTC
path is unaffected as it decodes the vector from the address and masks
it.

Cc: stable@vger.kernel.org
Fixes: 1928254c5ccb ("LoongArch: KVM: Add irqfd support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260531140921.1B1181F00893@smtp.kernel.org/
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/pch_pic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -78,6 +78,9 @@ int pch_msi_set_irq(struct kvm *kvm, str
 		return dmsintc_set_irq(kvm, msg_addr, e->msi.data, level);
 	}
 
+	if (e->msi.data >= EIOINTC_IRQS)
+		return -EINVAL;
+
 	eiointc_set_irq(kvm->arch.eiointc, e->msi.data, level);
 
 	return 0;


