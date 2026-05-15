Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF1C30DD1D;
	Fri, 15 May 2026 16:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860841; cv=none; b=Wa0iqKTmcz9voUlWtXrL5MG5XZGrd3fSjBzBv4GhkHcdSg4FmQaxpfWkA6S2/WctRFk80DO+av3MfjwmzZSW21FYEhUDIUGsJoW8fxH7kNnEN3NIiNeogM29Jf99EbGTEfZlr6ItjLWAGAX6wGTLZpNYrXVkYY4w4VlPO7oUAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860841; c=relaxed/simple;
	bh=Lvjgk5DAput2VjNHrNdf62TthRZXI1UvNo6G3koSNjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roQSnMwjwcI/dNESce0817lLhARxEcGy1pPEwSLPX+Ei2KV8M/ATE9AveWLSK3b56+qG+xKkoIGhUlYMzw5cyF1YUkf4Z7bqhxTzeUwUzguxwyFefofV12vzrsGdZWs2eGiz9m/nDOiLczZkZa305Abn/bJRBc+G/4qsi70LJXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3l1Bw7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3l1Bw7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB749C2BCB0;
	Fri, 15 May 2026 16:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860841;
	bh=Lvjgk5DAput2VjNHrNdf62TthRZXI1UvNo6G3koSNjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3l1Bw7shSvYAAQiwkgpgsJJl38oioKSRdaYxP56Ub12beZbczsKR4W1mhrgNb9O3
	 EzV/lqkmHTU9YJSByFotLRG90bKn4w6LyXIkDhpvEY7/nvmHVrJN8ipsdVRSXjBdlJ
	 gRxO0LQ0xl3xXXEHKynZzcVLsbUd5v+Xsb9XxFOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 098/474] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
Date: Fri, 15 May 2026 17:43:27 +0200
Message-ID: <20260515154717.159868256@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2494,6 +2494,9 @@ static int invlpga_interception(struct k
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
 		gva = (u32)gva;


