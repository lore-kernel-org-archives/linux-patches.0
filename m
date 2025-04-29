Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09029250C02;
	Tue, 29 Apr 2025 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947837; cv=none; b=t9mTXscLbrYPEsQOi1irrbTLt6qfJazXt6FgnzYgYKWbUxa5IctYcq3yq472eqI9MIrhW9t2V7CWi8F0pBZTMvTbveTSKOOUhXNVMdOJdxa9eFYOMmREJ1M9UfZvVHkWiJhX3zgAPa1+oPuztGSNuNCWaeV0vQQvaELwrB5Aueo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947837; c=relaxed/simple;
	bh=U0TdRpUmbxeP+U5m5W3LxmATskm/GjD4ZWHt1kSz4m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXAxOS3lhbLowy9Yhtti4G9xbD9+wAI8R9nLMjHPbG6i525rUVy/7XxwVVVV8VKmqF/f7O91WskS/wbCSOrGoCRZETeitXo/jR3b+HFclmWmBDd486V8MWmTzYLMKyERcst7XO2ET1IZpu/1gzWcqGDsxHUwzkOV3T8rX5G0zjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaOfuSX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaOfuSX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236F9C4CEE9;
	Tue, 29 Apr 2025 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947836;
	bh=U0TdRpUmbxeP+U5m5W3LxmATskm/GjD4ZWHt1kSz4m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaOfuSX9kvAG7TmvWDF2p8j2sYFLMYxxwFzkhQ6gH+yW9vEkdtQ0h0n9qGPWaEZrM
	 6cWIfqZaB4jrD0IC1TSYU1yDIB4WZXwA/2sR1cPRmusQ1/NdVzUCeBBIWSS6TgBUeW
	 5mCzDtg/PtG8iByDs5Oq6whyu5+DToVDsB8hYiQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH 6.12 118/280] ata: libata-scsi: Fix ata_msense_control_ata_feature()
Date: Tue, 29 Apr 2025 18:40:59 +0200
Message-ID: <20250429161119.938304993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 88474ad734fb2000805c63e01cc53ea930adf2c7 upstream.

For the ATA features subpage of the control mode page, the T10 SAT-6
specifications state that:

For a MODE SENSE command, the SATL shall return the CDL_CTRL field value
that was last set by an application client.

However, the function ata_msense_control_ata_feature() always sets the
CDL_CTRL field to the 0x02 value to indicate support for the CDL T2A and
T2B pages. This is thus incorrect and the value 0x02 must be reported
only after the user enables the CDL feature, which is indicated with the
ATA_DFLAG_CDL_ENABLED device flag. When this flag is not set, the
CDL_CTRL field of the ATA feature subpage of the control mode page must
report a value of 0x00.

Fix ata_msense_control_ata_feature() to report the correct values for
the CDL_CTRL field, according to the enable/disable state of the device
CDL feature.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2325,8 +2325,8 @@ static unsigned int ata_msense_control_a
 	 */
 	put_unaligned_be16(ATA_FEATURE_SUB_MPAGE_LEN - 4, &buf[2]);
 
-	if (dev->flags & ATA_DFLAG_CDL)
-		buf[4] = 0x02; /* Support T2A and T2B pages */
+	if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+		buf[4] = 0x02; /* T2A and T2B pages enabled */
 	else
 		buf[4] = 0;
 


