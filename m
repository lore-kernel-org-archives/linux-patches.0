Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE712DA775;
	Wed,  9 Sep 2026 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962545; cv=none; b=CoRer5z/qsKwmVnwMSL2vTHWLC4yDZskf6b3WVxbdzB8kCEE9ZP6N9EGFl39l4ULAeRCXL+qWKEMg0r2B+GOoM00hcjS85CZTvk7wd5MHdzH245TQW6GA1BXmeaFajyi+Yu67Rt6k8rleKv1waTzPKQntj5eNo6EZgeUMxb/y0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962545; c=relaxed/simple;
	bh=XZBUofFBWNp4Po8+6oI5dD/4mT0z+l0O7mle4JAJmE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROBhORoH7FOegSFwNT4oBIAPbQqQjKVLnLBMhIucAaBiVfTorPdefbQXKpTO4xy4AdEtLPuHzUJrZvjnEvED36doJWCwqJZJqn43IZ5ELRDAcPnBpWg8qVU0k7HmoSLUWQcFSGxpS+F+//zSeFncK5S7Fhg/NIoJ6uVs2+PnHcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbKkqv0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbKkqv0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CC71F00A3A;
	Wed,  9 Sep 2026 14:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962544;
	bh=bcwqr8kDWpue6Sjob2HDjHeqYS85xehIctSc9U58WYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbKkqv0BVGM8JVbwY2ekNNe4U0RsBH0S8RbQw+qY9UZgemPipue0T6SNyzuLUlwOG
	 asjCPO0heYvJZ1p5ZXiagfchCgsM0/ToWDz4GYRrB61k203oIJ4Da39SHwJ9hCQHeA
	 k3igfZFrfaN/pkIHMo/VcmGzUDZKdg1KLHuH9Oac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 326/556] LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set
Date: Wed,  9 Sep 2026 15:40:06 +0200
Message-ID: <20260909134242.127563651@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

commit 32d05564a6128d59ea876cf9078fe6866a809e14 upstream.

In function kvm_make_vcpu_request(), it will send IPI to physical CPU
when vCPU is in IN_GUEST_MODE mode. And physical CPU is set in function
kvm_check_vpid(), thus it should be called before IN_GUEST_MODE is set.
Otherwise IPI will send to wrong old physical CPU where vCPU is running.

Cc: stable@vger.kernel.org
Fixes: 2fc3bd86db4b ("LoongArch: KVM: Implement basic vcpu interfaces")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -300,10 +300,10 @@ static int kvm_pre_enter_guest(struct kv
 		 */
 		local_irq_disable();
 		kvm_deliver_exception(vcpu);
+		kvm_check_vpid(vcpu);
 		/* Make sure the vcpu mode has been written */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 		kvm_deliver_intr(vcpu);
-		kvm_check_vpid(vcpu);
 
 		/*
 		 * Called after function kvm_check_vpid()


