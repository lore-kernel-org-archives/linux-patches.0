Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBDC2FDC5E;
	Sat, 30 May 2026 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165895; cv=none; b=Ut/Mz7qZjBBtSBtQGZ9yio3uC8g/UGUwMUaAgY98uLfALT+1ldL1TRijtV09OAr/2sEoBCQfQKrXf4P09/h8XF1hXeEz/nVLjaJ5vlkQ3381Z6r9DJk9qUxtD2W7a+6zDvXb+1dYTu5uuo0J1Nyfu28nEFo1W+HFM+atCO/pN6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165895; c=relaxed/simple;
	bh=QQ6BZwGUOnDsBLdmqE5Fa5M3xnD2gytcrJ8wwNV4V6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0enQmwu/qFhjOBJUGCh3EHkj0CVyFUeTTPAJrUr9bDAWs5tvfvXis+71LqlWRb/EYagff0JdbcuYgC/BUrlCjXwpyHOfbV7KgI8oxti1aXZQ0YiP4Czh6kgRj65smRwznFUvncml980nyaBwVtPGC/+ViTZA5Es3p5WDMJf6FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJtUIGvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJtUIGvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313D71F00893;
	Sat, 30 May 2026 18:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165894;
	bh=jtfa9lQfUE1vyYfQfNlEZwvUImA5Z+OFsP7j8nb19jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJtUIGvF0rY3afu9VEndNB4R7ZGBXCaf10orRQqp0/58QxTrp22q7zv3m2K8fl60w
	 m06m7+x8tGCVvOugwAHjZDupSe4r8jtnkqKhlVfnMA2gG+m85shet3kt9FHbC0RF90
	 DCknBvSvJVxM+SmTI2nlpgrenWdb+JzPwuVk5M5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 180/589] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
Date: Sat, 30 May 2026 18:01:01 +0200
Message-ID: <20260530160229.617844127@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

commit f85a6ce06e4a0d49652f57967a649ab09e06287c upstream.

According to the APM, GIF is set to 0 on any #VMEXIT, including
an #VMEXIT(INVALID) due to failed consistency checks. Clear GIF on
consistency check failures.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-11-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -532,6 +532,7 @@ int nested_svm_vmrun(struct vcpu_svm *sv
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		svm_set_gif(svm, false);
 		goto out;
 	}
 


