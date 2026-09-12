Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975A9345EA7;
	Sat, 12 Sep 2026 15:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228285; cv=none; b=YBZ1UNMHqiXIl7GyxQTe2w4mKwZhxL29eniTpT92JYsTTo63oW64QexpbP57dGzAUQ1kyvgyiim6PYGx3b9yg182dSJNcbPdi/Cbd2QQxbAXnND8HCNW5E1gp4q8Jj4vRVXG+eJiIM2N+PYQCi0nAmO8ha82V0MA2v2xP5gxcGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228285; c=relaxed/simple;
	bh=gewTmwftVr6OWR9rkJlwX7GEFlGZ48MPIW0uS+y9hcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvMr95ptw++zpPpu7orqCDG+lGHPP1Fp1t7wZ2j1BzYi3NCpcfsXPQQtoHnDuES/5hbb2G119XnnsyOeKqpe4W5j/85BGFJlm0lNP/GWnrSuBB+MiwvUTTDywiPWxStWmoh/J5huydlKdDlLmQPS+NMJoq1z8G1VDnzLzgTul34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnpw9ZgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnpw9ZgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3845C1F00898;
	Sat, 12 Sep 2026 15:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228284;
	bh=ogBoKdMsmlmcdYwQjiESwG5V+v/I0Xp08QfcsbUjtiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnpw9ZgIiNnhHqTztJNSItksMEnhh/tFoM+ZeQmx8fOOZlSMTOJuQN0zyifRyg3qM
	 H29kn/2ZQ8CI7SgdyCT0dSbibJ9jLuRN+tRV8yRCfQfAs9Ps6M3Ef3lnLZrg1zKpTw
	 TXa76WhQ/hiMPedLdj+MzxYR5kRsMKjmptm5ena4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.1 0354/1191] KVM: s390: Fix memory leak in guest debug handling
Date: Sat, 12 Sep 2026 08:51:22 +0200
Message-ID: <20260912065556.180190482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 121ea1de927c8b9bfdf53c31cad27b86d5de0293 upstream.

bp_data is freed only for the error case by kfree(bp_data).
Every successful KVM_SET_GUEST_DEBUG will leak bp_data.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-5-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/guestdbg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -271,6 +271,7 @@ int kvm_s390_import_bp_data(struct kvm_v
 	vcpu->arch.guestdbg.hw_bp_info = bp_info;
 	vcpu->arch.guestdbg.nr_hw_wp = nr_wp;
 	vcpu->arch.guestdbg.hw_wp_info = wp_info;
+	kfree(bp_data);
 	return 0;
 error:
 	kfree(bp_data);


