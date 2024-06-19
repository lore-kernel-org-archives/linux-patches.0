Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5207146D49;
	Wed, 19 Jun 2024 13:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803320; cv=none; b=tR5fPjd6n8OAY9MnBUbygKnBCVL2vf4PT773tpnW+F5fruQNvLSgTAQSviQTV/neAalWZfvWiKKLVBkBOm+K5KPttAT2ye2MA5cLlDv9KxNFX7NGJhKEP7vD3gukfbo7S5ZPzxEUQFrXtMOew/sc9/VYmxoemleQJYw1oIcEFpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803320; c=relaxed/simple;
	bh=cosMgF4WAWMiAZAQMUdcEZOyUgPKPIwQYKbDiRkWvp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ5mzEOlKRsxUqAS3XBCMFGxGjkmaPBOkvOy4dBqXFmJAVkGzUraASFtXx/vInDvnSqf6Ifow8DfK9NtVrrS5xn8ryN0zqlt8PmSucj/Ypa4MRaB/1ZYt1nzNnlqnpOi+ngTwUr/f1+gqWSAen3JatZxIpS+Fc325DBMXxrrc1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCy7FTOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCy7FTOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5846FC2BBFC;
	Wed, 19 Jun 2024 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803320;
	bh=cosMgF4WAWMiAZAQMUdcEZOyUgPKPIwQYKbDiRkWvp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCy7FTOqWrszRF1NFYpRt1EMYUy6vj4XM/igL8zostjvNag9WECflX+3+9gv/2LO0
	 sq51wGqA5ipDNmi7JnY7KRxPvdOVyrBkO0Vrx15hQrcsHHFmOvYJ+9qlDUwO/spZsC
	 DPRprydvwTOkFLw3Eq+TIJr5NiAASm2H7+VIwVgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Nader <dev@kayoway.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.9 228/281] ata: ahci: Do not apply Intel PCS quirk on Intel Alder Lake
Date: Wed, 19 Jun 2024 14:56:27 +0200
Message-ID: <20240619125618.731990091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Nader <dev@kayoway.com>

commit 9e2f46cd87473c70d01fcaf8a559809e6d18dd50 upstream.

Commit b8b8b4e0c052 ("ata: ahci: Add Intel Alder Lake-P AHCI controller
to low power chipsets list") added Intel Alder Lake to the ahci_pci_tbl.

Because of the way that the Intel PCS quirk was implemented, having
an explicit entry in the ahci_pci_tbl caused the Intel PCS quirk to
be applied. (The quirk was not being applied if there was no explict
entry.)

Thus, entries that were added to the ahci_pci_tbl also got the Intel
PCS quirk applied.

The quirk was cleaned up in commit 7edbb6059274 ("ahci: clean up
intel_pcs_quirk"), such that it is clear which entries that actually
applies the Intel PCS quirk.

Newer Intel AHCI controllers do not need the Intel PCS quirk,
and applying it when not needed actually breaks some platforms.

Do not apply the Intel PCS quirk for Intel Alder Lake.
This is in line with how things worked before commit b8b8b4e0c052 ("ata:
ahci: Add Intel Alder Lake-P AHCI controller to low power chipsets list"),
such that certain platforms using Intel Alder Lake will work once again.

Cc: stable@vger.kernel.org # 6.7
Fixes: b8b8b4e0c052 ("ata: ahci: Add Intel Alder Lake-P AHCI controller to low power chipsets list")
Signed-off-by: Jason Nader <dev@kayoway.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6548f10e61d9..07d66d2c5f0d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -429,7 +429,6 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x02d7), board_ahci_pcs_quirk }, /* Comet Lake PCH RAID */
 	/* Elkhart Lake IDs 0x4b60 & 0x4b62 https://sata-io.org/product/8803 not tested yet */
 	{ PCI_VDEVICE(INTEL, 0x4b63), board_ahci_pcs_quirk }, /* Elkhart Lake AHCI */
-	{ PCI_VDEVICE(INTEL, 0x7ae2), board_ahci_pcs_quirk }, /* Alder Lake-P AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-- 
2.45.2



