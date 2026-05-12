Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B06136A378;
	Tue, 12 May 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609577; cv=none; b=T4NpNCTT5grlMjDJIrAOkcK6/eAW7UFsU/xn2R7fduYAuDi2Jng5Y0fny09KEUIRvoVdNESTq1LyucFtGpMxTt+XaBwyuo25+VRcXhf0+lCVyP9z3hMIRBjNBzBLDoYsGqnYD+/jN0i0sty/cV6Gl1sPvzgH3sXc78JYzFcYsrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609577; c=relaxed/simple;
	bh=pYoFiyjRHDKDKECANz3JQb585C21Z1Ar4tPcnBtgmmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsUmQ+qdzO4DVv5Qd5+IK4OhVLR4JGBKKFhNuYzXCXGizTPl4wDfa9y8Hta89T4Gb4msyMtMNZg0GVQe5nt1hdo9zvxS7Cb8G+rVqJ73y/CCkRcCp8EkQshcPB1dCEX9tjqnsnUqp4BYUdXeOc/V3d+G6f0lYcEzABJvcesjQMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW6dHQUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW6dHQUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D1FC2BCC7;
	Tue, 12 May 2026 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609576;
	bh=pYoFiyjRHDKDKECANz3JQb585C21Z1Ar4tPcnBtgmmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW6dHQUxP1Z91ihX+MKDh+bE55XA2sc8K8wg+Nf001aQVF/g/TSDkcLO9RGom1JRp
	 bDPoDED11Iy5g7haVLKWSkJlMtNLMXomDy9dzLoNLfpvMZcxIGIfMy+06R8US4fZCt
	 ivL1vAcR1JOavLNieoiA6Ia9loV+189ppbxol57M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Andy Chiu <andybnac@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 7.0 207/307] riscv: kvm: fix vector context allocation leak
Date: Tue, 12 May 2026 19:40:02 +0200
Message-ID: <20260512173944.487500110@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit b7c958d7c1eb1cb9b2be7b5ee4129fcd66cec978 upstream.

When the second kzalloc (host_context.vector.datap) fails in
kvm_riscv_vcpu_alloc_vector_context, the first allocation
(guest_context.vector.datap) is leaked. Free it before returning.

Fixes: 0f4b82579716 ("riscv: KVM: Add vector lazy save/restore support")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Link: https://lore.kernel.org/r/20260316151612.13305-1-osama.abdelkader@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_vector.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -80,8 +80,11 @@ int kvm_riscv_vcpu_alloc_vector_context(
 		return -ENOMEM;
 
 	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
-	if (!vcpu->arch.host_context.vector.datap)
+	if (!vcpu->arch.host_context.vector.datap) {
+		kfree(vcpu->arch.guest_context.vector.datap);
+		vcpu->arch.guest_context.vector.datap = NULL;
 		return -ENOMEM;
+	}
 
 	return 0;
 }


