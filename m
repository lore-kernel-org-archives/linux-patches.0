Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CC9311967;
	Tue, 31 Mar 2026 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976908; cv=none; b=GOjVIvA3J68jS5uiDNZG+ATMvRZ3JTKIY+W1apQKKpXw88ypGB199PKXK5KzU52PYZ6hjtzN8OWWu3FWhWHoGxMdPfI6JX1gWtbR6wQE2gPlNkS0YNY5iO8LZMsiso6IcBPp66nfmoOsHqMTRCYusMN6tXx9F3iiJsPSRJPzFMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976908; c=relaxed/simple;
	bh=Ckq3ozTv97i/GKHCRV3itnr60/IZGS7VktKIAIHlYTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOo9V8XxEILkaHfzTRF715JGJIbMZuqnV3Ty7tUBvQS3mBa6OPCHvpOuKsSYnzmEyR9eHhPb3xqAT/yxHLQ59YlKVKd5U1jeFRK1NkquL2zHF8Oh3waynaBdTvDuxA4NCX0cSlvw3UdiXRot2lCnsFCev7behYEdjgUX2kwfSWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeqjyY/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeqjyY/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD45C19423;
	Tue, 31 Mar 2026 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976908;
	bh=Ckq3ozTv97i/GKHCRV3itnr60/IZGS7VktKIAIHlYTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeqjyY/CnVUEboayLEisr/San3fFHTBshOMG9QqVl9Rjed5bsWNKV93g51G/t07a3
	 rGQfpSCfj6szF3xyA/oz5mbqDl38jA7THRp1Yp/nrAbUQszwHfo12CWBsMQadxp63I
	 6u28XJtgu16g3Jcmh5v0qiV3y+FaWc0xHsKx3uig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurel32@debian.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 241/309] LoongArch: KVM: Make kvm_get_vcpu_by_cpuid() more robust
Date: Tue, 31 Mar 2026 18:22:24 +0200
Message-ID: <20260331161802.445210324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 2db06c15d8c7a0ccb6108524e16cd9163753f354 upstream.

kvm_get_vcpu_by_cpuid() takes a cpuid parameter whose type is int, so
cpuid can be negative. Let kvm_get_vcpu_by_cpuid() return NULL for this
case so as to make it more robust.

This fix an out-of-bounds access to kvm_arch::phyid_map::phys_map[].

Cc: <stable@vger.kernel.org>
Fixes: 73516e9da512adc ("LoongArch: KVM: Add vcpu mapping from physical cpuid")
Reported-by: Aurelien Jarno <aurel32@debian.org>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1131431
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -561,6 +561,9 @@ struct kvm_vcpu *kvm_get_vcpu_by_cpuid(s
 {
 	struct kvm_phyid_map *map;
 
+	if (cpuid < 0)
+		return NULL;
+
 	if (cpuid >= KVM_MAX_PHYID)
 		return NULL;
 


