Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215E137CD3E;
	Sat, 12 Sep 2026 19:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242040; cv=none; b=qcOW3ggZMze5OY82nN9aCs53S8b9TSqx2X5Z8ilOGpeXz7whmwNHmOxkYaha2M1HmpC8NvI/PTUFVxw0p+D2JYFrqVMSzFJZt91PjxOcEbV8Alnzavt7dVQY7GlvvA/2oAlDPD48ERumKDuu0cS/twpuSVNFhMDtKKLhBcAyiLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242040; c=relaxed/simple;
	bh=JFac/FW7S1Qf8WQrI6ZwXi3STPDPoCIB6zfkntud2jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnsqSkTZliVJNgqu0T0NyGF9s/QJa57zLTfNBWCad4pY6/FwGkeK5bsbNnLHOUGHGQPiPvLBpCHHHtV73wYK2Z4NNMLRUXNmI66XOgmNdZJtA9ogu+PyqfS0+wBWtCG6pKRZ0Q3h7+6wK6LlvAktoqPY+fL4u677r7C/bPtGA2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThDn/P22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThDn/P22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D541F000FF;
	Sat, 12 Sep 2026 19:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242038;
	bh=IQFfUWD1VKEMa1rEiRiAwhCj+UVISS3PnIG7X6CkZgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThDn/P22Fl9qGvVdO1rOOoahfHbP2PaTibGgZ//eUBaOzgwnSFcGbMey7yT7QOS66
	 bxnaly0XurgR4hm/Occ3CgSePPbDb8SV2wz836gV+uwhKJpujywFGVJmDNPvfJXYFm
	 GGU9Ft9dXnIh8QTq9dVKJQyzC2j1H84gtOIrrt1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.10 264/798] KVM: s390: Fix memory leak in guest debug handling
Date: Sat, 12 Sep 2026 08:58:12 +0200
Message-ID: <20260912065523.209222732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


