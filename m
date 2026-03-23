Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE94F3ACA68;
	Mon, 23 Mar 2026 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273887; cv=none; b=AieTne1rPJ6le1lp6Ln5I1UoOfJDq3+n2wzE6pdtbspp8WyrBObYtdqy/TyhrOlX6xGjIjU4Wz172BYHoTNd615vQzNABTv+Hn7N7uLaH8+O+3wuhM/9/y+XrZNOQbdsQ7kVoQSonSvS6zsmhc8bzCe0+naiU2x5+G5oRqMWUF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273887; c=relaxed/simple;
	bh=obVCHDciLX8h4BCJdGIKHavTc46ZkXN55WZtI2q3yPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFGrIm/mQYRGTDBUU9r1wZ0NPzTrDxKTj9IbOBd0YF0jndcHCCNrRaOiZyYws7/ZXpv9jyiBFY5oXkXGBNb1TDymjcLImxW6Bt6gXtZClORoXxATwv/inCaD3MrkW+YcanqiwSpMzH254eN8RJ/tyky8wVqTksHrrE8pVLVXMHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxJ6CSBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxJ6CSBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F6EC2BC9E;
	Mon, 23 Mar 2026 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273886;
	bh=obVCHDciLX8h4BCJdGIKHavTc46ZkXN55WZtI2q3yPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxJ6CSBuByRcURmXiaNAoQGJk529G3NhMWJlqnTc/84UTjg8FLVOVM6LyYRRuy8D6
	 mTlDowpra38awaA2KOCdEUrCHixXq0CetKbxrSPyQeXr8HDzDB5mAaryVCjpgqGj8R
	 Ffm4r/iUkPIKJB/A2RzfkzT/9HU4leTQxgjmbInU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Khaled Bayan <mhd.khaled.bayan@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.19 041/220] ata: libata-core: disable LPM on ADATA SU680 SSD
Date: Mon, 23 Mar 2026 14:43:38 +0100
Message-ID: <20260323134505.891469990@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit ce5ae93d1a216680460040c7c0465a6e3b629dec upstream.

ADATA SU680 SSDs suffer from NCQ read and write commands timeouts or bus
errors when link power management (LPM) is enabled. Flag these devices
with the ATA_QUIRK_NOLPM quirk to prevent the use of LPM and avoid these
command failures.

Reported-by: Mohammad Khaled Bayan <mhd.khaled.bayan@gmail.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux-hwe-6.17/+bug/2144060
Cc: stable@vger.kernel.org
Tested-by: Mohammad-Khaled Bayan <mhd.khaled.bayan@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4185,6 +4185,9 @@ static const struct ata_dev_quirks_entry
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_QUIRK_NONCQ |
 						ATA_QUIRK_FIRMWARE_WARN },
 
+	/* ADATA devices with LPM issues. */
+	{ "ADATA SU680",	NULL,		ATA_QUIRK_NOLPM },
+
 	/* Seagate disks with LPM issues */
 	{ "ST1000DM010-2EP102",	NULL,		ATA_QUIRK_NOLPM },
 	{ "ST2000DM008-2FR102",	NULL,		ATA_QUIRK_NOLPM },


