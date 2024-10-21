Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587DC1F4710;
	Mon, 21 Oct 2024 10:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507870; cv=none; b=U6UNa5TdjyldTWQHEQhBr1yvQASn+RVHCkRlJ+Vaso2aIdTx9FuN35S5d3Fys3jEHekTs+MSdYbLykWSHNjXSBn9qJs899WF+kBpThgs8Rj7RcL4wsclQqA7fRXj3GKjFYNArZUMf4FuqxDU0FX0SXoZbtmPSyhUCSjpSt5QxNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507870; c=relaxed/simple;
	bh=H/Fjx4cboTkM80k2KvLenuZReGdEHDSRvHj1HootnT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZHSG9xz4pFYLflKtmiPdc0IDRtB3YV1uaJaB5pJz33sgymqHawRx3olzj1DtvWzbkA1/A+JNyNjVk6ogJEX0+Y8PEV6R8Yl0xBYb4VMsbJIK7C6N/qmM7U2JeE4tg/6Ppz7CLcQWaKcLNMGVsH13pvPoV7+cbfiH3Aue5kNYJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6SOOxr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6SOOxr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D3EC4CEE6;
	Mon, 21 Oct 2024 10:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507870;
	bh=H/Fjx4cboTkM80k2KvLenuZReGdEHDSRvHj1HootnT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6SOOxr4/6hMMPLBodQ/uYn8MgLFPWfydv6d3kGWXbdlTUOxZ4dxsPLGn7oIL4Tnf
	 ir6H8RXLoRP/5jM8idZ3R5wmDhzQHm8CtoyvN4OSnSwtYIi/5qW+utc7HOEpE//63H
	 X6Tpmmn7GZPSfU+0/IxQVDZaozBSmpGiHlRk1EYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 46/52] irqchip/gic-v4: Dont allow a VMOVP on a dying VPE
Date: Mon, 21 Oct 2024 12:26:07 +0200
Message-ID: <20241021102243.429687871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 1442ee0011983f0c5c4b92380e6853afb513841a upstream.

Kunkun Jiang reported that there is a small window of opportunity for
userspace to force a change of affinity for a VPE while the VPE has already
been unmapped, but the corresponding doorbell interrupt still visible in
/proc/irq/.

Plug the race by checking the value of vmapp_count, which tracks whether
the VPE is mapped ot not, and returning an error in this case.

This involves making vmapp_count common to both GICv4.1 and its v4.0
ancestor.

Fixes: 64edfaa9a234 ("irqchip/gic-v4.1: Implement the v4.1 flavour of VMAPP")
Reported-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/c182ece6-2ba0-ce4f-3404-dba7a3ab6c52@huawei.com
Link: https://lore.kernel.org/all/20241002204959.2051709-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c   |   18 ++++++++++++------
 include/linux/irqchip/arm-gic-v4.h |    4 +++-
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -789,8 +789,8 @@ static struct its_vpe *its_build_vmapp_c
 	its_encode_valid(cmd, desc->its_vmapp_cmd.valid);
 
 	if (!desc->its_vmapp_cmd.valid) {
+		alloc = !atomic_dec_return(&desc->its_vmapp_cmd.vpe->vmapp_count);
 		if (is_v4_1(its)) {
-			alloc = !atomic_dec_return(&desc->its_vmapp_cmd.vpe->vmapp_count);
 			its_encode_alloc(cmd, alloc);
 			/*
 			 * Unmapping a VPE is self-synchronizing on GICv4.1,
@@ -809,13 +809,13 @@ static struct its_vpe *its_build_vmapp_c
 	its_encode_vpt_addr(cmd, vpt_addr);
 	its_encode_vpt_size(cmd, LPI_NRBITS - 1);
 
+	alloc = !atomic_fetch_inc(&desc->its_vmapp_cmd.vpe->vmapp_count);
+
 	if (!is_v4_1(its))
 		goto out;
 
 	vconf_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->its_vm->vprop_page));
 
-	alloc = !atomic_fetch_inc(&desc->its_vmapp_cmd.vpe->vmapp_count);
-
 	its_encode_alloc(cmd, alloc);
 
 	/* We can only signal PTZ when alloc==1. Why do we have two bits? */
@@ -3793,6 +3793,13 @@ static int its_vpe_set_affinity(struct i
 	int from, cpu;
 
 	/*
+	 * Check if we're racing against a VPE being destroyed, for
+	 * which we don't want to allow a VMOVP.
+	 */
+	if (!atomic_read(&vpe->vmapp_count))
+		return -EINVAL;
+
+	/*
 	 * Changing affinity is mega expensive, so let's be as lazy as
 	 * we can and only do it if we really have to. Also, if mapped
 	 * into the proxy device, we need to move the doorbell
@@ -4424,9 +4431,8 @@ static int its_vpe_init(struct its_vpe *
 	raw_spin_lock_init(&vpe->vpe_lock);
 	vpe->vpe_id = vpe_id;
 	vpe->vpt_page = vpt_page;
-	if (gic_rdists->has_rvpeid)
-		atomic_set(&vpe->vmapp_count, 0);
-	else
+	atomic_set(&vpe->vmapp_count, 0);
+	if (!gic_rdists->has_rvpeid)
 		vpe->vpe_proxy_event = -1;
 
 	return 0;
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -56,10 +56,12 @@ struct its_vpe {
 				bool	enabled;
 				bool	group;
 			}			sgi_config[16];
-			atomic_t vmapp_count;
 		};
 	};
 
+	/* Track the VPE being mapped */
+	atomic_t vmapp_count;
+
 	/*
 	 * Ensures mutual exclusion between affinity setting of the
 	 * vPE and vLPI operations using vpe->col_idx.


