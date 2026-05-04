Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE3135A3AD;
	Mon,  4 May 2026 14:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904565; cv=none; b=h2G9F/lZ5CJaBjxyZDOPGOsZLR+nN0Xllf4rgOjAVkxwakhiOMWu0s+P/jjYV2zRTKLJObfM+21ijofPR5+NWIMdb0b8kIliNNODsqffX41YXiH9YLOqpHJYLCvoFfT+dDxvYZAB64zGsCKYInix8Wx4dgCzMGyKf4Ghewo+4tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904565; c=relaxed/simple;
	bh=KettIShVQn+XoNVg4N/Y8HUQQDDir2jfGe0eL6bU6Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INviV3uY7ooS3+dz1Yw9lKrXn0xJ5H308wFeIZZDobPLXWxCoFQrJY5Yaan9tPejnGczLY5CPh2f636wGHxUckBYqHGmGkx4o1SvFe02olwRow5XPhRg8057gTVNqYsnUOKzaxfPZXVuly/5gPDiLjARwV9ylX9G3TIyV6RYa0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I13mPwRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I13mPwRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E197C2BCB8;
	Mon,  4 May 2026 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904565;
	bh=KettIShVQn+XoNVg4N/Y8HUQQDDir2jfGe0eL6bU6Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I13mPwRoNYHXBi06lo/1R/OU2ADury+EfAM5Qg0xcv0kTG3mlzYB5I+qNKqiKgA6N
	 GU8J5d0EOdLnXBZEIzg2wWVHX0cqjd3YPGQx2VsqqqT343C+LzKgzjOCh8Qa7BLEqu
	 MYFw+Zg4yrhjfBnhdb4Bts6iEzGb35h8s+Ee6mcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 088/215] net: txgbe: fix firmware version check
Date: Mon,  4 May 2026 15:51:47 +0200
Message-ID: <20260504135133.373854327@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -668,7 +668,8 @@ static int txgbe_probe(struct pci_dev *p
 			 "0x%08x", etrack_id);
 	}
 
-	if (etrack_id < 0x20010)
+	if (wx->mac.type == wx_mac_sp &&
+	    ((etrack_id & 0xfffff) < 0x20010))
 		dev_warn(&pdev->dev, "Please upgrade the firmware to 0x20010 or above.\n");
 
 	txgbe = devm_kzalloc(&pdev->dev, sizeof(*txgbe), GFP_KERNEL);


