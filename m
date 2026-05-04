Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2285A3E120B;
	Mon,  4 May 2026 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904654; cv=none; b=DnoPENyGd2lVP3osL8jllgTcGUzems0IilkHeYEDb4iHRnL8NxDHOen8ejvDeCkaSy3Va5Y2bIZDjY3npzEyQIkJXOfaW3Etgl44/r/NBTwcU6VaQpF8cAGcc8pUYRbuPsspCrPToxzG3dKg3vUVgraKmOSzoMORr8dWDO4sloU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904654; c=relaxed/simple;
	bh=6z1qe6+1oM89j0Au8m+dq1CMuIyQIstsN6i4i7ADmB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfgZuS8gF0kdKyajeWQ9uEylNjT8FM824G6XlKwN5ctRFmW+10uY+lbnUR3uW22C2kP+pcPFTD4SZoxwNgMGBA7G9N0tiVlimUN17wb00LEC+i+05Ieh30Ak2uKpKmCQynhOOG3hksoAeD+d9uJMETw1JDhkPOQZU5wRODPQf8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3LO5bVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3LO5bVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F77C2BCB8;
	Mon,  4 May 2026 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904654;
	bh=6z1qe6+1oM89j0Au8m+dq1CMuIyQIstsN6i4i7ADmB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3LO5bVmFDoyLz/rjvOgduAb6kEG/UTQvDOYXiM6RsE7zuS0bBcMh/FoJqieoaeVM
	 zTfbGwtdKtfrTQT+9zaUpR2Mh2Ifgpis7gMc3fGj2j25t1ziHyHDHegyKax19aAJOG
	 +wmqwOeFh5V1i5vPb4W3UkZTRdlacwuMsPWRVEVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 122/215] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
Date: Mon,  4 May 2026 15:52:21 +0200
Message-ID: <20260504135134.609239449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Cheng <chengkev@google.com>

commit d99df02ff427f461102230f9c5b90a6c64ee8e23 upstream.

INVLPGA should cause a #UD when EFER.SVME is not set. Add a check to
properly inject #UD when EFER.SVME=0.

Fixes: ff092385e828 ("KVM: SVM: Implement INVLPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Cheng <chengkev@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260228033328.2285047-3-chengkev@google.com
[sean: tag for stable@]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2555,6 +2555,9 @@ static int invlpga_interception(struct k
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
 		gva = (u32)gva;


