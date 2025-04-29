Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60CACA5A;
	Tue, 29 Apr 2025 18:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950415; cv=none; b=Me+sfnglaeOJXORvaCevrya7ViYBhv6i83CaRIVuV0x0cYUp4xQ3DDMo+2O23XHWgP5NUbRW/uhZkpNznKzWtwzTEU6fgwL3M+X4DNWkZ7CNENcLcvNioP9Dvx88vc7smGbLk81AdUIZTx8E+ZbjvVwFIhGn9bf+4RL8ATr4Chc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950415; c=relaxed/simple;
	bh=pOihYjmsCJiuwyp1aKEIYLXxBtzOGCm8DPxLm/RAsWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBxX9EycIe9gwjER0ArnSzxibZXAGAsJZb6cqgkVojC60MBKMEsSb4gojHlXk/YYJkyDy25U1t7mJs6LwJHClykdnvH2EQgdkf00wmqpnV06yVih9vUW4bLV6oruCg2n57Mb3Ewsa2RDH8kiTU3HgEs7k0Kjco0pa3Oa1iXBA+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJFchMtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJFchMtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD33C4CEE3;
	Tue, 29 Apr 2025 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950415;
	bh=pOihYjmsCJiuwyp1aKEIYLXxBtzOGCm8DPxLm/RAsWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJFchMtDH/mqouNUGRMkEXBtFyS30RI9zLMWpThnCpHOoY3FbxSpAtwJGmMcV6mzm
	 KSiXSkt/LRejGfiXi8l6u+/yMl+eJzz0pltuuyaigF0DOJTdjn2kFdotJaXOrC5PHT
	 P+oWAJoDtNkKbQcGOe0Ow5vE8k1SGRYyiJPShOvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH 6.6 088/204] ata: libata-scsi: Fix ata_msense_control_ata_feature()
Date: Tue, 29 Apr 2025 18:42:56 +0200
Message-ID: <20250429161103.025754698@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2354,8 +2354,8 @@ static unsigned int ata_msense_control_a
 	 */
 	put_unaligned_be16(ATA_FEATURE_SUB_MPAGE_LEN - 4, &buf[2]);
 
-	if (dev->flags & ATA_DFLAG_CDL)
-		buf[4] = 0x02; /* Support T2A and T2B pages */
+	if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+		buf[4] = 0x02; /* T2A and T2B pages enabled */
 	else
 		buf[4] = 0;
 


