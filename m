Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EDA585994;
	Wed,  9 Sep 2026 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963936; cv=none; b=BPunb8FmQ5+P5hmBQAk1kAhy+EQgJHZej0QFuQxFft9nkXjrGyVfAV6NnJ0THRLHhHfIeig8mk9dWnNf0xVq/S80sCUdZ/Pqd6WFkDhL8VjWO3Y7dx9S+Ul33YDilse80t+H/jl5NVf6mY2QI7yIJ4kjRr6GwwSh8HdyKx9MdOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963936; c=relaxed/simple;
	bh=ybD421jRX/1mOgg5zu60U0IfWiSKsGCv84rvqMwTkvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCc9ei+c72Y0p8wQwB4dyVyjvkWL7Pg1uey0RW2gehYuynmSaT1DfqPh1+oyldvlteECSufFv6AQN2rhnfSTPogT0VZ3B93908kxG3c/afrKhknStIDpKYt4v7oHRxBG6eyPQcUouK9Ln8l42O62VcGE/ocipqGtzeOJ2F5oxak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIoaNnap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIoaNnap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2D41F00A3D;
	Wed,  9 Sep 2026 14:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963935;
	bh=YyF106rIDWg2no4ddHID/qhbplMG94OdsG6s/gvFWb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIoaNnapWnBhB/858QkJjV8bqiSGRzRda5wKmpArhUfOT87tHOYgFf65JxUOV0ePD
	 fHlOe7sQG54SccMiSRnwcpVgkycEEbFDnyk1DOolwBRMK9rvmbV5y4w2W4E3UAr89X
	 qItCC1691RYLJ4xuMRkldJSTxsRY1UIFg/8HuCwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.18 250/583] KVM: s390: pv: Fix rc/rrc offset for PVM_DUMP
Date: Wed,  9 Sep 2026 15:38:55 +0200
Message-ID: <20260909134246.782803259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 1e3c8e7b3465fb8a49d3623d2d0f449c0b5b48f3 upstream.

The rc/rrc value is copied to the cmd location of the cmd in the kvm_pv_cmd
structure. Fix the offset.

Fixes: 8aba09588d2a ("KVM: s390: Add CPU dump functionality")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260811153738.206885-4-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -6008,7 +6008,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = kvm_s390_handle_pv_vcpu_dump(vcpu, &cmd);
 
 		/* Always copy over UV rc / rrc data */
-		if (copy_to_user((__u8 __user *)argp, &cmd.rc,
+		if (copy_to_user(argp + offsetof(struct kvm_pv_cmd, rc), &cmd.rc,
 				 sizeof(cmd.rc) + sizeof(cmd.rrc)))
 			r = -EFAULT;
 		break;


