Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A9119049B;
	Thu,  2 Jul 2026 16:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010409; cv=none; b=YW6QDrR4pYeGVLgc3wiTJY1aoU+X9bfjvNY6xb6/80AQAFtqbtz5cYbgwZqoWLmEeQKgOfH8EEa4DEYGdRzqUTA4dYIxijoZFZ4q8nMs0mQKlgFgxD3JB3DbHZ7KqOHdI+2QLtjJ2BdXVFGOrVkeyb0/NWI8g+AZVDgyx0MM3g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010409; c=relaxed/simple;
	bh=k6FQ4wNb7H6rjT0n7OY6luA0xVlzPNOlml/0xGg2/XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0y3c+Zbij0p6x4HLEd72qJFqLE/WrFfKjaaoZgku1yFL/6YDKYbZiEV+rsmu1d30tjtgve8UybeRjzMrRW4E3bXROpGh6+C/Zgxx+xrikgOppEIejHv//dUD8g7z1UDmHaz1tj0G3h3aVEnmkbYvM8+rx+usup6/1QuHH82SoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpEXGStB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpEXGStB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5E41F000E9;
	Thu,  2 Jul 2026 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010408;
	bh=m8BCa82YwIMiQ7TKPg+Bn5y7drTCvYRV49B3/t6RkUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OpEXGStBrMudFUT85bdIC/IpvU2v6ksN+1At/4JwEQnckulPkdCyp5GIkPIecx00B
	 eb+TfF2LAzoGWgx1kY+1oCUzflmL7pvukAxioIT46iH3XpF1NUCQdgYlWLQnudsWMF
	 qaSzIx3pvwamMDjul8GnP6osIkXoaKr+6y8ZcWnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/204] KVM: SEV: Reject MMIO requests larger than 8 bytes with GHCB v2+
Date: Thu,  2 Jul 2026 18:19:14 +0200
Message-ID: <20260702155120.698485132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit dcf1b2d4b0564a27e4ca7c654871aab4f9620046 upstream.

When using GHCB v2+, reject MMIO requests that are larger than 8 bytes.
Per the GHCB spec:

  SW_EXITINFO2 must be less than or equal to 0x7fffffff for version 1 and
  less than or equal to 0x8 for all other versions.

Fixes: 4af663c2f64a ("KVM: SEV: Allow per-guest configuration of GHCB protocol version")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0a01971e33f0b7..497a6e70513570 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4350,6 +4350,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		if (!control->exit_info_2)
 			return 1;
 
+		if (to_kvm_sev_info(vcpu->kvm)->ghcb_version >= 2 &&
+		    control->exit_info_2 > 8) {
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			return 1;
+		}
+
 		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
 		if (ret)
 			break;
@@ -4363,6 +4370,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		if (!control->exit_info_2)
 			return 1;
 
+		if (to_kvm_sev_info(vcpu->kvm)->ghcb_version >= 2 &&
+		    control->exit_info_2 > 8) {
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+			return 1;
+		}
+
 		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
 		if (ret)
 			break;
-- 
2.53.0



