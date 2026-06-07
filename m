Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEBA2C1595;
	Sun,  7 Jun 2026 10:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828289; cv=none; b=E+HhX0DKFPOhSBpzKsDcZMTyUSkVHGkxkKI0HFirmVjIbn+ok3rQ6JzPrsM2gsb3ZD44A1LBSGowcOgFD+wd7TTUUH1IeiOJQja1Cl+FIwvqF7irZnkTjuBm8i5NlTnX3SQZJpUA3/5k5zy7pCrkIODBOtMFf5qAcS8tq9nw6I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828289; c=relaxed/simple;
	bh=abhQTFAX5utivuBGtwbXVWcR1hcD0ygxQn7jvYfCooU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUdipD+j3bN+dVZuo2gHXWe4Hm/v2bePxgX66wKij7XTp7k5oN5lb9h6nhhx45nDM/rxOEwKAdYIztLhXJzagmvOqt2SUNzQdqZZUkWsYL96qebaVRx7DFXZqiW8xlwCHMriPisWftORJkKGO9H1KMDIQyWmlm/PcleUubMz/W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFsLpJoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFsLpJoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843F41F00893;
	Sun,  7 Jun 2026 10:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828288;
	bh=kUnQE+hzVJS/2Z1r2cDqyVRI5rHBf14p4Uawv35GYMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFsLpJoS+wbrCBrQDKLFp8hEFjgFIo55qrhDmbBTY+zxSbupibyL2qSQi2ATqQD12
	 io9LHJQ5bNln2Xygesk0BeMVSFPmmjS8mHAT7j9RhD4+JKLB7Tn9F4ZKRXx6+d1SEm
	 1aGj+ph/z4BgbAVusxm0KyFCdPPwTS7wRjQOFmxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 147/315] KVM: SEV: WARN if KVM attempts to setup scratch area with min_len==0
Date: Sun,  7 Jun 2026 11:58:54 +0200
Message-ID: <20260607095733.004031696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

commit f185e05dce6f170f83c4ba602e969b1c3c7a22e6 upstream.

Now that all paths in KVM properly validate the length needed for the
scratch area, and are guaranteed to pass in a non-zero length, WARN if KVM
attempts to configured the scratch area with min_len==0 to guard against
future bugs.

Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3617,6 +3617,9 @@ static int setup_vmgexit_scratch(struct
 	u64 scratch_gpa_beg, scratch_gpa_end;
 	void *scratch_va;
 
+	if (WARN_ON_ONCE(!min_len))
+		goto e_scratch;
+
 	scratch_gpa_beg = svm->sev_es.sw_scratch;
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");


