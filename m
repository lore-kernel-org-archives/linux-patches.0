Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A9E2DECC2;
	Tue, 15 Jul 2025 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585559; cv=none; b=r7LqZSF9Dm7zYEQ5RukcFxV9AdUsu5LtQezEVtkV2y4I6jv5BkT1CZC+Rj1OnXyg4eFvVVYV5WALzAX121ciDh81cce/S16NQHwKmaj8y8uyJH0GLASBQyeaFzvUqCCewGHr2W2PWSOMaDqo8+iMuRlMgxhs5+RgnMwWZkwxe5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585559; c=relaxed/simple;
	bh=wn/wvk7Hg8pCqxh2CwoNqUMLZKLnoI0/hWsRDMqQS14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbmazgGilq/+SKe7i5BaI7i5/4zMh9sNyg15oxm8z9Q/sy6a28xVZ4bvEf9DuNER9vmbfuQlEgLB2aGEd/K0lRY0vFho66bkOk7JqxcHvgV9MzIMHcrEIFWquXvy6eVfXn0fyKkkcfUKdbjzJdS/Gn3BEiQpeP6JDBlxxTIgd2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+drfZQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+drfZQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B8BC4CEE3;
	Tue, 15 Jul 2025 13:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585558;
	bh=wn/wvk7Hg8pCqxh2CwoNqUMLZKLnoI0/hWsRDMqQS14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+drfZQCuMeWcWn7VRckFnZuzRyUZM3wyagIJLmOs0CFOGA0ZTVrfRFQWaWhWw7/s
	 4NcWFUZLtTmgJ1JtjnvLbBTTxImfOlCgfNqzba+A3BqCQbq3PVC+pXRs0SSnIJfs5j
	 ljIeor1bNMEeK2HiJJuCRixXX6hAVNzoz6pfANwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 054/163] KVM: x86/xen: Allow out of range event channel ports in IRQ routing table.
Date: Tue, 15 Jul 2025 15:12:02 +0200
Message-ID: <20250715130810.920939878@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Woodhouse <dwmw@amazon.co.uk>

commit a7f4dff21fd744d08fa956c243d2b1795f23cbf7 upstream.

To avoid imposing an ordering constraint on userspace, allow 'invalid'
event channel targets to be configured in the IRQ routing table.

This is the same as accepting interrupts targeted at vCPUs which don't
exist yet, which is already the case for both Xen event channels *and*
for MSIs (which don't do any filtering of permitted APIC ID targets at
all).

If userspace actually *triggers* an IRQ with an invalid target, that
will fail cleanly, as kvm_xen_set_evtchn_fast() also does the same range
check.

If KVM enforced that the IRQ target must be valid at the time it is
*configured*, that would force userspace to create all vCPUs and do
various other parts of setup (in this case, setting the Xen long_mode)
before restoring the IRQ table.

Cc: stable@vger.kernel.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://lore.kernel.org/r/e489252745ac4b53f1f7f50570b03fb416aa2065.camel@infradead.org
[sean: massage comment]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1916,8 +1916,19 @@ int kvm_xen_setup_evtchn(struct kvm *kvm
 {
 	struct kvm_vcpu *vcpu;
 
-	if (ue->u.xen_evtchn.port >= max_evtchn_port(kvm))
-		return -EINVAL;
+	/*
+	 * Don't check for the port being within range of max_evtchn_port().
+	 * Userspace can configure what ever targets it likes; events just won't
+	 * be delivered if/while the target is invalid, just like userspace can
+	 * configure MSIs which target non-existent APICs.
+	 *
+	 * This allow on Live Migration and Live Update, the IRQ routing table
+	 * can be restored *independently* of other things like creating vCPUs,
+	 * without imposing an ordering dependency on userspace.  In this
+	 * particular case, the problematic ordering would be with setting the
+	 * Xen 'long mode' flag, which changes max_evtchn_port() to allow 4096
+	 * instead of 1024 event channels.
+	 */
 
 	/* We only support 2 level event channels for now */
 	if (ue->u.xen_evtchn.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)


