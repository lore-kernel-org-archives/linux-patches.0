Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F287D5678E1;
	Wed,  9 Sep 2026 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962498; cv=none; b=UQs2lOpk93ZIMS+QSTrMUM+tGCcXxgF2SlJc1WTI194yyYNjECBokxofRXfqirk9CnrO59JKL4pnGfS3wvi7bVoFSrKyADckwzBb3QghLfZ+ZNbo5/ZkVRvmshbE0+997RKqVJ/n41izxRBCfqVpiqFStPOlHkoqmDaV7fAU0fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962498; c=relaxed/simple;
	bh=pSnGLjRhCuC5PMR936Hw6uTlY2RLobwj9abwHS004EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5It5lnqO6xmTcse9Sg5cyYPNPYHBLqwfxpOQkkfwnxHqIKA8jMb0ObY1U7kARoOQ3SL2utFHaKicvyD4tdZ/5AHN5gcRY6dBCMntO5M4hYOroXRlRAcNySQ8dV0fPxIvLe0fLIizBw/K57ayjAZ1LwEihlfMtHe9S0WvStYmnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdLPlcOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdLPlcOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC561F00A3F;
	Wed,  9 Sep 2026 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962496;
	bh=/0VESGZ84+2KI9YindAOaJNA+0ZveqwK7uqK/UuBtDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdLPlcOUks5vxd4xmRqzIKawzLVc3C6FZf10hpd1w7/yCi0YqscRHa6HqF8I/qPIP
	 k1L9JGJE6kj8kzmrz0I6VNAhDAOVSJREyN76xcXuAfclaJu2UIrJvwkZ/Wd4RTWBSf
	 KoFVHKvYTGv9ZmKvzU9w8jaRu2fnBjUPK2qqNKL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.2 312/556] KVM: s390: pv: Fix rc/rrc offset for PVM_DUMP
Date: Wed,  9 Sep 2026 15:39:52 +0200
Message-ID: <20260909134241.645538094@linuxfoundation.org>
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
@@ -5736,7 +5736,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = kvm_s390_handle_pv_vcpu_dump(vcpu, &cmd);
 
 		/* Always copy over UV rc / rrc data */
-		if (copy_to_user((__u8 __user *)argp, &cmd.rc,
+		if (copy_to_user(argp + offsetof(struct kvm_pv_cmd, rc), &cmd.rc,
 				 sizeof(cmd.rc) + sizeof(cmd.rrc)))
 			r = -EFAULT;
 		break;


