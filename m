Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BB214D431;
	Tue, 10 Sep 2024 10:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963456; cv=none; b=FDIbrroI0mhKgoufrrHrmNsNuAtAmB52hbg5KKjhXqu2pA5Wc9tcPRSCrVxIiSckzf3losByx9dLN5JvLToPUO4La7VLvvIUXrjL0+7lOYoJ1fBnz9vRZb2MAjJb3MMAR4Fes0eg9ebFVJr+L5/+MpTH2h4r/NM0//WN2NYn3a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963456; c=relaxed/simple;
	bh=3z5K016P5qiK34JzJh4iNaGEmoBJZ/ZNvVimOhCjrNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBqKtMfJO2JM/FqhkO2pcLaGJlfKpzddH2Sg4ppOvSwqrZw4RUnwo9bzx2EXe7G625jbZG5sRLiXHTvZ1rMfk/7/mLD94N3JGbqaZwU/ny16Lw+O9pu5PPnSicK1r4ZusVyogf6GA2HY1DPwUKFhRiT+h1nddo1bFZn2oHhH4Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emRNZM9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emRNZM9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3F8C4CEC3;
	Tue, 10 Sep 2024 10:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963456;
	bh=3z5K016P5qiK34JzJh4iNaGEmoBJZ/ZNvVimOhCjrNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emRNZM9wrbkKQVhkdT7zCkC+GNE4H8mQcNcufT1EVOlFUfK2u1tkMWjMzVKlAQ0mK
	 ydMh7ymMVi5E7Mes9yX3jpqOs5qqriSQKlfcUgdeQD88HMIH1+QcoYig2kHpjPu4S0
	 1AA++wlICh1MQvspxl7/rZowrjlVGELw0z7Ppc9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 064/214] KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_GS_BASE
Date: Tue, 10 Sep 2024 11:31:26 +0200
Message-ID: <20240910092601.383595427@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2712,6 +2712,12 @@ static int svm_get_msr(struct kvm_vcpu *
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
@@ -2923,6 +2929,12 @@ static int svm_set_msr(struct kvm_vcpu *
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


