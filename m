Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A621A76A9;
	Tue, 30 Jul 2024 17:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360171; cv=none; b=aL5KRrs8O+7faQLpVPaBJksvTPQhNkFIQ1dHc44tuLLxjEQasDRjoeDN/Cylux+HEjw6EeNktyJThon8NPnKPwQjYBXx7zfhbVZSowD9xLSsW/JqhWmKnP22vPkRAsihw02XV/3Hn6I0UHkPnnd8+IN1RVXZutAr+jDZ8oP0nyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360171; c=relaxed/simple;
	bh=df56HXy2M8cY18rj59i8gCvsr7ahf928b/sV+YxxnwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHeRabHxw7LatFcRfyC3d3UzLAEP9Jx6F3IFNWWxY4synt8dAvPMZZLMVqPSmYp0gGJ/+UUibVv6Pp0kDHCk+IkHAeTZlPhZbw9o9/Cr9k9jx0pGQlugrNoluR2SL6JXP9lvg97FqEQcr3OOlGS4YVpgEfDZNUn/C2Zk0gdNJqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDVCBgMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDVCBgMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82C1C4AF0E;
	Tue, 30 Jul 2024 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360171;
	bh=df56HXy2M8cY18rj59i8gCvsr7ahf928b/sV+YxxnwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDVCBgMtorGZ7xlC5R+h+plzoQoseQbWg9NxSSzBc7RggRL/okg0dDtF554dRppFq
	 5IkdI9gDutcwkAp9D37CVuNDGlsNvCWluFIW/mYEapBm1LTCAaQ7dJqG65S/GyA/gl
	 kCe07uOghVYKChEXqX7I1K1sfAwgMsfn0wLZKB6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.10 618/809] KVM: PPC: Book3S HV nestedv2: Fix doorbell emulation
Date: Tue, 30 Jul 2024 17:48:14 +0200
Message-ID: <20240730151749.249856693@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautam Menghani <gautam@linux.ibm.com>

commit 54ec2bd9e0173b75daf84675d07c56584f96564b upstream.

Doorbell emulation is broken for KVM on PAPR guests as support for DPDES
was not added in the initial patch series. Due to this, a KVM on PAPR
guest with SMT > 1 cannot be booted with the XICS interrupt controller
as doorbells are setup in the initial probe path when using XICS
(pSeries_smp_probe()).

Command to replicate the above bug:

qemu-system-ppc64 \
	-drive file=rhel.qcow2,format=qcow2 \
	-m 20G \
	-smp 8,cores=1,threads=8 \
	-cpu  host \
	-nographic \
	-machine pseries,ic-mode=xics -accel kvm

Add doorbell state handling support in the host KVM code to fix doorbell
emulation.

Fixes: 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240605113913.83715-3-gautam@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4116,6 +4116,11 @@ static int kvmhv_vcpu_entry_nestedv2(str
 	int trap;
 	long rc;
 
+	if (vcpu->arch.doorbell_request) {
+		vcpu->arch.doorbell_request = 0;
+		kvmppc_set_dpdes(vcpu, 1);
+	}
+
 	io = &vcpu->arch.nestedv2_io;
 
 	msr = mfmsr();


