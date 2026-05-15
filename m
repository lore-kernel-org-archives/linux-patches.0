Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C21C3A961B;
	Fri, 15 May 2026 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860877; cv=none; b=K2cc2j4T4IMkD7Z8KRPm9P4Yz9VYK3FilvCkxb8wEysr+CoYVA7PZzOqdhwRwc64FJYKkNt8BEIPwhSs1x4/bNjJIQEv1CGyy8mUTPAuP135hpqiffRd6BWHdiMLOHQWIhEhaJWuQ50Js/8lMzYTzVtv5ggMiUnlm3KNT+gpcoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860877; c=relaxed/simple;
	bh=2GcgEyWpPEr5G5aVTTBB8dO4xOOcuTGErSMWNEFUg6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzPL2FwLohqu+lBBfVUiWWIo/duoX0CG3MVERs5AKhwvsTdd1hfTF4k72q0pCm7mX0KjntYyh4Wnif4sXtqG5k/FBekPVfBnCgq1DnWeZ6sASURRcr9K9iXZU99RHppNRQZxgvbHwEQXC0pF/+BOIjmdBZFw1mPvMe/e2jkD3V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3lJAeti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3lJAeti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189CCC2BCC7;
	Fri, 15 May 2026 16:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860877;
	bh=2GcgEyWpPEr5G5aVTTBB8dO4xOOcuTGErSMWNEFUg6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3lJAetiS2RgK4+ztxJ/Sd8tc9qgeYne9yNUUvbH/r/YPMa6Bswp1zxsr5VTZ+Jx/
	 0jACnZLidhbpCPm1t+zPBjOolzyJfqRrJofsEyZ4mnzGp38IVHDjUyjdTk0btOKqhG
	 dLJOBzNZ1S4jJmVAaaOumDyEtIl5HgJ52h7O1uQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 071/474] net: txgbe: fix firmware version check
Date: Fri, 15 May 2026 17:43:00 +0200
Message-ID: <20260515154716.578186455@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -696,7 +696,8 @@ static int txgbe_probe(struct pci_dev *p
 			 "0x%08x", etrack_id);
 	}
 
-	if (etrack_id < 0x20010)
+	if (wx->mac.type == wx_mac_sp &&
+	    ((etrack_id & 0xfffff) < 0x20010))
 		dev_warn(&pdev->dev, "Please upgrade the firmware to 0x20010 or above.\n");
 
 	txgbe = devm_kzalloc(&pdev->dev, sizeof(*txgbe), GFP_KERNEL);


