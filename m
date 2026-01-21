Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6EE28506C;
	Wed, 21 Jan 2026 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020464; cv=none; b=L3wU3sNvEW2MPadgBIwY1NQ3/85v1ZiBINJbHvRhbgrwdVTkvGtUXwdNy+p0U14ZarPFH/AWomdqxFwnLCQxoq3MQ8mChvzafvXymAvaISjNYCk7kThbmpTSw8XoVviwJjzPdAGFl/+hsMt+UOISXiR9GtlFxA+bv3i1ver6O1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020464; c=relaxed/simple;
	bh=LOWCw9MzjKKPrio+54NOeuFbJ1MLJNEXm5HI6wNXhio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1n5jpqSbQmPZ0RNhhEZAp719qLPGU3tARgwfLPSFtsidDigDv1TZMvtMLY22KoKY3vwFdqHG+2AH5lmFZDGJt1yoFKJAvc06Wnvd5i2nqWgnNRav8co337Klfs0g0GRw3/Dmtk5ZcKY2DcuNDt8tMA7mmLS1GL6ObIDdMpV6Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVOlAx7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVOlAx7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1C1C4CEF1;
	Wed, 21 Jan 2026 18:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020464;
	bh=LOWCw9MzjKKPrio+54NOeuFbJ1MLJNEXm5HI6wNXhio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVOlAx7JCgoe/TirRBxS6Z9p5Pw9FnliOlyjDUx5ABJrME+jaqXQO8P0rhXfQOpK1
	 nSPUwYjT8dO5SvLFG0/egaYurKf3IjXZ/av+tbNY8Zwd62nfSDN4gHVMSeDUdWcTG0
	 yauOx5EIxhzNVbszowclr1toFoxnHAguKTczrzuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 165/198] LoongArch: KVM: Fix kvm_device leak in kvm_ipi_destroy()
Date: Wed, 21 Jan 2026 19:16:33 +0100
Message-ID: <20260121181424.485176894@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

commit 0bf58cb7288a4d3de6d8ecbb3a65928a9362bf21 upstream.

In kvm_ioctl_create_device(), kvm_device has allocated memory,
kvm_device->destroy() seems to be supposed to free its kvm_device
struct, but kvm_ipi_destroy() is not currently doing this, that
would lead to a memory leak.

So, fix it.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/ipi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -459,6 +459,7 @@ static void kvm_ipi_destroy(struct kvm_d
 	ipi = kvm->arch.ipi;
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &ipi->device);
 	kfree(ipi);
+	kfree(dev);
 }
 
 static struct kvm_device_ops kvm_ipi_dev_ops = {


