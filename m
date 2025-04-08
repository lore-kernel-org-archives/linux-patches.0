Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F00B26A0AF;
	Tue,  8 Apr 2025 12:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115402; cv=none; b=cQbFcrN4dCtI7S3P7Y0dAI1ycpfvlb+QbEZiRtKa5Xap7AbcqEn789AHH5pEM6xeeQao2++yFarG2iAM+BOVS5Jkih+eCP8F6yRGShy1o1MAysgPuniQ4rJj+cBum1r7Gmx0Q0tr9h0LJcBIvwgtOenSBRZyrJk7JjRy47lbzfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115402; c=relaxed/simple;
	bh=/LjU+KVNLWWuquN89CIRahC1yIJymVGnQoW9OpgjN2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQf1gYz/+JCP9OAgQxTYikZRLWEjyOca8IL1Ek6zdfFeFBbRDtUvMEufVAddjaNeur69Yiz4Uctac/h4es4N6IW40Tn1Dzaa+jQbrVp07hY2+DVn093C+TwrjizAKreE4OQwWHVim+mUsGOz04tZK7V4sXih0B37msjs+1hSacI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnIdPorL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnIdPorL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED42FC4CEE5;
	Tue,  8 Apr 2025 12:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115402;
	bh=/LjU+KVNLWWuquN89CIRahC1yIJymVGnQoW9OpgjN2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnIdPorLizChiLdJ5lQz1Kdg8G3yXnlpDY/mNJLn+MTZ7rWp5Fm3cfAsqG8udWS9v
	 0erzhW6I/cCmIUbWDDqe4YRfJFQ27oI2lyiUi/QDA0hOKd8SzRqg8oDdEnkhiubTos
	 Axc/8gCFUGHXfVu/Wh0JHluvLuQZlDXm70esiaOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 424/499] staging: gpib: Add missing mutex unlock in agilent usb driver
Date: Tue,  8 Apr 2025 12:50:36 +0200
Message-ID: <20250408104901.801273362@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 55eb3c3a6388420afda1374b353717de32ae9573 ]

When no matching product id was found in the attach function the driver
returned without unlocking the agilent_82357a_hotplug_lock mutex.

Add the unlock call.

This was detected by smatch:
smatch warnings:
drivers/staging/gpib/agilent_82357a/agilent_82357a.c:1381 agilent_82357a_attach() warn: inconsistent returns 'global &agilent_82357a_hotplug_lock'.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202412210143.WJhYzXfD-lkp@intel.com/
Fixes: 4c41fe886a56 ("staging: gpib: Add Agilent/Keysight 82357x USB GPIB driver")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250111161457.27556-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8491e73a5223 ("staging: gpib: Fix Oops after disconnect in agilent usb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/agilent_82357a/agilent_82357a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
index 261fb6d2e9916..942ab663e4001 100644
--- a/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
+++ b/drivers/staging/gpib/agilent_82357a/agilent_82357a.c
@@ -1365,6 +1365,7 @@ static int agilent_82357a_attach(gpib_board_t *board, const gpib_board_config_t
 		break;
 	default:
 		dev_err(&usb_dev->dev, "bug, unhandled product_id in switch?\n");
+		mutex_unlock(&agilent_82357a_hotplug_lock);
 		return -EIO;
 	}
 #ifdef RESET_USB_CONFIG
-- 
2.39.5



