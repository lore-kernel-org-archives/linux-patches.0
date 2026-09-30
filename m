Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45497524B0A;
	Wed, 30 Sep 2026 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790507; cv=none; b=OVCxoIB61Jqgl13xZpHHl6EphWAdeqKp30s6+AqPOXraiyk4jV905VREsMU9ZF0KljQcG497MTT2008YoyC/oLwL3gpfUoQCvmtXgDfffF/hwD0mx07JQ2+/6rnOfMFyOzBXVS16LgZlD89R+wdFvhgmJeElAmuDcfqFu1I3dak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790507; c=relaxed/simple;
	bh=u4s/O96mxGO0SDkUyLFDM/qyVkzutsweZ5AbF+ZSKcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipwFtr5cUpnMbMknPBcIo4Ty3u99OFNLIhq5VJvaTxHTKvp8YKOuU806jETs44ZnR0SDS6dsFTfYX2+bsXwZfURxpiHKaH/RkbuZjYWa6qL4CAADU9fqOyeSCxVY/fXl/gBfXWSffbmLgahQC6tbz9PLGyPwpHQH+l8dodTqBuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClDlE/3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClDlE/3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32341F00898;
	Wed, 30 Sep 2026 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790506;
	bh=j9sTP6gs5XYYZtbBFCvzmTIMwDvqk3+vKcaPBIPR6OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClDlE/3tCP951hxRMj2bsYOibU3I4xVBeAyBFESlbjsHjf7zM/+7DM8NG2jm2oIPL
	 oAuyYSEvDCklXpcrknm33cjC1PSTiSqu/M1+hEAT1EPhIXb7HK8O1Jx2Yjfw0SVkri
	 JtwqDn9c783gIJeXeWei2xuJVMqbShLnOzNQVwOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 853/877] RISC-V: KVM: Serialize IMSIC attributes with vCPU migration
Date: Wed, 30 Sep 2026 17:29:24 +0200
Message-ID: <20260930152433.148035858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Xie Bo <xb@ultrarisc.com>

[ Upstream commit 8ae12ccaec6ec74945d8c1ef39f2c1b8df779abc ]

KVM device ioctls are not serialized against KVM_RUN. As a result,
kvm_riscv_aia_imsic_rw_attr() can snapshot the physical CPU and HGEI of
an IMSIC VS-file before a concurrent vCPU migration releases it.

The HGEI can then be allocated to another vCPU before imsic_vsfile_rw()
uses the stale tuple. A GET or SET attribute may consequently access the
new owner's interrupt file.

Serialize the entire IMSIC attribute operation with the target vCPU
mutex. This prevents the VS-file from being migrated and recycled until
the attribute access completes. Acquire the mutex killably so that the
device ioctl remains interruptible while waiting for KVM_RUN to finish.

Fixes: db8b7e97d613 ("RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Bo <xb@ultrarisc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260810-imsic-attr-race-v2-1-00ed95ad321e@ultrarisc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/aia_imsic.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -895,9 +895,14 @@ int kvm_riscv_aia_imsic_rw_attr(struct k
 	if (!vcpu)
 		return -ENODEV;
 
+	if (mutex_lock_killable(&vcpu->mutex))
+		return -EINTR;
+
 	imsic = vcpu->arch.aia_context.imsic_state;
-	if (!imsic)
-		return -ENODEV;
+	if (!imsic) {
+		rc = -ENODEV;
+		goto out_unlock;
+	}
 	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 
 	read_lock_irqsave(&imsic->vsfile_lock, flags);
@@ -921,6 +926,8 @@ int kvm_riscv_aia_imsic_rw_attr(struct k
 		rc = imsic_vsfile_rw(vsfile_hgei, vsfile_cpu, imsic->nr_eix,
 				     isel, write, val);
 
+out_unlock:
+	mutex_unlock(&vcpu->mutex);
 	return rc;
 }
 


