Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0696E28DBB;
	Fri, 24 Nov 2023 18:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="big7Zx63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42015C433B6;
	Fri, 24 Nov 2023 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851765;
	bh=OOnjR9akOPkR2kyZid6tUV7+vjDAA2IC8Zxi/1+42WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=big7Zx634af6gJ/f3URqjphPwYDPEdee+G7ZuZkJLE7CsgamxkH2yxhzBSseA303k
	 bX33va9BsvdmRMplueFr8jd8YDyUV1wk6L4F3sRyIRkyi9z/ULxIHu/eWQSrg+MoWr
	 07abOWMQaoproBB6d4YJu2UwipWNAh3VEu45d4iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Nirmoy Das <nirmoy.das@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/372] PCI: Use FIELD_GET() in Sapphire RX 5600 XT Pulse quirk
Date: Fri, 24 Nov 2023 17:47:46 +0000
Message-ID: <20231124172013.150003008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 04e82fa5951ca66495d7b05665eff673aa3852b4 ]

Use FIELD_GET() to remove dependences on the field position, i.e., the
shift value.  No functional change intended.

Separate because this isn't as trivial as the other FIELD_GET() changes.

See 907830b0fc9e ("PCI: Add a REBAR size quirk for Sapphire RX 5600 XT
Pulse")

Link: https://lore.kernel.org/r/20231010204436.1000644-3-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: Nirmoy Das <nirmoy.das@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4f37885017200..8df156c28aade 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3713,14 +3713,14 @@ u32 pci_rebar_get_possible_sizes(struct pci_dev *pdev, int bar)
 		return 0;
 
 	pci_read_config_dword(pdev, pos + PCI_REBAR_CAP, &cap);
-	cap &= PCI_REBAR_CAP_SIZES;
+	cap = FIELD_GET(PCI_REBAR_CAP_SIZES, cap);
 
 	/* Sapphire RX 5600 XT Pulse has an invalid cap dword for BAR 0 */
 	if (pdev->vendor == PCI_VENDOR_ID_ATI && pdev->device == 0x731f &&
-	    bar == 0 && cap == 0x7000)
-		cap = 0x3f000;
+	    bar == 0 && cap == 0x700)
+		return 0x3f00;
 
-	return cap >> 4;
+	return cap;
 }
 EXPORT_SYMBOL(pci_rebar_get_possible_sizes);
 
-- 
2.42.0



