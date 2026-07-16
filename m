Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77A230AD05;
	Thu, 16 Jul 2026 14:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211281; cv=none; b=SCexfTxkxjoomUsC0shQIsvT05h85vvFckCKYQFOd5Y5O7AUSUhrBq6mOzaKMzCaxfwCXsQgw/bfqG/i3w5BQSO6jbbCR9tsxPa9xMsmLHAsRknutng5iz8NCo7DAI+Wa2N9Sjbq3cLsbK3w5E4i8bhx3ICxYGd0hMA+A1T5uho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211281; c=relaxed/simple;
	bh=9PKIltJC6tm/IttaQ6+UzW0R3gW/0p22tFG9Gx2wqe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7D+ynYzDBCLRhLl8D8KV7VBlTkc8D5H7QeH+KWUtpGve88BSejOncOaNx7yiSzi+u33hsc/b06larpwK6wI3huP4WNPLTkbTPFe2Aoq91Chk1FdF2HnBvcBaQYb3a/HanQem3U/1DSdtf+TRFrfOCbxPS50Jox0axIdBDK23og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBs9iT0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBs9iT0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110F81F000E9;
	Thu, 16 Jul 2026 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211280;
	bh=IRQIQ2/j05RO3lY1RT/QFj9kJGnS2rSZYNktLr82dDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBs9iT0PuEaVuD2JZdIHxGWNGwYI71JnxsrXPBijbGu/2J+RVdHhPQtN9azcZZcyL
	 Qh1SJbxUhY3Ip8CLr8wzl36IQQHGb+VDfj4lssNRuo9ph4VqeERTu5Yczh/nG2sqUU
	 0HdTlOliolyDEDrH3QvEIx8LxKdx99kHoDj3UsSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 366/480] crypto: qat - notify fatal error before AER reset preparation
Date: Thu, 16 Jul 2026 15:31:53 +0200
Message-ID: <20260716133052.720825850@linuxfoundation.org>
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
 


