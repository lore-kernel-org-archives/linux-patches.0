Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21592E3391;
	Tue, 15 Jul 2025 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586854; cv=none; b=dKytztHUix1JxqAmWEIWO4iSVWMjPTScYEq829tnYwgcK8lP7DGUALtUaW94fan6aAUdKyb6hK8kngV2fxyyrT33r/FOEYzB6TGW7Ri5IXuL+4VIL5MYgZ0gkgGjXDdIySIMpXeHhAkAmUo9MeRJQm89A0GMfJNWNYEI2LAGUBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586854; c=relaxed/simple;
	bh=rVUvktp3l/txSVD5oy5vh0Qa1znWvKZXYWLD6zcr9ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvO+FJ6LRkggZ8VZwfM8C/dhHDm3Yv63hizUkyCrUdFM/TR+0v6oyMwvNew84uP8MV0vxFQs08BvXP9iAarnCmCfmgEYRYf8qYlw9/Qd5k1lUwN6hNPJQpZWnJrKpt5RXpKGg0AzjENH3oPcr6QNu+Mxgn7bD97G/kWie+fW5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x52fa2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x52fa2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2FEC4CEF1;
	Tue, 15 Jul 2025 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586854;
	bh=rVUvktp3l/txSVD5oy5vh0Qa1znWvKZXYWLD6zcr9ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1x52fa2k8DuUsARY9T9Q3ur9Tp6HGkCydSS9HtdDuHGSNdnvWAqEmuiwxBIH2ekNt
	 qZ7V4wEBhDfMM0FB8oe/0Y+DmCR6aYkcAZ5PgGpeq6fSBchPqMHSKMUmaleVwU5S3+
	 fm/x2YxaeBP5hLYrUGo+Wvd0TGINvTnxNR5uB+6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.15 056/192] KVM: x86/xen: Allow out of range event channel ports in IRQ routing table.
Date: Tue, 15 Jul 2025 15:12:31 +0200
Message-ID: <20250715130817.088416139@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1970,8 +1970,19 @@ int kvm_xen_setup_evtchn(struct kvm *kvm
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


