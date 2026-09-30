Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE3C4FD27C;
	Wed, 30 Sep 2026 18:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793808; cv=none; b=elmfPT/8tomhjIHHqlu/RnE4fHsPuWeiC5OEaAWSzFPBviS34gtfNyLhC4gsPSbvT0BJNsiIN7rhoiqM5h6Z5PqjAGaKXDWMsjVZ7y4MfR4fTzxl5EDTmXSCUFI5OPYBJh3TUWQQMUh3jjQNRKtCxwHve4N4hgOe+EUsFfMuqPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793808; c=relaxed/simple;
	bh=7Tb8hyYss/PfDQXwt2Yx9/ObWNVEkLsTpMFxtgiUgLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS3j57g03mNHsEjQzVfzRcq3wYw+I3Y9JXoXnrG2Fal4PEiXZBQfR/r7BwhEdODik0XdQY6WVVZV+++5tOvmFN8R79/pd1/J5tvmn/kqZkP0y4hXRUrNoimKkmTvmz1YF/NoO51BTxuGTra1um/Zeo+AxFLZzadehhWhzUvn43w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlQ8KI9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlQ8KI9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8511F000FF;
	Wed, 30 Sep 2026 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793807;
	bh=lPo70vZfQLJbgzO53q8c2I8H6PP9tp1zYZ7BQ78T7O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlQ8KI9C7KMoUkb5pklYJHSrP00daji/GFaTTp/lZV4Q9rf2rkjkNDNxq92js9PEJ
	 CmnIu4fXxKtESPRrIKFyz3Z1OWETyYywXl64jNCo7E/bVspCSgjXe9MziFwuPSo50N
	 hz9hb1J8tyfmWsirln5bRHeMIsheKHVtebJRDaUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/395] RISC-V: KVM: Serialize IMSIC attributes with vCPU migration
Date: Wed, 30 Sep 2026 17:30:47 +0200
Message-ID: <20260930152349.054553976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -952,9 +952,14 @@ int kvm_riscv_aia_imsic_rw_attr(struct k
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
@@ -978,6 +983,8 @@ int kvm_riscv_aia_imsic_rw_attr(struct k
 		rc = imsic_vsfile_rw(vsfile_hgei, vsfile_cpu, imsic->nr_eix,
 				     isel, write, val);
 
+out_unlock:
+	mutex_unlock(&vcpu->mutex);
 	return rc;
 }
 


