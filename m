Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477DF2874F8;
	Mon, 13 Apr 2026 16:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097909; cv=none; b=YUlCwMkh4FAM0kQesofQlcdfXna2R02PIokbW7l9Id4DmPl2jYbLgl9RiMjaGnJXbwVjnY9b5VZGdFbok8b3/g7ODdeQofQKwdy9VcU2njSSybJJ9wNOhnyDEM2Jj2CeYDnyl7rN97QFM1x6JrEumaFhkb+Z0pOpW8fCGfK1evE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097909; c=relaxed/simple;
	bh=V2dLuNB4sNBypTGoQ/AflzjLAhYWzCx4n4FYAlAx2BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7txIHQUyvWmlbbhkB2Da3O6GxTMnKCOmDQck+FGqW21soqvj1NLPDyeqvLDM8jFCtalm1fHBSZMwy+rWTUpoDLDuY/DuWLbn3pH+dbRs6afhJyeprRpXwHz7Oy9tnPtDN0F7Bq/sq6zRg2ybhKn3FgHBf6Vv0cw+3zqfJUDNF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnBMfNPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnBMfNPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FF7C2BCAF;
	Mon, 13 Apr 2026 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097909;
	bh=V2dLuNB4sNBypTGoQ/AflzjLAhYWzCx4n4FYAlAx2BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnBMfNPrtfznLYO0vDEgtGslcHwqIRT9UltPTmxwsuNTYTOMbJna2qXU2AiAF3wS8
	 JsQZM8nuKWP7A2B4YvL8bTEsyi23lgF+1z6/sro7eUOci0M6t4Jj1c+7MUN11WO+Op
	 SN69Zo9y3HBVb1hHnYs8vSBlMeaxrWfzLk6zVzC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Anas Iqbal <mohd.abd.6602@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/570] Bluetooth: hci_ll: Fix firmware leak on error path
Date: Mon, 13 Apr 2026 17:57:30 +0200
Message-ID: <20260413155842.444721378@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anas Iqbal <mohd.abd.6602@gmail.com>

[ Upstream commit 31148a7be723aa9f2e8fbd62424825ab8d577973 ]

Smatch reports:

drivers/bluetooth/hci_ll.c:587 download_firmware() warn:
'fw' from request_firmware() not released on lines: 544.

In download_firmware(), if request_firmware() succeeds but the returned
firmware content is invalid (no data or zero size), the function returns
without releasing the firmware, resulting in a resource leak.

Fix this by calling release_firmware() before returning when
request_firmware() succeeded but the firmware content is invalid.

Fixes: 371805522f87 ("bluetooth: hci_uart: add LL protocol serdev driver support")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index e4e5b26e2c33b..02c2122b452a8 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -541,6 +541,8 @@ static int download_firmware(struct ll_device *lldev)
 	if (err || !fw->data || !fw->size) {
 		bt_dev_err(lldev->hu.hdev, "request_firmware failed(errno %d) for %s",
 			   err, bts_scr_name);
+		if (!err)
+			release_firmware(fw);
 		return -EINVAL;
 	}
 	ptr = (void *)fw->data;
-- 
2.51.0



