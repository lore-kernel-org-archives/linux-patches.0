Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7683FBEBC;
	Thu, 16 Jul 2026 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209971; cv=none; b=oEreGUd3bCeW+VCJ5E5cXoKw7kulnZyGQM8XJAPUz8jaP6zaNcqCsd34oeL2KqkNO4Kye9wGmviXS2vS0nOSpiQHFHLUr/yHFeGvoLFAT3wLAzatlZ5GhV8Vy+tO1Ka415ghclyP9eIciMcbt9HdvY3/cgqiog/HB7c47UZU1TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209971; c=relaxed/simple;
	bh=qzy57FxuB90S1PqmAHIon8bDGI8ac/xH8HrhjIjxMbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAuys/s1ynVT7w88pAyQ+W0ewxzl4K8lwOXutrt0WVyf2WA+ndv/x+iAcBhKnR63kufmUgnU8Bdbm7RtuKuqdLHlk7QVF9thy1dkysNUp3U7bfI7HtuayXA9VM60ecTIjOBbAzy/stszgn1R49fgNnAE5hcqAoPvCLa0eKQ8W2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AohsIEVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AohsIEVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E681F00A3E;
	Thu, 16 Jul 2026 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209962;
	bh=M+AO+liakjM1b8byG/XnhxFN49E2Z/3Gky0079XWbS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AohsIEVbSik70iA8EJPve2BIBgUly09fhJ8EiHHVn5HFLgq1xCss3cW2L24htbKO0
	 K/r/6FllEKCavjBOXgHVn0JwMspTd0myvvj+XvpyhcwxYdeq1Byn73Ftl0PKRBdlei
	 64eNy3JP8v4wExrX/3XS0nqUHdItevERA1uQvk9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 384/518] crypto: qat - notify fatal error before AER reset preparation
Date: Thu, 16 Jul 2026 15:30:52 +0200
Message-ID: <20260716133056.233363056@linuxfoundation.org>
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

commit 6931835f2fdd0cb9b1c7791748d7e67d0749056a upstream.

Send fatal error notifications to subsystems and VFs as soon as
AER error detection starts, before entering the reset preparation
shutdown sequence.

This reduces notification latency and ensures peers are informed
immediately on fatal detection, rather than after restart-state setup
and arbitration teardown.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -33,13 +33,13 @@ static pci_ers_result_t adf_error_detect
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	adf_error_notifier(accel_dev);
+	adf_pf2vf_notify_fatal_error(accel_dev);
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	if (accel_dev->hw_device->exit_arb) {
 		dev_dbg(&pdev->dev, "Disabling arbitration\n");
 		accel_dev->hw_device->exit_arb(accel_dev);
 	}
-	adf_error_notifier(accel_dev);
-	adf_pf2vf_notify_fatal_error(accel_dev);
 	adf_dev_restarting_notify(accel_dev);
 	adf_dev_down(accel_dev);
 


