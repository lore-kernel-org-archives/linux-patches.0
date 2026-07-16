Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B184942643C;
	Thu, 16 Jul 2026 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209969; cv=none; b=YmMxKutvZhHwT8hCN4EPmj5i2/t5Gjpmhh7YPcFSaqDoJ8nwmvDyuGofBFgAbsbfzPyrPfibSxPQsbTpOrakMSNjVyApiwJnefFtQb9scYMpc5APnt+w7DY0z6dwlNEoh9ApfjvzHr+5mUkE7ylkhOwCmhRzyURMolF/LTVb9ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209969; c=relaxed/simple;
	bh=bvrizPKsoIDgi4WWB0yM4T6il3pLWk2TK/o752W3nYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQfqzx4yK62dn+njrbVifQIL1qATGUjic7IXptMOtH3+YY/pVdxiR95540HZEEJhwDfcO/x18VRE2mMV1as//ITHgnxNG1N6ccqSSmM9L8xdAOptqJ/2wek6leiKE4TP0r+ehp9xTf1c8rNnyiWVvCDX7a2aFv6HJxSVlbFy9CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bW6sLvwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bW6sLvwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0FD1F00A3D;
	Thu, 16 Jul 2026 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209959;
	bh=rWbuih1MW0q4Aaacq6KcKL59uPPa+nWN4zCaP7LvjMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bW6sLvwIlt3LZ5rHOTpbtw2FRvForCAYRmhUoJHHSm0GnOV55mLILW2FraSFDtF2X
	 DET+UjxUPm7z06J5J6uVLHGWMLO4a8XQWegTNYL+7X9PygNnOkJuBFQT2z7gvkplLN
	 A2X7+IrDON5Okmea6JyLs6v/dFGsT7PFixZ7E+NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 383/518] crypto: qat - keep VFs enabled during reset
Date: Thu, 16 Jul 2026 15:30:51 +0200
Message-ID: <20260716133056.211456116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

commit 57518500053987672050dc2f7bf8a774d5d52fd9 upstream.

When a reset is triggered via sysfs, the PCI core invokes the
reset_prepare() callback while holding pci_dev_lock(), which includes
the PCI configuration space access semaphore. If reset_prepare() calls
adf_dev_down(), the call chain adf_dev_stop() -> adf_disable_sriov()
-> pci_disable_sriov() attempts to acquire the same semaphore,
resulting in a deadlock.

Avoid this by skipping pci_disable_sriov() when ADF_STATUS_RESTARTING
is set. During reset the PCI topology is preserved, so VF devices
remain valid and enumerated across the reset. VF notification and the
quiesce handshake via adf_pf2vf_notify_restarting() are still
performed unconditionally so that VFs stop submitting work before the
PF shuts down.

Correspondingly, skip pci_enable_sriov() in adf_enable_sriov() when
VFs are already present, since their PCI devices were preserved from
before the restart.

This is in preparation for adding reset_prepare() and reset_done()
callbacks in adf_aer.c.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_sriov.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -91,6 +91,10 @@ static int adf_enable_sriov(struct adf_a
 	/* Enable VF to PF interrupts for all VFs */
 	adf_enable_all_vf2pf_interrupts(accel_dev, totalvfs);
 
+	/* Do not enable SR-IOV if already enabled */
+	if (pci_num_vf(pdev))
+		return 0;
+
 	/*
 	 * Due to the hardware design, when SR-IOV and the ring arbiter
 	 * are enabled all the VFs supported in hardware must be enabled in
@@ -260,7 +264,13 @@ void adf_disable_sriov(struct adf_accel_
 
 	adf_pf2vf_notify_restarting(accel_dev);
 	adf_pf2vf_wait_for_restarting_complete(accel_dev);
-	pci_disable_sriov(accel_to_pci_dev(accel_dev));
+	/*
+	 * When the device is restarting, preserve VF PCI devices across
+	 * the reset by skipping pci_disable_sriov(). VFs are notified to
+	 * quiesce regardless so the PF can safely shut down.
+	 */
+	if (!test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
+		pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
 	/* Block VF2PF work and disable VF to PF interrupts */
 	adf_disable_all_vf2pf_interrupts(accel_dev);


