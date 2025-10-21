Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FE277C81;
	Tue, 21 Oct 2025 20:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077479; cv=none; b=oYt4MH1MDRmOLF6Y8L9Je8BDoN/DLIt81MnDMIvtaRN3uAhfMGP+nx16hmwR1RfFP4FgavmY/yJ5hGOdNUKiXs9fJZI8Ji4Ott0BRXSm9vtKYD0AC8ywnHyNH63fljm6vJ7Nxv++Yo5B7ICWgy7CKe7KqRrxJqqJ7tGFDswSLUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077479; c=relaxed/simple;
	bh=D3d/q+MkHu/2UC5zVcRufNbZ1WzUA6qkDtiMWuZK7Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baMsuu5IKVAiI2ETPQDD1ChHIXX9CrHIaq0GAzZPzdZI9umgMAYCkYCZbQ0E6bkd5MFlbjVk5zEAHcoYn5bi8+348TLX7s4WUbagB6ArIWQaiNzGhx+Q50QNTjNu+5rYmrE7/V8hj7UYYK+SmJurgxsZEyQTjAnFwtDOQRu73cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLPVynyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLPVynyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D630C4CEF1;
	Tue, 21 Oct 2025 20:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077479;
	bh=D3d/q+MkHu/2UC5zVcRufNbZ1WzUA6qkDtiMWuZK7Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLPVynyRjjVhqiahUhXN0cbu4tcv9WSCFKtPpHTTH6qRxFgbLQljAH55x+B81jSau
	 6+GsepTiY4Pgf7UCDppEImRiU8GgCeahnJSgJ5SMifmDOuA095mSCklgXE4GmrQLte
	 b0O7/a/3KUUQyHIkO0B24BfTLY+ABaCXhP4U2XOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Zhang <rui1.zhang@intel.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 117/159] HID: intel-thc-hid: Intel-quickspi: switch first interrupt from level to edge detection
Date: Tue, 21 Oct 2025 21:51:34 +0200
Message-ID: <20251021195045.977113699@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Even Xu <even.xu@intel.com>

[ Upstream commit 8fe2cd8ec84b3592b57f40b080f9d5aeebd553af ]

The original implementation used level detection for the first interrupt
after device reset to avoid potential interrupt line noise and missed
interrupts during the initialization phase. However, this approach
introduced unintended side effects when tested with certain touch panels,
including:
 - Delayed hardware interrupt response
 - Multiple spurious interrupt triggers

Switching back to edge detection for the first interrupt resolves these
issues while maintaining reliable interrupt handling.

Extensive testing across multiple platforms with touch panels from
various vendors confirms this change introduces no regressions.

[jkosina@suse.com: properly capitalize shortlog]
Fixes: 9d8d51735a3a ("HID: intel-thc-hid: intel-quickspi: Add HIDSPI protocol implementation")
Tested-by: Rui Zhang <rui1.zhang@intel.com>
Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
index e6ba2ddcc9cbc..16f780bc879b1 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
@@ -280,8 +280,7 @@ int reset_tic(struct quickspi_device *qsdev)
 
 	qsdev->reset_ack = false;
 
-	/* First interrupt uses level trigger to avoid missing interrupt */
-	thc_int_trigger_type_select(qsdev->thc_hw, false);
+	thc_int_trigger_type_select(qsdev->thc_hw, true);
 
 	ret = acpi_tic_reset(qsdev);
 	if (ret)
-- 
2.51.0



