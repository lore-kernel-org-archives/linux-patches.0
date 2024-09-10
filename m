Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C3818B46D;
	Tue, 10 Sep 2024 09:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961285; cv=none; b=rEDxZI5g/kJTe16Tno8x9f0IlpY4xOU14Wg1F3LQ137FUqt6HaqQyFD+0Gv+mWMS9I7jvJ9rT/DKn4uY1KoEoMzStsyJWqNeHlNOVNXIyo53jOLy+uzW4GgHakuiDRgLD1cC+KSk1ZfJTJsW9xcrBrsCOrRZs2N+YPXMWTs1LHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961285; c=relaxed/simple;
	bh=9Z5asG++OxZfAFz4RlQ1PH5W0OuwAIYqiL9I/idQ/IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2rFaQxoqt3YDjT0jVa13ZXohHDH+84QaAv3YAKg8I5MvSUsJYm89Q1f14EgLH9a+jIGs74PiOnu2Fs0Tg7oFrjrieIbxkIWHI1VWdhzW0yx0J919GecbqwFLuhFV75lp6pnoyotO4wr/JV1IPw81l8S8UTYNWhEmixZu0ZrYSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVBzK/kS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVBzK/kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC5EC4CEC3;
	Tue, 10 Sep 2024 09:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961285;
	bh=9Z5asG++OxZfAFz4RlQ1PH5W0OuwAIYqiL9I/idQ/IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVBzK/kSzDv68HcN7reM/0pgJ0nKo2WNZ/bORviK9VgQqoj1wE0lyf9lGuLWhH04Y
	 uqr9WkZobuNxSmrqeJ4LeCq3mVTG+AzL7PjG5+0PsIBksNIVNuM6dQkKgNVSgHIBuv
	 m6SJLL3PG8kchPyiQe+YQEG6wJH3Kkiy+UkR+pQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.10 009/375] KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_GS_BASE
Date: Tue, 10 Sep 2024 11:26:46 +0200
Message-ID: <20240910092622.573894846@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2863,6 +2863,12 @@ static int svm_get_msr(struct kvm_vcpu *
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
@@ -3088,6 +3094,12 @@ static int svm_set_msr(struct kvm_vcpu *
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


