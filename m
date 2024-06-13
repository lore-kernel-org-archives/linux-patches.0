Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F238144D3B;
	Thu, 13 Jun 2024 11:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279434; cv=none; b=gX7sEP2FUNrLI5FLFWMsEBladNDY0ZikJiPifsuxD3u2gW7DnRyT6lbOfow9YQOnsuQTSdN4AC6+sF67j10QRQglFcirbgGjquft9V0OgsMW1izyqdRxeQDr70KW1bmTo25GDtEsPpvVDZy7tIk//A+9g+5XvBUR/CIX0NcPm3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279434; c=relaxed/simple;
	bh=0CEl8uEaU+kfkB0YrndyP4nxIgyvh9KXf4oIzKJKMjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLzmwSxNWHRia9Gi08czPApggM1Gv0HsE7k7vX2f3aS1Gq1xQNteZ0zTOKOpCCOd6ismYqhNIYXC9A7YDTQCSlLAI6GbtX2okG6oD4JDRiFESm0vD64qefd+g96E249Jwd2RipmGqa5vABGK1RjsLHGv4Kukia89TFX7JdZ2UW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/7/TCwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/7/TCwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9E4C32786;
	Thu, 13 Jun 2024 11:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279434;
	bh=0CEl8uEaU+kfkB0YrndyP4nxIgyvh9KXf4oIzKJKMjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/7/TCwvZx8a+J2+BWf9XaQRStOnaZwV3gtPCo199FYcRBJrBbL4oXm8ok48d2DPp
	 x4N55jVrPwKdZrKqNXN/gpFrHMStlbSCA1F/3U7qN/AsxzvvbCrhyYa38o/qvAC3P/
	 8WUpHRdKzNmURX35mwZm9+9BlwsyjOymOrzKHkB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Santosh Shukla <Santosh.Shukla@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.9 057/157] KVM: SVM: WARN on vNMI + NMI window iff NMIs are outright masked
Date: Thu, 13 Jun 2024 13:33:02 +0200
Message-ID: <20240613113229.632584510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit b4bd556467477420ee3a91fbcba73c579669edc6 upstream.

When requesting an NMI window, WARN on vNMI support being enabled if and
only if NMIs are actually masked, i.e. if the vCPU is already handling an
NMI.  KVM's ABI for NMIs that arrive simultanesouly (from KVM's point of
view) is to inject one NMI and pend the other.  When using vNMI, KVM pends
the second NMI simply by setting V_NMI_PENDING, and lets the CPU do the
rest (hardware automatically sets V_NMI_BLOCKING when an NMI is injected).

However, if KVM can't immediately inject an NMI, e.g. because the vCPU is
in an STI shadow or is running with GIF=0, then KVM will request an NMI
window and trigger the WARN (but still function correctly).

Whether or not the GIF=0 case makes sense is debatable, as the intent of
KVM's behavior is to provide functionality that is as close to real
hardware as possible.  E.g. if two NMIs are sent in quick succession, the
probability of both NMIs arriving in an STI shadow is infinitesimally low
on real hardware, but significantly larger in a virtual environment, e.g.
if the vCPU is preempted in the STI shadow.  For GIF=0, the argument isn't
as clear cut, because the window where two NMIs can collide is much larger
in bare metal (though still small).

That said, KVM should not have divergent behavior for the GIF=0 case based
on whether or not vNMI support is enabled.  And KVM has allowed
simultaneous NMIs with GIF=0 for over a decade, since commit 7460fb4a3400
("KVM: Fix simultaneous NMIs").  I.e. KVM's GIF=0 handling shouldn't be
modified without a *really* good reason to do so, and if KVM's behavior
were to be modified, it should be done irrespective of vNMI support.

Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
Cc: stable@vger.kernel.org
Cc: Santosh Shukla <Santosh.Shukla@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240522021435.1684366-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3843,16 +3843,27 @@ static void svm_enable_nmi_window(struct
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
-	 * KVM should never request an NMI window when vNMI is enabled, as KVM
-	 * allows at most one to-be-injected NMI and one pending NMI, i.e. if
-	 * two NMIs arrive simultaneously, KVM will inject one and set
-	 * V_NMI_PENDING for the other.  WARN, but continue with the standard
-	 * single-step approach to try and salvage the pending NMI.
+	 * If NMIs are outright masked, i.e. the vCPU is already handling an
+	 * NMI, and KVM has not yet intercepted an IRET, then there is nothing
+	 * more to do at this time as KVM has already enabled IRET intercepts.
+	 * If KVM has already intercepted IRET, then single-step over the IRET,
+	 * as NMIs aren't architecturally unmasked until the IRET completes.
+	 *
+	 * If vNMI is enabled, KVM should never request an NMI window if NMIs
+	 * are masked, as KVM allows at most one to-be-injected NMI and one
+	 * pending NMI.  If two NMIs arrive simultaneously, KVM will inject one
+	 * NMI and set V_NMI_PENDING for the other, but if and only if NMIs are
+	 * unmasked.  KVM _will_ request an NMI window in some situations, e.g.
+	 * if the vCPU is in an STI shadow or if GIF=0, KVM can't immediately
+	 * inject the NMI.  In those situations, KVM needs to single-step over
+	 * the STI shadow or intercept STGI.
 	 */
-	WARN_ON_ONCE(is_vnmi_enabled(svm));
+	if (svm_get_nmi_mask(vcpu)) {
+		WARN_ON_ONCE(is_vnmi_enabled(svm));
 
-	if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
-		return; /* IRET will cause a vm exit */
+		if (!svm->awaiting_iret_completion)
+			return; /* IRET will cause a vm exit */
+	}
 
 	/*
 	 * SEV-ES guests are responsible for signaling when a vCPU is ready to


