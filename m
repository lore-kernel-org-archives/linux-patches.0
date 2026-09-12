Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0CE3DAAC9;
	Sat, 12 Sep 2026 11:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213638; cv=none; b=qSK1BLgy/77LhW/SB40LWMqtBjLpDQzxttvfwlpp7b8eSdgvCFGse6Np9DJ1a32JSyGZw62plgdp6cTtaqGaa1XHVw1VTmt/F3QNYqQwXSlkhchKG2O0jY4FBZSOsZVvxr1pP+DyQkWdxycd3X8j2LIt+Q8si4u+HX5QGI89HTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213638; c=relaxed/simple;
	bh=DXLzqdh9/GH7F/0Cwines59TSYMs2H41jtPQXxd6Da8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co7nft71wKYE8527bRHLdsgWBGSNoMY27NrIAgeBBNWISYWb52ERjPVgjY36OOhmbnOywLYZKPlDTWc+0C/ygFlapb3HunwPKYqm5lwiX2HZa6K9Vn7FnukoXq6o7ZlnCn2hfRqrWdnRQhq76hsg9gZUf1b+qBLjHnp6WJk6B90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGsJUFCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGsJUFCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5F91F000FF;
	Sat, 12 Sep 2026 11:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213635;
	bh=b3iTrYODgyxIcKDytZaT4vhWT7zhK/6e7rClISc5z0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGsJUFCD9zk1zRXH6bNp25Mw9Mhns/epMNHGngYTOgjkZlEjwCVtWjH7VQDH+U5ab
	 cdhB35VZFxwyxcBTdg+PbaQiXS8Ha6B7BpPtFIRTpFdWjNCAQQJuvB9BEYIpdasmVQ
	 2iamOwF07ct3CVAvhFRL7H5IiTmHRkOEbRKoiPFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0162/1376] KVM: x86: Serialize writes to disabled_quirks using kvm->lock
Date: Sat, 12 Sep 2026 08:43:08 +0200
Message-ID: <20260912065611.161121052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -6552,7 +6552,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			break;
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
+		mutex_lock(&kvm->lock);
 		kvm->arch.disabled_quirks |= cap->args[0] & kvm_caps.supported_quirks;
+		mutex_unlock(&kvm->lock);
 		r = 0;
 		break;
 	case KVM_CAP_SPLIT_IRQCHIP: {


