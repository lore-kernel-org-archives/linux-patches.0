Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653B7F48D;
	Mon,  8 Apr 2024 13:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583092; cv=none; b=gsMJsJf8wT76mwJk3ZzM6Ca7AKbCcSUIy8oIPjIT2sEG8IKSL58UUEBtXVUzrYnVntZnQ9lsBIaPopblfEKJiD2Io3GFyGiJp5YyjaUHh9bIDeLJvEnSRpGqwuM548xu8PF4/ZnnW/XasvUtpe27CiWCHI4DF2ac+ZMsbPPS22s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583092; c=relaxed/simple;
	bh=RxuSQdjS5NIulvVYgQzZa9oX7LUi4alrSfwR3/gBASo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O15OtS7SJzX6FU8Iy01JU1yJH4Ge8ueLeiSkepUav/LEETcAej4BIqhYDHaA8sTm4V4wWyA2iajt990WfECapuDu8WNoFEeVOKDpba+hWx8VO+zXuc+yEmPIRe/IY98hF15NF0Q+GLVmrn03z02Byw4MOef3hWcJk4kZyC0dLHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YN7SbAS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YN7SbAS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E95C433F1;
	Mon,  8 Apr 2024 13:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583092;
	bh=RxuSQdjS5NIulvVYgQzZa9oX7LUi4alrSfwR3/gBASo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YN7SbAS+GBMGTk20X12E4Qg6TttQvdULHlIA7/ViwEa4Fr2m9S9Tgwdnkq4+j3r3K
	 7mZcPiUANHtRRX8BglUZxvxhONgtJIrJxshu9ck0U7eZm+qk5ucXjB/DjhyqhZ93wT
	 vp4xk8u95XNSpWp2PoMD3eoBdiS//7WwkEtN0OWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/252] KVM: SVM: Use unsigned integers when dealing with ASIDs
Date: Mon,  8 Apr 2024 14:57:35 +0200
Message-ID: <20240408125311.499365139@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 466eec4a22a76c462781bf6d45cb02cbedf21a61 ]

Convert all local ASID variables and parameters throughout the SEV code
from signed integers to unsigned integers.  As ASIDs are fundamentally
unsigned values, and the global min/max variables are appropriately
unsigned integers, too.

Functionally, this is a glorified nop as KVM guarantees min_sev_asid is
non-zero, and no CPU supports -1u as the _only_ asid, i.e. the signed vs.
unsigned goof won't cause problems in practice.

Opportunistically use sev_get_asid() in sev_flush_encrypted_page() instead
of open coding an equivalent.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240131235609.4161407-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 0aa6b90ef9d7 ("KVM: SVM: Add support for allowing zero SEV ASIDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 18 ++++++++++--------
 arch/x86/kvm/trace.h   | 10 +++++-----
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e86231c3b8a54..ea68a08cc89c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -84,9 +84,10 @@ struct enc_region {
 };
 
 /* Called with the sev_bitmap_lock held, or on shutdown  */
-static int sev_flush_asids(int min_asid, int max_asid)
+static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 {
-	int ret, asid, error = 0;
+	int ret, error = 0;
+	unsigned int asid;
 
 	/* Check if there are any ASIDs to reclaim before performing a flush */
 	asid = find_next_bit(sev_reclaim_asid_bitmap, nr_asids, min_asid);
@@ -116,7 +117,7 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
 }
 
 /* Must be called with the sev_bitmap_lock held */
-static bool __sev_recycle_asids(int min_asid, int max_asid)
+static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
 {
 	if (sev_flush_asids(min_asid, max_asid))
 		return false;
@@ -143,8 +144,9 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
-	int asid, min_asid, max_asid, ret;
+	unsigned int asid, min_asid, max_asid;
 	bool retry = true;
+	int ret;
 
 	WARN_ON(sev->misc_cg);
 	sev->misc_cg = get_current_misc_cg();
@@ -187,7 +189,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 	return ret;
 }
 
-static int sev_get_asid(struct kvm *kvm)
+static unsigned int sev_get_asid(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
@@ -284,8 +286,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
+	unsigned int asid = sev_get_asid(kvm);
 	struct sev_data_activate activate;
-	int asid = sev_get_asid(kvm);
 	int ret;
 
 	/* activate ASID on the given handle */
@@ -2314,7 +2316,7 @@ int sev_cpu_init(struct svm_cpu_data *sd)
  */
 static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 {
-	int asid = to_kvm_svm(vcpu->kvm)->sev_info.asid;
+	unsigned int asid = sev_get_asid(vcpu->kvm);
 
 	/*
 	 * Note!  The address must be a kernel address, as regular page walk
@@ -2632,7 +2634,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
-	int asid = sev_get_asid(svm->vcpu.kvm);
+	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
 
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813ee..b82e6ed4f0241 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -732,13 +732,13 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
  * Tracepoint for nested #vmexit because of interrupt pending
  */
 TRACE_EVENT(kvm_invlpga,
-	    TP_PROTO(__u64 rip, int asid, u64 address),
+	    TP_PROTO(__u64 rip, unsigned int asid, u64 address),
 	    TP_ARGS(rip, asid, address),
 
 	TP_STRUCT__entry(
-		__field(	__u64,	rip	)
-		__field(	int,	asid	)
-		__field(	__u64,	address	)
+		__field(	__u64,		rip	)
+		__field(	unsigned int,	asid	)
+		__field(	__u64,		address	)
 	),
 
 	TP_fast_assign(
@@ -747,7 +747,7 @@ TRACE_EVENT(kvm_invlpga,
 		__entry->address	=	address;
 	),
 
-	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx",
+	TP_printk("rip: 0x%016llx asid: %u address: 0x%016llx",
 		  __entry->rip, __entry->asid, __entry->address)
 );
 
-- 
2.43.0



