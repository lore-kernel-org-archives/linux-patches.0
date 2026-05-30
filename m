Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEAA3546F6;
	Sat, 30 May 2026 18:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165860; cv=none; b=FezAaDt9En61RMbvABlgrulCXdTh+KOi+8xqPdN2GYW+nCElpQzI6fEH6MaP6x90b3cMwp0rsRj+afNPyVWvm+3Lln/XbtrkmJsWKciTOBA8snZH9ul+v8DKgb/SbS8fNrsTiNrAVgduQ8fWKL9imRvUsLUTOYRgPQKutd49luI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165860; c=relaxed/simple;
	bh=oKIjaAnP9Tp4pe2XulAfP51J+bvjOfCxdB//sYAyisI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qd/KA207lD70y9FINT5hwbvoCyjlVCcSyt+mWaTAM6s2y50EC+S7LaQtcBmj2EKmSg6PG/MYJZ9maknyOFRze5RcItoUa/I8dBYpmV0xYaTqSO9dtxB2nCe4xVQwCkPVHQXA+MV0bDkZgd7RVTH5UkycCPT4U2JiG+p/PDQG2TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/Fx+5yo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/Fx+5yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E99C1F00893;
	Sat, 30 May 2026 18:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165859;
	bh=gzcZOGPJKsMKLG+VTlErJSXDUbax8w8itsFtWr1RKnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/Fx+5yoa+9OJKuQ0Ln3Hoe02tdKisLAoTviyHu11tYnX019U4fNayyOdpfbK8OZX
	 cTt72dskL4m6kcrAA2S9wD3BtIex8jP/YpxuDXq1xKlIiQ/EYpLsOyYDlszYofKaNJ
	 ModqQxoz8Md2cgfGy1P1Tqa9lTBpgwtw+oWfMl3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 176/589] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
Date: Sat, 30 May 2026 18:00:57 +0200
Message-ID: <20260530160229.512180199@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit e63fb1379f4b9300a44739964e69549bebbcdca4 upstream.

When restoring a vCPU in guest mode, any state restored before
KVM_SET_NESTED_STATE (e.g. KVM_SET_SREGS) will mark the corresponding
dirty bits in vmcb01, as it is the active VMCB before switching to
vmcb02 in svm_set_nested_state().

Hence, mark all fields in vmcb02 dirty in svm_set_nested_state() to
capture any previously restored fields.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260210010806.3204289-1-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1236,6 +1236,12 @@ static int svm_set_nested_state(struct k
 		goto out_free;
 
 	/*
+	 * Any previously restored state (e.g. KVM_SET_SREGS) would mark fields
+	 * dirty in vmcb01 instead of vmcb02, so mark all of vmcb02 dirty here.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
+	/*
 	 * All checks done, we can enter guest mode.  L1 control fields
 	 * come from the nested save state.  Guest state is already
 	 * in the registers, the save area of the nested state instead


