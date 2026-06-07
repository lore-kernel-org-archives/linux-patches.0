Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0C9326938;
	Sun,  7 Jun 2026 10:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828204; cv=none; b=juSKRBjHYB6YEUqlel7LA6rAUrmQMNZsVSKxpQ0B3AV0TJEDzqiULsvvVFSN+EV/iRVbgiVRhAn/i6NBsoywCK114Ua6J6bA9lns0mlKm9waiTR1wia30lnDMQ56B1VCTKU2TO7lL/Zr48teVtbaLNLjYsaGAQPOJY/1E7VWBD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828204; c=relaxed/simple;
	bh=x1OXDW7T4Y2KDZnJl9NhVIkwDNlnQREGUEmyCpfbt+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqyHeZYRyv5CXKKqbN7+4jajXl9BuqFnD/Tsg/yjWgnK/vxZ1/5GkmzxVxMXPGoVgcNPG7mhLV1TrFmiG6ummQ51KCj2FPvdrvCaOgHiWh8XG8ihqieJmygvOluoMxjIMMugL5AnhnsRygVd9CloqVM4fHwM9ZKh7C3wAmj/L5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSx8BX78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSx8BX78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8691F00893;
	Sun,  7 Jun 2026 10:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828203;
	bh=+xf3CYSiBHe3s3mG5YSMO/wa+f/u7sFLADyo4YDSdBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSx8BX78N04HGksVmYPm+NMnM7tb5Jv8vmCCGNHCYucLShLwPr0gfQ9XasCkVJ6Ug
	 OuhdinacBMwayMsIPeMj5m3XxM3T6wnfp/AgI6m1HYG47RS7tYB6i19NlSEDw4y7Xw
	 wgP4ljDOO4jZAnUZ66PHJWgUfTLzpeLYJYIT7vV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.0 163/332] KVM: SEV: Ignore Port I/O requests of length 0
Date: Sun,  7 Jun 2026 11:58:52 +0200
Message-ID: <20260607095734.054166839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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
@@ -4545,6 +4545,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 			    control->exit_info_1, control->exit_info_2);
 		ret = -EINVAL;
 		break;
+	case SVM_EXIT_IOIO:
+		if (!((control->exit_info_1 & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT))
+			return 1;
+
+		fallthrough;
 	default:
 		ret = svm_invoke_exit_handler(vcpu, control->exit_code);
 	}
@@ -4565,6 +4570,9 @@ int sev_es_string_io(struct vcpu_svm *sv
 	if (unlikely(check_mul_overflow(count, size, &bytes)))
 		return -EINVAL;
 
+	if (!bytes)
+		return 1;
+
 	r = setup_vmgexit_scratch(svm, in, bytes);
 	if (r)
 		return r;


