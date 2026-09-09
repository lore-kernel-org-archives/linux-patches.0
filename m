Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8D451475A;
	Wed,  9 Sep 2026 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962574; cv=none; b=UGkVMVAKej/aOZWD03Q9adOOzk0JwirMPuL9gJHUciTYzAc1A8OP29nQl0Syyxg2PdwcYiADUcVA2m+Fzd5LFY8bIYwIk41eOohbj+NtF4Lw3DdkIFxR0FvG5YijwWcU0BktNDfe8srHeixdws7rGlVigMv1Nq40bp3VpeW6x98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962574; c=relaxed/simple;
	bh=//NW7p4WnSV0g9X456OtYfT6kFF4e505L99XkhSGi1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glrwNRYsnZA9xrHILyLs4jgtiYYy4QL4iDx7iGtAYG+vYF3isZMVhqw2AsGmG6POzeNUHoXQyLAu6Jqi9nLp2uZp4GUEq4v5QuyDSH4sYJkbSbnETxUjoGEtQnB88mqwL//5mxo6lhpgJYnOXzLQe/bqTS1qsbRptPBsGLwjPWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GI9A3GYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GI9A3GYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA681F00A3A;
	Wed,  9 Sep 2026 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962573;
	bh=lmraFP7xxQ736mYGycvXy5gVdM6DqHw5DqIaXsVAmnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GI9A3GYC2h2FapmYvUH93N+getTSQosfln1fElvhNo9TYAFBYl55s/Z9oul6sLG4k
	 j8wfoS5WEFsDYMpU3HL/ee0rVL5Q67SR9aSbLmsfz+88gugNeDF8l9l+lmV5PqnMm5
	 rb1/4/Hzb8/eJ3HBD8XsdAWM12iS7Ba2c4nE3myE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 300/556] KVM: x86: Serialize writes to disabled_quirks using kvm->lock
Date: Wed,  9 Sep 2026 15:39:40 +0200
Message-ID: <20260909134241.234921620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit ba76b23ed36ab230fc2577aba24f65851114902f upstream.

Protect writes to disabled_quirks with kvm->lock to ensure KVM doesn't
clobber state in the unlikely scenario that userspace disables disparate
quirks from multiple tasks.  More importantly, this will allow wrapping
accesses with {READ,WRITE}_ONCE without "needing" to also guard the writer
with a useless and confusing READ_ONCE (since the RMW wouldn't be atomic
anyways).

Ideally, KVM would disallow disabling quirks once quirks are "live", but
that would be a potentially breaking userspace ABI change, and while all
existing quirks are fully live only after vCPUs have been created, several
MMU-related quirks, IGNORE_GUEST_PAT and SLOT_ZAP_ALL, are partially live
at all times.  Because populating MMUs requires a vCPU, the guest-visible
behavior of IGNORE_GUEST_PAT and SLOT_ZAP_ALL requires a vCPU, but for KVM
itself, processing the quirk (or not) has functional impact, i.e. for all
intents and purposes, KVM can't prevent those quirks from being disabled
after they've been consumed.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6736,7 +6736,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			break;
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
+		mutex_lock(&kvm->lock);
 		kvm->arch.disabled_quirks |= cap->args[0] & kvm_caps.supported_quirks;
+		mutex_unlock(&kvm->lock);
 		r = 0;
 		break;
 	case KVM_CAP_SPLIT_IRQCHIP: {


