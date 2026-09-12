Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C58D34D915;
	Sat, 12 Sep 2026 11:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213652; cv=none; b=nz2HQAK2bw3iLcwglfn/NKZrnXZDbtQnnZnoaaxhbu2vZJ3VdBsxoo5tSjSo0o6NZc0qmeYTpB3Jn9nll55Px7eVPdSINC6XFH+xioiMJlIHYZegsNgD6VuVCsqgyu6FkRMQUGUyg2xNLzPkkXKhTDm7LHCeoQkebhOB+PTissI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213652; c=relaxed/simple;
	bh=I5REsfW0Y8N3SZQfbqwGqLkHjAtm1OE472noWaI7nFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8FVPLgrp0oby/sODwBvL98J4MHr2ix82HZkQ4ibwfCpbI9bHFyEW89DP/aXpPhiqhstzGBpZst3FxisYz+uHhOfYwdfl6Tu2uUARESZ6HmDpZAoM5RPreqXt0i9k1eitc+vDGP1I1Q7pU3bZl+fXe09EIxmu3aO2dxosXMEp9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o75a0Zb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o75a0Zb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877911F000FF;
	Sat, 12 Sep 2026 11:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213649;
	bh=UoVge+GrPfkLl6ZpKS00e4Qls6CLbipS1bdxYGTizEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o75a0Zb53DacHAJPd2WvnT7KGznD863TeCA50gX2xOeNbIz8Bqb4K0CnUS0CrtbsO
	 At91QvDz45ygVuQpd0S4q3VbWPHmFo0LCopphqE8r8ureHkbdlZXsmU5QO+XsTPkHl
	 gIbX54sRBs3VCk0n9IRmdE+/5OkqsaGYXnokGWyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 0165/1376] KVM: s390: Fix memory leak in guest debug handling
Date: Sat, 12 Sep 2026 08:43:11 +0200
Message-ID: <20260912065611.229255060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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


