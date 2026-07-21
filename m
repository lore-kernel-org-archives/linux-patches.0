Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8415247012F;
	Tue, 21 Jul 2026 19:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663582; cv=none; b=eXwYM1/Mn/TTCtm2x8ETQ2GJISS/EVNGkmATP6T7ngFIB6Ye67EjCeZwj/8d1xdsHfR91wfzmXDb0HgyZ5cydlxwg+zPgbN1DoOEeLpZX1bgyLSCkbaTwO4wUUOItGUKOyJF9gumK0ff1yIyQ45ioZ5bluVb7KbNMdV0GiWEkzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663582; c=relaxed/simple;
	bh=9vjgYagcnjZK2EzukXbb7/a6qE2HEHVmbvROhiXzCYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=or8FsfhvuNC34ZISSkBMo0B5hNm7yhK3avSqYoUaumM8gwa75nI5vh+SMhYxFqlfh2MJo9zD/r08vtDi3cyq7ugAST2tPs1oUWC5YLLS2C95Zrc35qIXPIlGQ+EJVb3zEIdyUp0LUcr9s0KRg0oICiyCWZzl9rhJ3BqIJ+v9Niw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyJlBcBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyJlBcBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BC21F00A3D;
	Tue, 21 Jul 2026 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663581;
	bh=luFoHjQKAmPzZ48edpO2kOvTM4cdH8jDS4NDBiJ/A8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyJlBcByakrAarDjhNEVHU6JVm6zGGNgOKues3lZ8hP5ESO0eljB+UN/5oAycs6ep
	 jYIWK7bAk9Bgd3CPlIJ0iQZZ7+ygSLuTOKpa8yF1XllDgS7xlrCE+vu7pvhhFBK01A
	 Ut6xrs4Hmia30eHIOv8mi6U25eb/Lww7KqryAI2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Atish Patra <atishp@meta.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0834/1276] KVM: SEV: Do not allow intra-host migration/mirroring of SNP VMs
Date: Tue, 21 Jul 2026 17:21:17 +0200
Message-ID: <20260721152504.722604436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@meta.com>

commit 6ee4140788234a6fabf59e6a50e38cdb936008cd upstream.

The intra-host migration/mirroring feature is not fully implemented for
SEV-SNP VMs. The proper migration requires additional SNP-specific
state such as guest_req_mutex, guest_req_buf, and guest_resp_buf to be
transferred or initialized on the destination.

The SNP VM mirroring requires vmsa features to be copied as well otherwise
ASID would be bound to SNP range while VM is detected as a SEV VM.

Reject SNP source VMs in migration/mirroring until proper SNP state
transfer is implemented.

Fixes: 1dfe571c12cf ("KVM: SEV: Add initial SEV-SNP support")

Reported-by: Chris Mason <clm@meta.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Atish Patra <atishp@meta.com>
Link: https://patch.msgid.link/20260602-sev_snp_fixes-v3-1-24bfd3ae047c@meta.com
Cc: stable@vger.kernel.org
[sean: let lines poke past 80 chars, tag for stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2101,8 +2101,9 @@ int sev_vm_move_enc_context_from(struct
 	if (ret)
 		return ret;
 
+	/* Do not allow SNP VM migration until additional state transfer is implemented  */
 	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
-	    sev_guest(kvm) || !sev_guest(source_kvm)) {
+	    sev_guest(kvm) || !sev_guest(source_kvm) || sev_snp_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -2830,8 +2831,9 @@ int sev_vm_copy_enc_context_from(struct
 	 * disallow out-of-band SEV/SEV-ES init if the target is already an
 	 * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
 	 * created after SEV/SEV-ES initialization, e.g. to init intercepts.
+	 * Also do not allow SNP VM mirroring until additional state transfer is implemented.
 	 */
-	if (sev_guest(kvm) || !sev_guest(source_kvm) ||
+	if (sev_guest(kvm) || !sev_guest(source_kvm) || sev_snp_guest(source_kvm) ||
 	    is_mirroring_enc_context(source_kvm) || kvm->created_vcpus) {
 		ret = -EINVAL;
 		goto e_unlock;


