Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C33144D1A;
	Tue, 10 Sep 2024 10:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963988; cv=none; b=sjA2aCkTxOVeMzilQZDhVt+S5QB/n/9c6FgIwjEcC9idgn2bQIWqD1f+OJox6XMXdjIKyo2XcNNzwPQ7E+7Vd5fBsCrdLUrJSUKgOajZpuXFAudIYHDYndl2bYp/XtsABLH/VOy2LnjzzZBiGT5XyirfggvYiq3oWrmiI9Fcz0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963988; c=relaxed/simple;
	bh=qPYH7qMGZ3SL6DCChW2eYzQ20GECJbtOipymP2qpXIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkFSToJjDbwv5GANUxwO4tBIVCcLPx1yITRJp58BKQ7Pr6qJS9YcDy322xtOf6A0P7q7Ol8E228i7Ms6IZ3z6dcIxCYacoFoNfzxSpWIfPRDCmk5Afv5C3aS0cqFu3WT/4vFI3hqhdWsj1iqHFlSgZ7wcnlfGYPgjOEeoREwqas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ij/53bYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ij/53bYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B308AC4CEC3;
	Tue, 10 Sep 2024 10:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963988;
	bh=qPYH7qMGZ3SL6DCChW2eYzQ20GECJbtOipymP2qpXIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij/53bYb9fWMKat0KkN908sLzzoltRxVHLYnw7iZ1PLqMmMjX4wCdrOcYmb13HVGz
	 owMdIeGOylOedPJl2kaFSifulpmwnQ/oKw0wOizl1nhH75ofxEARy5OsE9uduO9+MZ
	 73uQrVy3McDCGGvGRy8dOUYBKesANQGer48Hgq/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 005/269] KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_GS_BASE
Date: Tue, 10 Sep 2024 11:29:52 +0200
Message-ID: <20240910092608.425951972@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

commit dad1613e0533b380318281c1519e1a3477c2d0d2 upstream.

If these msrs are read by the emulator (e.g due to 'force emulation' prefix),
SVM code currently fails to extract the corresponding segment bases,
and return them to the emulator.

Fix that.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240802151608.72896-3-mlevitsk@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2869,6 +2869,12 @@ static int svm_get_msr(struct kvm_vcpu *
 	case MSR_CSTAR:
 		msr_info->data = svm->vmcb01.ptr->save.cstar;
 		break;
+	case MSR_GS_BASE:
+		msr_info->data = svm->vmcb01.ptr->save.gs.base;
+		break;
+	case MSR_FS_BASE:
+		msr_info->data = svm->vmcb01.ptr->save.fs.base;
+		break;
 	case MSR_KERNEL_GS_BASE:
 		msr_info->data = svm->vmcb01.ptr->save.kernel_gs_base;
 		break;
@@ -3090,6 +3096,12 @@ static int svm_set_msr(struct kvm_vcpu *
 	case MSR_CSTAR:
 		svm->vmcb01.ptr->save.cstar = data;
 		break;
+	case MSR_GS_BASE:
+		svm->vmcb01.ptr->save.gs.base = data;
+		break;
+	case MSR_FS_BASE:
+		svm->vmcb01.ptr->save.fs.base = data;
+		break;
 	case MSR_KERNEL_GS_BASE:
 		svm->vmcb01.ptr->save.kernel_gs_base = data;
 		break;


