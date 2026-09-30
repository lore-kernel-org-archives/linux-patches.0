Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EB0515964;
	Wed, 30 Sep 2026 17:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787889; cv=none; b=F7T4CswE6ZqUHYN/aKfGkmXReckxdn0QQ2yhLNfPS/pnZPKIsRgpNZ6y6IqDaI9wEM7sWhOyFMcxWrHSN1Fj6JCTgNmXlagiUWtar01/6fGpAT8h5q7yLA6B+RiVe/0fGrGVe1Oxm56ny2krPY0gQUruEoOPIqCahudxlpxRrEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787889; c=relaxed/simple;
	bh=qAojShpWmzCoobpuE4r2LuQ/bpUeyCmzonz40iv0tfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fmk96IQoxwg4jsZFwtRVAOxXAzr/r2Vy5zuka/9UUvtsIXgt0UNlIcpTybuhq61vgcnIQx3A336ldeqlie4FYMethH2XwJTWy/0i36if1sBnFyRaXPbfPRfvWxoUIKb2eY53EUn0SPxyyQdovMVbTXoM84eYFiDxwRrKFewTKYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NED2MfnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NED2MfnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5723C1F000FF;
	Wed, 30 Sep 2026 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787887;
	bh=zB20SWm8cAm0S5+oX0/few2WnQF9cSmtkR6zBU3ISFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NED2MfnDXsSbqZJeO/Puc2/D3kWKfvozRLCXigPaoXmQ3L1krpu6S7tuSMd24bETq
	 uDwLVT6aALyPLYpCaCFYFVxFHRDPe5XIlQY//Wy34LbDUX5Xv4qbutZLQxqojDQjlc
	 m9ph5yCMHvzIvBLqAYDcBnFyKcPJ7Wmr0MQI3JS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 387/457] KVM: arm64: Dont WARN on an unknown VM ioctl in protected mode
Date: Wed, 30 Sep 2026 17:28:12 +0200
Message-ID: <20260930152354.348820170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

commit 49d9d295d69d07e850cae35933ba8519e2915f26 upstream.

kvm_pkvm_ioctl_allowed() WARNs when kvm_get_cap_for_kvm_ioctl() doesn't
find the ioctl number in vm_ioctl_caps[], and kvm_arch_vm_ioctl() calls
it for every number the generic code doesn't handle, so
ioctl(vm_fd, 0xdeadbeef) from userspace taints a pKVM host and panics it
under panic_on_warn. The lookup is fed userspace input: return false,
and userspace gets the -EINVAL kvm_arch_vm_ioctl() returns for that
number on a host without pKVM.

Fixes: b12b3b04f6ba0 ("KVM: arm64: Check whether a VM IOCTL is allowed in pKVM")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://patch.msgid.link/20260914093838.1082637-1-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_pkvm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -62,8 +62,7 @@ static inline bool kvm_pkvm_ioctl_allowe
 	int r;
 
 	r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
-
-	if (WARN_ON_ONCE(r < 0))
+	if (r < 0)
 		return false;
 
 	return kvm_pkvm_ext_allowed(kvm, ext);


