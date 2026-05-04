Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242303DA5C7;
	Mon,  4 May 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903198; cv=none; b=aEPe2si3zR44wHYU8YeoUK8p1pUc2iUOFlYFhPkKyedCYnLDO5b9Yp+scd78zvya0bA9h/kW2o+1GoOgI2k2u4n56AHpjqR599+n9+8y0vIlRUNOra87TvkMZNsEznXcgRNajR7a6P0VJQvWq568Hkh/3Wsr7c2xLmN/miu4tKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903198; c=relaxed/simple;
	bh=GHc39W762mOS0KI+Y1vycf1CIq9odIKFod0OpK2Yyi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF4giL8+05VqS9nMbp+YhMBVRG9jA36PUzOqKPmdpJ1UgexinfgIQzmlFY+/QkV6vvw7WX7DXoGB9pOW+ReUpWHAHHE6GWfYBmesZspPo3XEM6pGmMwMklRVeUK8lDqPIS8Eucquq8fdbVsKEeTq1ePeieNaVPjfgRazBJFkeJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+Q3AbGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+Q3AbGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6B6C2BCB8;
	Mon,  4 May 2026 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903197;
	bh=GHc39W762mOS0KI+Y1vycf1CIq9odIKFod0OpK2Yyi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+Q3AbGoUahejS5dChiN0Mgkc1sZjBNvb2o7qmRqXwHoes0oGq9ACUipl3x8GhKaL
	 pWOa5vtrlJ6ZAXvIOHIcLPDZx+Vy8PCHo2HQ9umbEJ5TtzABRhGwdSDD4rmogZy3bB
	 1+dbIY53ccDN7IBLwcPnTvSMuEpVflIs7uAsAM8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 142/307] net: txgbe: fix firmware version check
Date: Mon,  4 May 2026 15:50:27 +0200
Message-ID: <20260504135148.123034145@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit c263f644add3d6ad81f9d62a99284fde408f0caa upstream.

For the device SP, the firmware version is a 32-bit value where the
lower 20 bits represent the base version number. And the customized
firmware version populates the upper 12 bits with a specific
identification number.

For other devices AML 25G and 40G, the upper 12 bits of the firmware
version is always non-zero, and they have other naming conventions.

Only SP devices need to check this to tell if XPCS will work properly.
So the judgement of MAC type is added here.

And the original logic compared the entire 32-bit value against 0x20010,
which caused the outdated base firmwares bypass the version check
without a warning. Apply a mask 0xfffff to isolate the lower 20 bits for
an accurate base version comparison.

Fixes: ab928c24e6cd ("net: txgbe: add FW version warning")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/C787AA5C07598B13+20260422071837.372731-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -867,7 +867,8 @@ static int txgbe_probe(struct pci_dev *p
 			 "0x%08x", etrack_id);
 	}
 
-	if (etrack_id < 0x20010)
+	if (wx->mac.type == wx_mac_sp &&
+	    ((etrack_id & 0xfffff) < 0x20010))
 		dev_warn(&pdev->dev, "Please upgrade the firmware to 0x20010 or above.\n");
 
 	err = txgbe_test_hostif(wx);


