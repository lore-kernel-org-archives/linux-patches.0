Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD511C29
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C9BC433EF;
	Mon, 20 Mar 2023 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326071;
	bh=gK2D7IyUjBvRJi3+9oJhwSxSix+/FsT12U/bkIFrVbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=im6LOj9uyIwyeX/Znm9mFZghDhfB8pw+YiaUWzxf6kl9CqibM4Eld7TIKohYazFy0
	 kRrSy3OQ6RenJPPHemCRyU8Tyq3LM9xUeVUhGLckYdipnr6OFot8yf+Umiyxa0rsxt
	 keUOrqUNiY6CZk9tbV3rYrQT145AlDUQVPAfDhWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.2 153/211] KVM: SVM: Fix a benign off-by-one bug in AVIC physical table mask
Date: Mon, 20 Mar 2023 15:54:48 +0100
Message-Id: <20230320145519.859700036@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit 3ec7a1b2743c07c45f4a0c508114f6cb410ddef3 upstream.

Define the "physical table max index mask" as bits 8:0, not 9:0.  x2AVIC
currently supports a max of 512 entries, i.e. the max index is 511, and
the inputs to GENMASK_ULL() are inclusive.  The bug is benign as bit 9 is
reserved and never set by KVM, i.e. KVM is just clearing bits that are
guaranteed to be zero.

Note, as of this writing, APM "Rev. 3.39-October 2022" incorrectly states
that bits 11:8 are reserved in Table B-1. VMCB Layout, Control Area.  I.e.
that table wasn't updated when x2AVIC support was added.

Opportunistically fix the comment for the max AVIC ID to align with the
code, and clean up comment formatting too.

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-Id: <20230207002156.521736-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/svm.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -261,20 +261,22 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
-#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
 
 /*
- * For AVIC, the max index allowed for physical APIC ID
- * table is 0xff (255).
+ * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
+ * 0xff is a broadcast to all CPUs, i.e. can't be targeted individually.
  */
 #define AVIC_MAX_PHYSICAL_ID		0XFEULL
 
 /*
- * For x2AVIC, the max index allowed for physical APIC ID
- * table is 0x1ff (511).
+ * For x2AVIC, the max index allowed for physical APIC ID table is 0x1ff (511).
  */
 #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
+static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
+static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
+
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 


