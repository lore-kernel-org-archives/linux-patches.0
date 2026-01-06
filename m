Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B4E28C871;
	Tue,  6 Jan 2026 17:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720400; cv=none; b=RhDX4mmb9hta0/0BPtL/lHvfSx97qGx9HPOIif1+eUorWzeiSCgS5wIgagwmlKTC3ME7V2tOBj/SL6kh/0kfttFP/ZjnJzHc1V00wEOZyUIwHy4p5phSfwatNQy7cMcSgbKnxCscNCaELrKS77zxyd/oda7Ol3wybWM0Zrsu3kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720400; c=relaxed/simple;
	bh=p+kcgAs09Oe7qPnyL2os80B/DSDW7h4g5DA6JTZm064=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuqidXFwG0R13CsMBapNu6XPgkUM/umkIMctEtn/2WyIpOSEJOxHwJdEpmUSC6B7Qgl0JQ8P7genO5YBBIXCnUhzz8DCYpUjdQvd0AlMxte+89y0jIZbDMGe+Rj/s1afPYXWnhbgbM3Q/D+U3bMWoT4Wsj1zAEsH4nFMPq1guFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8UfdKPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8UfdKPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF78C116C6;
	Tue,  6 Jan 2026 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720400;
	bh=p+kcgAs09Oe7qPnyL2os80B/DSDW7h4g5DA6JTZm064=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8UfdKPo73MIQ/d8WyLoBtQDsiT+eo3HkqB45L+ULGmZjFuKPpJfKMB/xEBbCDLuK
	 mDtXXcBWqTrHP+gBUmFe3jiff3F5+OWi0A02YYzP9JTsVJICxU7ecn7Mg+Xp6M2jqj
	 URowEMZHLJPZa5U5xva8xNrPVioVm2RgOtzk4ERI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Rizzo <matteorizzo@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 226/567] KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
Date: Tue,  6 Jan 2026 18:00:08 +0100
Message-ID: <20260106170459.673699967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jim Mattson <jmattson@google.com>

commit 93c9e107386dbe1243287a5b14ceca894de372b9 upstream.

Mark the VMCB_PERM_MAP bit as dirty in nested_vmcb02_prepare_control()
on every nested VMRUN.

If L1 changes MSR interception (INTERCEPT_MSR_PROT) between two VMRUN
instructions on the same L1 vCPU, the msrpm_base_pa in the associated
vmcb02 will change, and the VMCB_PERM_MAP clean bit should be cleared.

Fixes: 4bb170a5430b ("KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit")
Reported-by: Matteo Rizzo <matteorizzo@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250922162935.621409-2-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -677,6 +677,7 @@ static void nested_vmcb02_prepare_contro
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
+	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
 
 	/* Done at vmrun: asid.  */
 


