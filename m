Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1419C19149F;
	Tue, 10 Sep 2024 10:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962752; cv=none; b=nE9oXUYl/OX/obun77SYwJT8rOD6tvdQHAnd8aGqRUOHGwg97lCNAGa93ev52+oJ9Ylka/nUHjSBVuqx1jKUleb5q0jFJgOvrHf1Xg86M5ZuUgo0/HiuBOGYx8A6D1kmgxX/nbD06QJryMwa+qpPaQvEKD26WKt7bxwbHIYTb14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962752; c=relaxed/simple;
	bh=gqLNdxtM6RkhatIGoatsZDXSoog/nCi8z+qTpcE28dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faikcUFu0riRymu/KQgi8W1EdLCF0XGC9GDDjo2CywaFlRyyMTIKYkAngBky44RQJ4Wks7XWMMqZcCUk1UjQD/97LnRvnRXlI9GSMffDmkpBkFpAmWeAlEJugZii9/DT/IHQmaN1aERct7/dHxa2MnprI3EYznP6XBn5SyJ7mL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5/H2gih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5/H2gih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F73C4CEC3;
	Tue, 10 Sep 2024 10:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962751;
	bh=gqLNdxtM6RkhatIGoatsZDXSoog/nCi8z+qTpcE28dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5/H2gihCiLkGqi2ZHhqXuLzT/nyKF6UkNUI/dIQBPof5SusApC5C/PbfD69XagNl
	 mAZd0gcJcrfBw1DwIM+2nKkGJvYYsJN7rJXP9ows/pSvRhDtopnqb+n/zk0MQHwEAk
	 IoHZfXWFiujNDUOoLS4d7JqhIVw3aqF1tXbDtSnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 004/192] KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_GS_BASE
Date: Tue, 10 Sep 2024 11:30:28 +0200
Message-ID: <20240910092558.076360059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2756,6 +2756,12 @@ static int svm_get_msr(struct kvm_vcpu *
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
@@ -2982,6 +2988,12 @@ static int svm_set_msr(struct kvm_vcpu *
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


