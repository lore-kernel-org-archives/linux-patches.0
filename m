Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BE12566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D000CC433EF;
	Tue, 18 Apr 2023 12:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820857;
	bh=LuRK2qy8fMgQcDSs2oCTEPhOfoIRcDqpdlKeAk9cYeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFiemxfOXliVqrm8njebehq6dpwnOsdYFBpncdjgA/rkQF2zCaz60Y3gTm9hWC+4J
	 2MNBIfY/1hK6z7DFX74q22c+8/DQdvNCjqLe9t/De4lZTgwYXNGrIQ3BPz/SvktUUi
	 TiUE6L7Z99L/MigUgb4l+o11OLnF5jWe4AIqI3QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <marc.zyngier@arm.com>,
	Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH 4.19 57/57] arm64: KVM: Fix system register enumeration
Date: Tue, 18 Apr 2023 14:21:57 +0200
Message-Id: <20230418120300.727546696@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
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
@@ -333,17 +333,17 @@ int kvm_arm_copy_reg_indices(struct kvm_
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
 


