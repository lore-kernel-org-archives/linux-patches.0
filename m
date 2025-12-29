Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF3233374A;
	Mon, 29 Dec 2025 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025920; cv=none; b=sv5eUQX06XjoduCVGUr7HXFvsvkvrMkxpCses3Y++NJU+QeDHmjXf3U3SpazjyhAHZUm4UTEnIv01EOVS9eGWk5RWVTXMHbmBz6eG1tPDzGBoU3iGYxaqje6BD1XOjhWcnx634mLN31MyEVbMvHALyS/1aSelMk1Ib7X/asUmlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025920; c=relaxed/simple;
	bh=znjiqAKiOY8be9/9N7jYioaBxLrRIgrnSbCvnJihBt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M10hd1T8S79IYfNN0FEK24sNkbwKKdxJ7D+kS1fOW8r6LpaX3rdcUZFCFEfXv0pxI5A43Tr9C6Z1KjmA1dr+5m0+KQ9iZZ7673bhsK3uQ/ZYYvs/LmO8l1a0nU6EimRdsPEku+PSNh0OEdkYvn/Un7yHu6NzvSl1zAji0Xaz7ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P47bbdHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P47bbdHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD66AC4CEF7;
	Mon, 29 Dec 2025 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025919;
	bh=znjiqAKiOY8be9/9N7jYioaBxLrRIgrnSbCvnJihBt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P47bbdHyhvg2b2ZU/y9erCNUqdS81z+iMn3qesairXcNdH/FbC4iVivyQ8bBFVSJU
	 PFaPODP85SgAXZQRdEJoeKTjYZEkIZ4K1huo8Xh0GQ2Wh5B1k/olX7UBneGNrMssds
	 8Ud65yimPtHPDcKO94b4nEVFQQNqdfIxXZkqVkSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 352/430] KVM: x86: Apply runtime updates to current CPUID during KVM_SET_CPUID{,2}
Date: Mon, 29 Dec 2025 17:12:34 +0100
Message-ID: <20251229160737.280164584@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit e2b43fb25243d502ad36b07bab9de09f4b76fff9 upstream.

When handling KVM_SET_CPUID{,2}, do runtime CPUID updates on the vCPU's
current CPUID (and caps) prior to swapping in the incoming CPUID state so
that KVM doesn't lose pending updates if the incoming CPUID is rejected,
and to prevent a false failure on the equality check.

Note, runtime updates are unconditionally performed on the incoming/new
CPUID (and associated caps), i.e. clearing the dirty flag won't negatively
affect the new CPUID.

Fixes: 93da6af3ae56 ("KVM: x86: Defer runtime updates of dynamic CPUID bits until CPUID emulation")
Reported-by: Igor Mammedov <imammedo@redhat.com>
Closes: https://lore.kernel.org/all/20251128123202.68424a95@imammedo
Cc: stable@vger.kernel.org
Acked-by: Igor Mammedov <imammedo@redhat.com>
Tested-by: Igor Mammedov <imammedo@redhat.com>
Link: https://patch.msgid.link/20251202015049.1167490-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -510,10 +510,17 @@ static int kvm_set_cpuid(struct kvm_vcpu
 	int r;
 
 	/*
+	 * Apply pending runtime CPUID updates to the current CPUID entries to
+	 * avoid false positives due to mismatches on KVM-owned feature flags.
+	 */
+	if (vcpu->arch.cpuid_dynamic_bits_dirty)
+		kvm_update_cpuid_runtime(vcpu);
+
+	/*
 	 * Swap the existing (old) entries with the incoming (new) entries in
 	 * order to massage the new entries, e.g. to account for dynamic bits
-	 * that KVM controls, without clobbering the current guest CPUID, which
-	 * KVM needs to preserve in order to unwind on failure.
+	 * that KVM controls, without losing the current guest CPUID, which KVM
+	 * needs to preserve in order to unwind on failure.
 	 *
 	 * Similarly, save the vCPU's current cpu_caps so that the capabilities
 	 * can be updated alongside the CPUID entries when performing runtime


