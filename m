Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3B1A256B;
	Tue, 26 Aug 2025 11:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207473; cv=none; b=XVx87Mfgcp57/vcTW/knUrgQwSlh4glfgunXVueK/daKSrirISE/zmjytHQaKkBd3Y4gKRkqjBnoSY1VRiwyD1breoI4+INIxRHlGQ9I4OKRSkuOps8F2Hkb8Vncsb/j/XiaiAdmE7+lYRVXgdj/dKDV9JgHQYsH4qRxzXog6KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207473; c=relaxed/simple;
	bh=qNy/Kl/DtA7e8Dh7wozSGcOVJX994g8ITC4IJgS4qDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB9FCQlgQD+9vxZDvDKvNd4/ohxukBS1LEVSp0G1JkxXjbNcurpETqc5NYoEvDVIDWguwZTuX00fPH+uTx+AqHAWXGIQbMOWbLiPeiIu8WZikQsAmwjD8dhe6vlxOVh/pms0geCeaXGbXJIMgMn33xFgv+8Kb+8BDKhs7sTVREg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nrw2rNIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nrw2rNIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F38FC113CF;
	Tue, 26 Aug 2025 11:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207473;
	bh=qNy/Kl/DtA7e8Dh7wozSGcOVJX994g8ITC4IJgS4qDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nrw2rNIHIpSv5dnbnHFUOUwmk7cGCzpzKh59DxFVY38h0KUNFoIDjDhESBEjgMlxf
	 2Y9PmjMV30lHclDWrzkXQ9g8FQqrKAJk3nvXuLfoMtUdVV43K0gnaeS+thuqrQ3ifq
	 hWCi7trcIob7Hc7iUUJ1OGiLwdgRAvg4Xy3KD/Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 196/457] LoongArch: KVM: Add address alignment check in pch_pic register access
Date: Tue, 26 Aug 2025 13:08:00 +0200
Message-ID: <20250826110942.211122654@linuxfoundation.org>
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

commit 538c06e3964a8e94b645686cc58ccc4a06fa6330 upstream.

With pch_pic device, its register is based on MMIO address space,
different access size 1/2/4/8 is supported. And base address should
be naturally aligned with its access size, here add alignment check
in its register access emulation function.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/pch_pic.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -195,6 +195,11 @@ static int kvm_pch_pic_read(struct kvm_v
 		return -EINVAL;
 	}
 
+	if (addr & (len - 1)) {
+		kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
 	/* statistics of pch pic reading */
 	vcpu->kvm->stat.pch_pic_read_exits++;
 	ret = loongarch_pch_pic_read(s, addr, len, val);
@@ -302,6 +307,11 @@ static int kvm_pch_pic_write(struct kvm_
 		return -EINVAL;
 	}
 
+	if (addr & (len - 1)) {
+		kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
 	/* statistics of pch pic writing */
 	vcpu->kvm->stat.pch_pic_write_exits++;
 	ret = loongarch_pch_pic_write(s, addr, len, val);


