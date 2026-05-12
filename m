Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CB23C09F7;
	Tue, 12 May 2026 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608147; cv=none; b=pFKfMobfoUm6sq4ACqzynUo0BvC1exqW921UsTzKpyOzQ4SpAvcpBTSCMynmsckTp3UldTYU702bT+WU+dJ7fXaz8d4fs6D/NYcsbY0Aiw10PxW1VTQDZbbg48xiL7Zh0xV/P4jf4sCrvgE6Tf/kxl8onb9I3cccUktGE0Tu8Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608147; c=relaxed/simple;
	bh=mJ7m9s0KqKHkxCR3Cnfw+/rZtPUA+ADFji1I25BLKx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp5cJrkjUHMDwKOhvVXauu2R9kfQ5+f1ZhZnFQRMIkpKrcZ1twV2scq0+0epoMonNumQgyFpcnJj9dPTBzJUZHjk6u9VWxk9lQ8CjchJSKu3XTEbYwUEzHPivXUXnLCKCQZb24b8ZeQ7be7SOGrPh+79SkrRhAwoLF+bxP4WqAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3W6blPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3W6blPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78A4C2BCB0;
	Tue, 12 May 2026 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608147;
	bh=mJ7m9s0KqKHkxCR3Cnfw+/rZtPUA+ADFji1I25BLKx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3W6blPBlUB/7v4mCkVmMckoPydO1DvQp6QefZilu5iOIa9sTj3rhkJYLFVzvcA3n
	 6m/9uU3Nj3OlDD8/fRbkM3JrSDUPGKtxrdfdNd6fKSHJBW/N/xJa7apnfQ8Cxw2Zwl
	 DEuHssZ2qOpPWG5w3Yq1VlXJ4tx7aE0dqbmpGM/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 173/206] LoongArch: KVM: Fix "unreliable stack" for kvm_exc_entry
Date: Tue, 12 May 2026 19:40:25 +0200
Message-ID: <20260512173936.524721371@linuxfoundation.org>
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

From: Xianglai Li <lixianglai@loongson.cn>

commit b323a441da602dfdfc24f30d3190cac786ffebf2 upstream.

Insert the appropriate UNWIND hint into the kvm_exc_entry assembly
function to guide the generation of correct ORC table entries, thereby
solving the timeout problem ("unreliable stack") while loading the
livepatch-sample module on a physical machine running virtual machines
with multiple vcpus.

Cc: stable@vger.kernel.org
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/switch.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -112,7 +112,7 @@
 	.text
 	.cfi_sections	.debug_frame
 SYM_CODE_START(kvm_exc_entry)
-	UNWIND_HINT_UNDEFINED
+	UNWIND_HINT_END_OF_STACK
 	csrwr	a2,   KVM_TEMP_KS
 	csrrd	a2,   KVM_VCPU_KS
 	addi.d	a2,   a2, KVM_VCPU_ARCH


