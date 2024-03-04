Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D336C200D4;
	Mon,  4 Mar 2024 21:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587617; cv=none; b=oDNh+RqLpUEKO69kwqcIkAzu7/Qp2GuX41wgqqJVQ4gDTS7niqt909DIFpvk77glHMAOToHV2afgtHOfPDl6c1UqaSA/pOSgJBNytwFDMSiYlfLC522mN8dg4FvRZKWjEXTkblZNnAvlNLbeJBWvl60pdIM17N5skbFpPBgSb7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587617; c=relaxed/simple;
	bh=7lQDGiH+NCeKc4Gd5uDuWrpF/UJnLgtAf7V9kMcLBBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=STJPssmSd8ePEsF88sVxmOXtlUQbBtozVI/pnkhQqR3nSrLNFg8PNzcaP6dDkWW6xr/kDpF68EiWB8olT25Quu41FWIC7WkqBiAvkgMPYU1azHJdWljXGprY+DFudZbJjESQzItF3elLvNceC1WwEisuY5jM9IdWp2CpMB8L0PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpNpmrpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpNpmrpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F02C433F1;
	Mon,  4 Mar 2024 21:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587617;
	bh=7lQDGiH+NCeKc4Gd5uDuWrpF/UJnLgtAf7V9kMcLBBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpNpmrpFODSnTCp9U8TO2Mi5U+++ljVaoZ3NS9jW+tnaat6agEnsfzAU04Hqti4Fx
	 983Z58cTREg44CVAlbhatIFj7HFewrC+kU69b5/uYDA0U8RxhDfpbvysJvrWQ1+/ip
	 QZ66xqzdKA+xvv/HuDSIlMfnlcqDHB54suHlck7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
	Simon Horman <horms@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 025/162] Bluetooth: hci_sync: Check the correct flag before starting a scan
Date: Mon,  4 Mar 2024 21:21:30 +0000
Message-ID: <20240304211552.637478542@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit 6b3899be24b16ff8ee0cb25f0bd59b01b15ba1d1 ]

There's a very confusing mistake in the code starting a HCI inquiry: We're
calling hci_dev_test_flag() to test for HCI_INQUIRY, but hci_dev_test_flag()
checks hdev->dev_flags instead of hdev->flags. HCI_INQUIRY is a bit that's
set on hdev->flags, not on hdev->dev_flags though.

HCI_INQUIRY equals the integer 7, and in hdev->dev_flags, 7 means
HCI_BONDABLE, so we were actually checking for HCI_BONDABLE here.

The mistake is only present in the synchronous code for starting an inquiry,
not in the async one. Also devices are typically bondable while doing an
inquiry, so that might be the reason why nobody noticed it so far.

Fixes: abfeea476c68 ("Bluetooth: hci_sync: Convert MGMT_OP_START_DISCOVERY")
Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 97284d9b2a2e3..39ccbb1be24c3 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5629,7 +5629,7 @@ static int hci_inquiry_sync(struct hci_dev *hdev, u8 length)
 
 	bt_dev_dbg(hdev, "");
 
-	if (hci_dev_test_flag(hdev, HCI_INQUIRY))
+	if (test_bit(HCI_INQUIRY, &hdev->flags))
 		return 0;
 
 	hci_dev_lock(hdev);
-- 
2.43.0



