Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F362C1595;
	Sun,  7 Jun 2026 10:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828242; cv=none; b=M1qDcqfdFa+e+grkuTCqzMukIHZZ8HH7licKhK8dmvYp3f3IUc7YR8Zt8PBfWcrnI0R9umNGju9AbiSY8mAgD4yHYJgA4nYfQBiDv9jAV9297/nK/OgTv/3ECP9cMrNvvF/5Kf9K3kVz4b0kEw9hZy/HSqnr0zNSmZo0oUz0KJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828242; c=relaxed/simple;
	bh=WZHbzYDbEzJqbklql1/fT3BW1MC0EsIIiXK4T7x6dZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de1Xdiz8Rn9q8eB3v/2TG1N7Xwyx6j6CQw5bm9R1M8z2tASKU86XhvkIfG6BtCpIccerICRDrEsADdkV03+VZj+7PGbw3tjdbbTfL9rWRIXyXJVojQYAPnKTxXnUq0QGa8PVvNvNz4CSfDcOOQj/RS2o8Kgih4/yPyOvhF+SuG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k03/Vmof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k03/Vmof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC3D1F00893;
	Sun,  7 Jun 2026 10:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828240;
	bh=2HH33MTybkPLSWucpxEbBqANiLEQbEXA5ZQ167ZS8dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k03/VmofwJcX+YqIy1LXlTtjEc1Z4G7sWRv5mCarYxJohofT8TVYH6VVujpMOTu4K
	 4OvUXkIUZ4CMhDlY/3gI3ZaOkAxgZb/7jTA0q2CeQNdx1qwDZrlEM9jHdrztEyU0Aj
	 ZxiFEKunGzk9dY+960IQooV5oKvxZ442ge1uJoSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.0 166/332] KVM: SEV: Compute the correct max length of the in-GHCB scratch area
Date: Sun,  7 Jun 2026 11:58:55 +0200
Message-ID: <20260607095734.168127622@linuxfoundation.org>
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

commit 5867d7e202e09f037cefe77f7af4413c7c0fa088 upstream.

When setting the length of the GHCB scratch area, and the area is in the
GHCB shared buffer, set the effective length of the scratch area to the max
possible size given the start of the guest-provided pointer, and the end of
the shared buffer.

The code was "fine" when first introduced, as KVM doesn't consult the
length of the buffer when emulating MMIO, because the passed in @len always
specifies the *max* size required.  But for PSC requests, the incoming @len
is just the minimum length (to process the header), and KVM needs to know
the full size of the scratch area to avoid buffer overflows (spoiler alert).

Opportunistically rename @len => @min_len to better reflect its role.

Fixes: 9b54e248d264 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3617,7 +3617,7 @@ int pre_sev_run(struct vcpu_svm *svm, in
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
-static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 min_len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
@@ -3633,10 +3633,10 @@ static int setup_vmgexit_scratch(struct
 		goto e_scratch;
 	}
 
-	scratch_gpa_end = scratch_gpa_beg + len;
+	scratch_gpa_end = scratch_gpa_beg + min_len;
 	if (scratch_gpa_end < scratch_gpa_beg) {
 		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
-		       len, scratch_gpa_beg);
+		       min_len, scratch_gpa_beg);
 		goto e_scratch;
 	}
 
@@ -3660,6 +3660,8 @@ static int setup_vmgexit_scratch(struct
 
 		scratch_va = (void *)svm->sev_es.ghcb;
 		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
+
+		svm->sev_es.ghcb_sa_len = ghcb_scratch_end - scratch_gpa_beg;
 	} else {
 		/* GHCB v2 requires the scratch area to be within the GHCB. */
 		if (to_kvm_sev_info(svm->vcpu.kvm)->ghcb_version >= 2)
@@ -3669,16 +3671,16 @@ static int setup_vmgexit_scratch(struct
 		 * The guest memory must be read into a kernel buffer, so
 		 * limit the size
 		 */
-		if (len > GHCB_SCRATCH_AREA_LIMIT) {
+		if (min_len > GHCB_SCRATCH_AREA_LIMIT) {
 			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
-			       len, GHCB_SCRATCH_AREA_LIMIT);
+			       min_len, GHCB_SCRATCH_AREA_LIMIT);
 			goto e_scratch;
 		}
-		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
+		scratch_va = kvzalloc(min_len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
 			return -ENOMEM;
 
-		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
+		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, min_len)) {
 			/* Unable to copy scratch area from guest */
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
@@ -3694,11 +3696,10 @@ static int setup_vmgexit_scratch(struct
 		 */
 		svm->sev_es.ghcb_sa_sync = sync;
 		svm->sev_es.ghcb_sa_free = true;
+		svm->sev_es.ghcb_sa_len = min_len;
 	}
 
 	svm->sev_es.ghcb_sa = scratch_va;
-	svm->sev_es.ghcb_sa_len = len;
-
 	return 0;
 
 e_scratch:


