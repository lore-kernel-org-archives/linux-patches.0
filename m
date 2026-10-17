Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219E4385D7B;
	Sat, 17 Oct 2026 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258903; cv=none; b=qfrN5SGHTm6dbTDcYKHFl3cEf5YKhqDcN618iMG1kKM29cigrfDjmKP8Rk9iL9zrkIr3Dmlrw5jVH383SQ17ddrmbkXK7XdqihlUqJodFrvpZZjMXCwK673/YbeVEXc4uOH9rRwWofaRQICbqL19Pz5dNdkAdDA+DW0gymqYA7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258903; c=relaxed/simple;
	bh=hEHEqHh83KXD8BPtjMr1JxwVHkU63cLNC7IYjEbeEIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMyk/D4tWVPIc3hIkYnOfkNtdrFLnw6XaEjWJkiElGqWdG2B1gt8amS2W3fn5+nMCjEYgJP9NyAn/HHnkpb9ScLwQCLBfI7+gJu7vZMewAZfY7r8WPuS6DaZH/f+BVIX9w9lSr7kXLlp2vGewkg6bMGh51VArqbGiAXVtBdPIrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihGQxd28; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihGQxd28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787F61F000C4;
	Sat, 17 Oct 2026 17:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258902;
	bh=8CKD9Oq0eisqE/Tv3BwznxUQsYcLCITSs5VZ+YoVxBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihGQxd28StykS+GMI8vtuDxJKaj+XAkRl9mkcrWJKmkeBl91YOUjZ5zzHUPvPGV/X
	 ziwwF48lkucPG+h6WZnAcO3NnIb6WYCT+IYCacoVgmeeU0KgvPLUwM22PzLvlouPj5
	 BM3H39eNu+cPG7Hvri1rEIOH0wUJ72WojWxtaYDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1037/1674] KVM: SEV: Ignore Port I/O requests of length 0
Date: Sat, 17 Oct 2026 17:55:09 +0200
Message-ID: <20261017160457.749277167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 3988bd2723de407ae90fa7a6f6029b4e60238c58 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7602a205cd3cd..75bd73f205ab6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2987,6 +2987,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
@@ -3007,6 +3012,9 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	if (unlikely(check_mul_overflow(count, size, &bytes)))
 		return -EINVAL;
 
+	if (!bytes)
+		return 1;
+
 	r = setup_vmgexit_scratch(svm, in, bytes);
 	if (r)
 		return r;
-- 
2.53.0



