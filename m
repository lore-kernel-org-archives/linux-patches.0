Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD8C3D904D;
	Mon,  4 May 2026 14:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903403; cv=none; b=BjURtH1yfCEAJrRbnnevbMbo8JapGRS72++6lO4R7PNpZgeWkJTUHPuTKBYGAr3bloMjqBxWqR8D7AqJmmbu/DkRP6bQ6juQ1QnN5cuN1kS1Q3v8Udet8fw3pOvgXECOBD6/LBKV8VqMwOBBLKNc+c6qGBSzctM6N7BbjQb/MQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903403; c=relaxed/simple;
	bh=hG/JalBlPignC5W0KeYUUCxbxbguc5x7NP2rMVqMa2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVAybYKFxbSsFtxospHhBon7T8jbnYXYlxHizscntMb+fGa3CpATo/dFLPPNN+Cgs61m1W+nxHIQSEyp3UOnknS0uZixzg/1TFvuaCoSj/Ctcgl4W1/SzQhdchgaEEFdz/K5O+iPaHzPGPHZ1RJpBaLRsAn+kmz5pga1ywvrL2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTYxB1GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTYxB1GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7611C2BCB8;
	Mon,  4 May 2026 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903403;
	bh=hG/JalBlPignC5W0KeYUUCxbxbguc5x7NP2rMVqMa2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTYxB1GSlcRv/qJMRpJ0TkdJ5FsKRFoNdpfuFPL2Qrrb8T6cccDswloaApKUPlAGN
	 8sNpIlXE6ZfHbqLlKIFkPkXMtjV1HYSgg8mcFoH45E6rbscMIC+1goYJMKJioNEQ4r
	 OekryQ94jMb1QLGu+xIXakUWHdcw1F2ZIZJ3L3zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 221/307] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
Date: Mon,  4 May 2026 15:51:46 +0200
Message-ID: <20260504135151.177627455@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1045,6 +1045,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		svm_set_gif(svm, false);
 		goto out;
 	}
 


