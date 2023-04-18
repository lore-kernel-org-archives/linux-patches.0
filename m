Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001212566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776A8C433EF;
	Tue, 18 Apr 2023 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820706;
	bh=68LnmH4ScpxejkDjg45kUGtRl36NyvXpBHRPiypKo/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIiQS2AftCshzUyCZCWuTiMkQHUPiWj96wRaoi1y/aKkEJ70DhhP0jlLuVNEbkV8f
	 iBYGDEBaDtso8kdSjrjD0u/3cfrxWttdHyJ595p6c/ZLrhacm6htKYKtHWBvwPbTeo
	 Dc75bbZwiJhKddkl0i25R/D3ZlJGquGMytzjpVoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <marc.zyngier@arm.com>,
	Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH 4.14 37/37] arm64: KVM: Fix system register enumeration
Date: Tue, 18 Apr 2023 14:21:47 +0200
Message-Id: <20230418120256.029568255@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <marc.zyngier@arm.com>

commit 5d8d4af24460d079ecdb190254b14b528add1228 upstream.

The introduction of the SVE registers to userspace started with a
refactoring of the way we expose any register via the ONE_REG
interface.

Unfortunately, this change doesn't exactly behave as expected
if the number of registers is non-zero and consider everything
to be an error. The visible result is that QEMU barfs very early
when creating vcpus.

Make sure we only exit early in case there is an actual error, rather
than a positive number of registers...

Fixes: be25bbb392fa ("KVM: arm64: Factor out core register ID enumeration")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/guest.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -326,17 +326,17 @@ int kvm_arm_copy_reg_indices(struct kvm_
 	int ret;
 
 	ret = kvm_arm_copy_core_reg_indices(uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += kvm_arm_get_fw_num_regs(vcpu);
 
 	ret = copy_timer_indices(vcpu, uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += NUM_TIMER_REGS;
 


