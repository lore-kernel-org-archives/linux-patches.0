Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6451917DC;
	Tue, 10 Sep 2024 10:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962755; cv=none; b=u7GzXPb7qsxSavmNp7LdfueF7St+lLoZQ6pO1L5ASxrMA+PXbgj1q005Uez/iAUX1BCNc4cfBp0eb66lycryvtBrxAAjgCuItPcbtTiXrxvK6V19fnNs4TAJrQlV/PVjtQu7wfH6+YxG54BARshru5Gz9yqPoXbF7IoVL9MR458=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962755; c=relaxed/simple;
	bh=Kfc8HSb0NGNcRg+3FfmQIfcdFdC6vr09axDjxnVSWcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNfTIcuv6UzlIkltPoKgAK39rVRM8FOJhwmMUx0kbPdgCjChi8MGRg+scWoYzfUN6+pvCGpnqI1ugSwtC4ld9ppPIwQ1Cb0fnS4EK/Xm71iBQr17QihtrdXjczgprMvBhA2qE+D3nrQE6kEw8Ut2I16T/wjcrs6xnvZHZsQhhCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbwKUy3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbwKUy3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968F4C4CEC3;
	Tue, 10 Sep 2024 10:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962755;
	bh=Kfc8HSb0NGNcRg+3FfmQIfcdFdC6vr09axDjxnVSWcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbwKUy3/vl6k3PMQ6041NNY9VXqAp06H6IipO9uTb+RjJGM3hUPk98HJ7cZtakMTM
	 l8mqw5f56ias80sz/n9yoDXGIwjXLtkTw+kxIUqDTn/z+iSVoXOPdS3OggXpazm7Fy
	 4f3jzMzXymNtqwTq0fiOqKlQH0ncz+PuqOo7fBSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 005/192] KVM: SVM: Dont advertise Bus Lock Detect to guest if SVM support is missing
Date: Tue, 10 Sep 2024 11:30:29 +0200
Message-ID: <20240910092558.123831027@linuxfoundation.org>
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

From: Ravi Bangoria <ravi.bangoria@amd.com>

commit 54950bfe2b69cdc06ef753872b5225e54eb73506 upstream.

If host supports Bus Lock Detect, KVM advertises it to guests even if
SVM support is absent. Additionally, guest wouldn't be able to use it
despite guest CPUID bit being set. Fix it by unconditionally clearing
the feature bit in KVM cpu capability.

Reported-by: Jim Mattson <jmattson@google.com>
Closes: https://lore.kernel.org/r/CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com
Fixes: 76ea438b4afc ("KVM: X86: Expose bus lock debug exception to guest")
Cc: stable@vger.kernel.org
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240808062937.1149-4-ravi.bangoria@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4972,6 +4972,9 @@ static __init void svm_set_cpu_caps(void
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
+
+	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
+	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 }
 
 static __init int svm_hardware_setup(void)


