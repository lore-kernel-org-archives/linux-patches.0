Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9921046D2B9;
	Tue, 21 Jul 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654029; cv=none; b=i79geh0vVHozCSVYbvom2jaaQeSUSh4RVP1SCbyvBg/RlQLtxH6MFGmund5jEhkClKVJuz4EdLSo6NVSYgV2EZ81xsXGrEhe6xXJCQtLCtGlZd3ySXeoOFY/jjiJFnSGLnaZet27/mTCjmuLAGT36JAracG6NendxXYuPyDWFAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654029; c=relaxed/simple;
	bh=WYF7pvSelvjOaOQEWfU0fCgxcVFhROB9vWIXNnbycG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQf3POBnFc63xrU4xxlWXhz7/ITKsirL7wbUR17Xf/a79bov2MhVqtkmS4RqUjMn1wpBtUsQzbTDeFRsXesKsp0xsYLHXpEQUn+i2+HMW2AN8w7NdHY9E/1WBP+GbiCmQn/CJORx4NCUOMFMQPFPf4ALQJK4tlgPtg76QKu1UOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7cEWJGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7cEWJGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3231F000E9;
	Tue, 21 Jul 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654028;
	bh=Tk7nO2z1H3SBKbNv+2sLhCYvMgxP2q/H+87B0K39di8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7cEWJGKNQmYm7zbqMsu3zd1ckpqJg+DFE6mZ0TeO2RXUlLbx4zIdQdO6tB0yPcTg
	 eztlDWM3cOHZynAHlpuKLJBzhNwJCMic4b+DDVgq6t3Fa0N6BLM0WxDC3Ird7VSrpf
	 jX6ang0DjdQwrqrJCGxUrzcqHIZZeP4o7ytN7dxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 1549/2077] LoongArch: KVM: Check the return values for put_user()
Date: Tue, 21 Jul 2026 17:20:22 +0200
Message-ID: <20260721152629.314053120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Ma <maqianga@uniontech.com>

commit fb89e0fe2dc4246c86ad0eb0fa2b7cb2f8ba9728 upstream.

put_user() may return -EFAULT, so, when the user space address is
invalid, the caller should return -EFAULT.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1108,7 +1108,8 @@ static int kvm_loongarch_cpucfg_get_attr
 		return -ENXIO;
 	}
 
-	put_user(val, uaddr);
+	if (put_user(val, uaddr))
+		return -EFAULT;
 
 	return ret;
 }


