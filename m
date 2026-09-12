Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0D732D43C;
	Sat, 12 Sep 2026 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237670; cv=none; b=s4X2bSPrzdnGn4MX1Y2IXUyzoc5HuiDw4cxE1gmB1OxAyoTzmlKqeakql1m1r2o7rGcBhfg5d8lN6N4Uu4mQTbJG2Q6lPbuQZDTV8kVniP9QKGt4HYFIQfRld/E1JRfxwJoM+xvfSklJxOgOl3wf5VfM/iO0a1mwTP/IdNgZIkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237670; c=relaxed/simple;
	bh=5XJeeJpBJz68B4sYt+mFrtg92SYpAKuNqR9kONiCeUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Km5wZWdVVUVZgthXMZXzIKdVFIQvJlHL1Oz8pmeOrdCtKZb9uqlVJOi3fkPFDN5Vaz4x9cgIViLMf7kWoRy5RHEaYUrEm1E2xXqwpIH2YCCzkTVO+vBUJpP1JlZmwqZIrxt2CZtQE/rT+CtIG2FNArnS3TVm0CpTHNLHjc7Ury0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBvI3NmD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBvI3NmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53B71F000FF;
	Sat, 12 Sep 2026 18:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237668;
	bh=vT0UfSJMpVfKQvSdWqi8BHAMsVgckBNjKlULb8uRRGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBvI3NmDV6g/HMYr++v/13gXxrtBqFFQEQeRS2whrAYllXzk/ahhSwz415C0SFP7b
	 evkZVb5Xk3Gc2gg4bZ1WPSwFWYBuamN3DzE4VvJ3HxTgsL3vSb009vLZGnx2lxHkba
	 EbiQDO/TzMjMrxfVPFjNZ9PhrbU88jDK2gIdpg1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.15 303/935] KVM: s390: Fix memory leak in guest debug handling
Date: Sat, 12 Sep 2026 08:55:33 +0200
Message-ID: <20260912065533.759887058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


