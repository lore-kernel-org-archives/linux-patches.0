Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01D83AA4F8;
	Mon,  4 May 2026 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904069; cv=none; b=m7lGBSSG3EXIB9ea/jX5ZADcfh9R6tBYrfBAqCI5ANfv8lcr5oEIDp4bfd7I+DUFJHDLlYS7C0gIUJN6wIWQDbo/rk4Av6Q9P2S5+OX6GYPgBBkXmE87uPEN5W2QMcb9Ncj/76L+aOEr00ZMidcDSbdXNu4lA5PVTVDqP3vpfPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904069; c=relaxed/simple;
	bh=wgFDb6FcY7v8LhDiuJGc5QTiNa+CJAQfgGca2QHjlJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQ3qDP1bqdFBpPmPVKQcbQSJkHdLlxHADJkX91HVDi/oDkguAkOEiJdl9aInCx12R9YMxnc8wuRgvYns3ORR6FGjhBRQrxWpJa0/OSH3VgVGJcVSLeqhCvx34k5o+1/fOht0KWSXfi4g1rKMjzQXbIPA1DOgk00pDPZ5ZiED0bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iw87RUva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iw87RUva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5592FC2BCC4;
	Mon,  4 May 2026 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904069;
	bh=wgFDb6FcY7v8LhDiuJGc5QTiNa+CJAQfgGca2QHjlJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw87RUvaxXzEeA/p1xdRbrnCQZjceqtuMFLbzNjseQ063Jk6mGd+0aG6iUP071Jhy
	 Q3Kur9rRYsjED5RHDkeMHs4tkih1LGfSyy7fJ8X4InNx2W+7okZ+QOjgcp6WRLqhy/
	 /fF5iKrAVN33yr0nR8xu7yYWZvJceIHTbHf5f6to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Cheng <chengkev@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 172/275] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
Date: Mon,  4 May 2026 15:51:52 +0200
Message-ID: <20260504135149.450480792@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2289,6 +2289,9 @@ static int invlpga_interception(struct k
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
 		gva = (u32)gva;


