Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE6B33ADBA;
	Tue, 12 May 2026 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608856; cv=none; b=ZwuXCi9shiOkYERKWkqIfSDGRGhaBMYrFMgzJdGqLH1eSmgvVj/TiBamIwDWoCvSBpyEh86xHu0zhqnHBwyldz1vHjL+5FXcNjJ4EG+cy4e7aF3UcvBLg0Wa97qs/cHP9eJnpLB5OQ46RtsJrm+PD5sG947GgZT+Gc2TPMDthAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608856; c=relaxed/simple;
	bh=fQg2KNtcyVzRQzqq/MNcu8Sgp5R//rXwrVZWgkokPNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkkL2S9XUukoERPUAJ7dsniUbtHyOyE1LX0fQnVtPXSlNkLgkOou3PXRE3HdqqlhBVwSq0pdi6Eb6M+mIKashWyyxcmtO/dPBi7vBpAIYxqfigRJhomZzMATYd8Gcro8Ym1XR0OJvjDvUVVwnugzq8ccoQxrOiE3JZubmIr1OlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrCTbepA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrCTbepA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D5EC2BCF5;
	Tue, 12 May 2026 18:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608855;
	bh=fQg2KNtcyVzRQzqq/MNcu8Sgp5R//rXwrVZWgkokPNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrCTbepAtTQ3wIy5ZaIsKdMaa39ea/QFe8pXlJ6XUpgvU8qui3rwFYrLgFR2JJ1BI
	 n6KJR12gQshRce3XOafKVWZO/Ur/3hyQq0SdAZ42QXovP0Z4LV3Tm+efdezW7bKlSR
	 MYjRv5JOF0G4rpTsGBh+ixDllccxSqIzhWIdTA7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 240/270] LoongArch: KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date: Tue, 12 May 2026 19:40:41 +0200
Message-ID: <20260512173943.493327765@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -94,7 +94,7 @@ int kvm_vm_ioctl_check_extension(struct
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;


