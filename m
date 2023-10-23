Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88214A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAAkHZ6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4BFC433C8;
	Mon, 23 Oct 2023 11:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058980;
	bh=cHamRBfA1TZ1jqBhIm2GuwDFKBNN8+6gEOpVHGUsB6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAAkHZ6A8rahHcIkr9UmTNwkmA42Cc3dMaccqnhmHMw5DS/5ETSYysd7mjXT1wzQP
	 fBIpZXLOkhW0oLxMuH+PLN92dnHQDfcDutL+BK0uRYk4xWmlpDKfX3ukmDVIEpginG
	 pCEb26k9M/zOfMUBiExkdorPSNP9P68GFnomjHjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.5 023/241] x86: KVM: SVM: add support for Invalid IPI Vector interception
Date: Mon, 23 Oct 2023 12:53:29 +0200
Message-ID: <20231023104834.498063284@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 2dcf37abf9d3aab7f975002d29fc7c17272def38 upstream.

In later revisions of AMD's APM, there is a new 'incomplete IPI' exit code:

"Invalid IPI Vector - The vector for the specified IPI was set to an
illegal value (VEC < 16)"

Note that tests on Zen2 machine show that this VM exit doesn't happen and
instead AVIC just does nothing.

Add support for this exit code by doing nothing, instead of filling
the kernel log with errors.

Also replace an unthrottled 'pr_err()' if another unknown incomplete
IPI exit happens with vcpu_unimpl()

(e.g in case AMD adds yet another 'Invalid IPI' exit reason)

Cc: <stable@vger.kernel.org>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230928173354.217464-3-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/svm.h |    1 +
 arch/x86/kvm/svm/avic.c    |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -268,6 +268,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_TARGET_NOT_RUNNING,
 	AVIC_IPI_FAILURE_INVALID_TARGET,
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
+	AVIC_IPI_FAILURE_INVALID_IPI_VECTOR,
 };
 
 #define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -529,8 +529,11 @@ int avic_incomplete_ipi_interception(str
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
 		break;
+	case AVIC_IPI_FAILURE_INVALID_IPI_VECTOR:
+		/* Invalid IPI with vector < 16 */
+		break;
 	default:
-		pr_err("Unknown IPI interception\n");
+		vcpu_unimpl(vcpu, "Unknown avic incomplete IPI interception\n");
 	}
 
 	return 1;


