Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBB03E5A0E;
	Tue, 12 May 2026 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608145; cv=none; b=RO6WQHr5n6N/WWqBIL8SdlnZj55Q9/l0SvwgoknbJ/fxPfk25lmKUquJwgTFKwycnv3CHKw7Mo4osx7qHtEP0Arrss1SrCYq6bdP/tva4FciejVZF7/j7OkgwXRDUWrMtQ40S2LRBeOrc0+KjYOhlrBcbo6YGPmJ6NcvjgFpohw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608145; c=relaxed/simple;
	bh=A6gzWuuf66GzTDbvkqz+1ouMpmhInCmwRZ8gUL54NTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNCA2ZWAfG65HM9dv8N3orJKayzMvOKHOzXIGCHyIPQQaHuIeQExZtYOi9tbEjNAleNPmSAuKpSkdv3Mu1suehng49Yozj80egbO4gXGaUiM13nDewaxHvOJs4mC8c7fLDb9+5eGBvp2EwxlwhMljs1wZb8v3gn/x1VjS+hwHUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGcHCGa6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGcHCGa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46578C2BCB0;
	Tue, 12 May 2026 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608144;
	bh=A6gzWuuf66GzTDbvkqz+1ouMpmhInCmwRZ8gUL54NTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGcHCGa6ZbLDaYgYSzwR5qDPHmj7qf1egC7iqAuwTERw9TZ8F/eGp1VvYoQRZ4D2m
	 4hUTNXt5FQ3bucXTRnBHaRBoiLEFRC7fqd8d2f+PuHME2OBNDI6YV4eFx6Ud+iIkN7
	 rqt4WEsNvzbykA4SrZQ9A8n5vLIzx8IKKtj1G0ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 172/206] LoongArch: KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date: Tue, 12 May 2026 19:40:24 +0200
Message-ID: <20260512173936.503467120@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

commit b3e31a6650d4cab63f0814c37c0b360372c6ee9e upstream.

It doesn't make sense to return the recommended maximum number of vCPUs
which exceeds the maximum possible number of vCPUs.

Other architectures have already done this, such as commit 57a2e13ebdda
("KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS")

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -91,7 +91,7 @@ int kvm_vm_ioctl_check_extension(struct
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;


