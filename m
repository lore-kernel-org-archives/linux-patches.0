Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBF61E98E7;
	Wed, 15 Jan 2025 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938066; cv=none; b=JEZxtYgJBYBDz3CbiEcaLgjyJOHA0PaozVR41DGtIkX0tz45cJIvqasJxp+F5ayZBfCrDvrfstONx128bVLgPn9mcVtzo8CmgyFEgko3uASHQaikrL2fiGi1khmTlSav905QYeMK98M3ZgW9kkDoM+rMFe/9m9z/M1My6fT6Vx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938066; c=relaxed/simple;
	bh=fFhh5Y29zhgx/9LTQW1XVelnjaafTxC8uLUn+U7e8LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JD+ItgGa7WcHXK2O/piFd6B55youeREBFZuM1PcGBXHWdcBdzW7dH9SR7cCR0WJNvF/nK1T9gx4WnZXJjbbR5VuOl9KALMkBCyV2TFSN2/DqAH0Z6+fQr9h+8auqslLIDBBVdSRw+RpqHs711AvdXaox9ipMny2UXzhI0MbaigQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRsvG+TV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRsvG+TV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411A9C4CEDF;
	Wed, 15 Jan 2025 10:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938065;
	bh=fFhh5Y29zhgx/9LTQW1XVelnjaafTxC8uLUn+U7e8LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRsvG+TVuqsOOjN/lXsaa63DlmVHi+aY1AJRFZMiWXcOyGg2wIMpxJTH+p5vwGYQk
	 wk4ZcU3JGKEsAMMZk8aqz5Oq2S9HKhgiHD46DJiW6aW9UjZMlwyP7KGuVZHmbkDVcF
	 9PfOs+56dtVR2Kg6acnfIGKK0r5vC8eF8uG2qTq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/189] platform/x86: intel/pmc: Fix ioremap() of bad address
Date: Wed, 15 Jan 2025 11:36:09 +0100
Message-ID: <20250115103609.269356528@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 1d7461d0c8330689117286169106af6531a747ed ]

In pmc_core_ssram_get_pmc(), the physical addresses for hidden SSRAM
devices are retrieved from the MMIO region of the primary SSRAM device.
If additional devices are not present, the address returned is zero.
Currently, the code does not check for this condition, resulting in
ioremap() incorrectly attempting to map address 0.

Add a check for a zero address and return 0 if no additional devices
are found, as it is not an error for the device to be absent.

Fixes: a01486dc4bb1 ("platform/x86/intel/pmc: Cleanup SSRAM discovery")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20250106174653.1497128-1-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core_ssram.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/intel/pmc/core_ssram.c b/drivers/platform/x86/intel/pmc/core_ssram.c
index 8504154b649f..927f58dc73e3 100644
--- a/drivers/platform/x86/intel/pmc/core_ssram.c
+++ b/drivers/platform/x86/intel/pmc/core_ssram.c
@@ -269,8 +269,12 @@ pmc_core_ssram_get_pmc(struct pmc_dev *pmcdev, int pmc_idx, u32 offset)
 		/*
 		 * The secondary PMC BARS (which are behind hidden PCI devices)
 		 * are read from fixed offsets in MMIO of the primary PMC BAR.
+		 * If a device is not present, the value will be 0.
 		 */
 		ssram_base = get_base(tmp_ssram, offset);
+		if (!ssram_base)
+			return 0;
+
 		ssram = ioremap(ssram_base, SSRAM_HDR_SIZE);
 		if (!ssram)
 			return -ENOMEM;
-- 
2.39.5



