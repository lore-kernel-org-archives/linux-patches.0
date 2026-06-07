Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A96132AAD6;
	Sun,  7 Jun 2026 10:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828267; cv=none; b=WpJoApdqPNh9UvNEls6U9JaAtRnHjWUNPbfi9/7O/vQJQktInRuEtIF5pB42kekz5IjDiSkF8dDxd+e5O+xpewt3nMR8vGa87bf7FL2ozfZ4ZM2wji4FT+PLX5dgW0aBjhNaLpVafpZ1xdhDoyNXzjMpGbe/IhoaOVVktAN6ke0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828267; c=relaxed/simple;
	bh=HPDpCw4WfpzWGLOdk4nttvcXC+MD2kaPyErePkipZlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjmsKuXBtLRNsWFnaNEVJXDj2yXdsnnBoQ+Zrz5UDM2lzNtektRMw6UCv3hsUaxAZc51zbHYsmbvJXaMimvYJCcKXhBTdol2lxhbrAq3nLkvKVYzkMIJg4mcKIeEplXI0ve/hAZQlQ2iot+CgajUsct7rUwtP7ZZ0Sx+8KGioc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxksFNLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxksFNLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4981F00893;
	Sun,  7 Jun 2026 10:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828266;
	bh=GltwVCuo4e65V/mRlWN2NUcOMsewYnSrLYzWrJ1weUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxksFNLA1Hn3fYH/inAGeMcD41dzaZrPEhcaQJqEa3CiVx8ecVre7Lrc8X5IdR6jB
	 QGPBuubJ5vb+wSnOkRZ/3PKA92QgUBKIgQG1btH+rjQI9ZRI4jFFEW9S9aA7991J+j
	 mto+g8DqF3nae/UyVHJhGnwgPjEKu2EQ9I2e2S3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 145/315] KVM: SEV: Ignore Port I/O requests of length 0
Date: Sun,  7 Jun 2026 11:58:52 +0200
Message-ID: <20260607095732.929090398@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 3988bd2723de407ae90fa7a6f6029b4e60238c58 upstream.

Explicitly ignore Port I/O requests of length '0' (or count '0'), so that
setting up the software scratch area (and other code) doesn't have to
worry about underflowing the length, and to allow for WARNing on trying
to configure the scratch area with len==0.

Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4499,6 +4499,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 			    control->exit_info_1, control->exit_info_2);
 		ret = -EINVAL;
 		break;
+	case SVM_EXIT_IOIO:
+		if (!((control->exit_info_1 & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT))
+			return 1;
+
+		fallthrough;
 	default:
 		ret = svm_invoke_exit_handler(vcpu, exit_code);
 	}
@@ -4519,6 +4524,9 @@ int sev_es_string_io(struct vcpu_svm *sv
 	if (unlikely(check_mul_overflow(count, size, &bytes)))
 		return -EINVAL;
 
+	if (!bytes)
+		return 1;
+
 	r = setup_vmgexit_scratch(svm, in, bytes);
 	if (r)
 		return r;


