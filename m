Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A862FDC53;
	Thu, 16 Jul 2026 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211279; cv=none; b=PYs0MhJgOgJhKk+MZc1diRjHvTrSQ/i7pLEiYwyB22L449/m20XyOcd3qr9vWuN2+tla90rdxVDibklicliHmuz40OZBNT4RFBfKQQ/IcS2v18J0b+PEBJbXATW1PM4PK5/i6znO6fNCXwU23ayTjQqyKdjwS7reqCjZTvhK214=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211279; c=relaxed/simple;
	bh=AT7GJRmedARs7bx8jMA7EuEYpek6gg7scov+4ZagERo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MILPdbWrECicRp9qRvbEQk+0XZmhz/awBv/++51aI6EX8rQ7Xx3YilLtZt5MW75R94L2se72xQiVr0na48gE+2JxITkRQq0XumSISlPisK+Pfn+9vRCSqPRNa9sG8e3BWvamkrn6j2gzPtYh5ptzisNMcrPSd2eOswvxXFFh+T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoDn2nQv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoDn2nQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4E31F000E9;
	Thu, 16 Jul 2026 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211277;
	bh=BrrYMVC7gjhojONF6D6ZGHHN05U8MZrvoTg0QQM3zLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoDn2nQvhjT422U+Ne7UEyv08OIUs4mKzZHSlnEDHgatdV/vG4ffuazGH9b2WNvMM
	 oYjmj1WyTdYlWzbJw4hqg4h9gqvIx7lJ1tZUdehF8FsRGlKT+or9jLaS422zn4GGrS
	 eqhMtHXy45c92sg9mSt2isuQC8sKwnZv4tXDo7WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 365/480] crypto: qat - keep VFs enabled during reset
Date: Thu, 16 Jul 2026 15:31:52 +0200
Message-ID: <20260716133052.698120913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -77,6 +77,10 @@ static int adf_enable_sriov(struct adf_a
 	/* Enable VF to PF interrupts for all VFs */
 	adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
 
+	/* Do not enable SR-IOV if already enabled */
+	if (pci_num_vf(pdev))
+		return 0;
+
 	/*
 	 * Due to the hardware design, when SR-IOV and the ring arbiter
 	 * are enabled all the VFs supported in hardware must be enabled in
@@ -247,7 +251,13 @@ void adf_disable_sriov(struct adf_accel_
 
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
 
 	/* Disable VF to PF interrupts */
 	adf_disable_all_vf2pf_interrupts(accel_dev);


