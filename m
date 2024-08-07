Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740FA27448;
	Wed,  7 Aug 2024 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043359; cv=none; b=gFCIGt82GHPN0fIuSYKJPKzs6322Fzf/ZxnvNJAIrtoZglANaM5YW+8ej+Z4+YKtvWbwsu/nbOpuSpN30zychyn6do1bPTL/d1TsgzE831Vp0XSzb5HLeA76bjZiax3UvsLth5FtvLSHkjaRNal180kumv9l+SP6ZoKUiN9hjeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043359; c=relaxed/simple;
	bh=eAxlgFN994ZSyxf2Gj8IJ699a+ss/FyKc31/9NT8BVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ro9VTxVeR9u4Uxz1bgras6WQZvAnVMF027y1+5hkW9UepW//pxZENXudrF/WJWUM3OjE7bPFaxmj59hkTh5DaLWJTF/WxNmz+W5Jd0mAc/LryPBlhMUi/ih3GU53To1mNVekBgv9ggb+z/2nMl58+o5Im5uteiNFW7o1/G081KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3WdMfby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3WdMfby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1A6C4AF0B;
	Wed,  7 Aug 2024 15:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043359;
	bh=eAxlgFN994ZSyxf2Gj8IJ699a+ss/FyKc31/9NT8BVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3WdMfbyzr0/qNnqs1xloNzwi30wlUZQ3yLvkm0sNhTwf1JZVQaXH4CYTjcW2ubvG
	 mwNK8wZ7RnQI3ZnrrzSrtzEHE6KrzAdMGlsD87wsXN2BdwvVrexkz/UUjFAZdw5MNi
	 UC0MHKMhqIK4/g+dFF2DPaIikAKnnypb/zIyDfRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/121] Bluetooth: hci_sync: Fix suspending with wrong filter policy
Date: Wed,  7 Aug 2024 16:59:54 +0200
Message-ID: <20240807150021.439165707@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 96b82af36efaa1787946e021aa3dc5410c05beeb ]

When suspending the scan filter policy cannot be 0x00 (no acceptlist)
since that means the host has to process every advertisement report
waking up the system, so this attempts to check if hdev is marked as
suspended and if the resulting filter policy would be 0x00 (no
acceptlist) then skip passive scanning if thre no devices in the
acceptlist otherwise reset the filter policy to 0x01 so the acceptlist
is used since the devices programmed there can still wakeup be system.

Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b3f5714dab342..6dab0c99c82c7 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2862,6 +2862,27 @@ static int hci_passive_scan_sync(struct hci_dev *hdev)
 	 */
 	filter_policy = hci_update_accept_list_sync(hdev);
 
+	/* If suspended and filter_policy set to 0x00 (no acceptlist) then
+	 * passive scanning cannot be started since that would require the host
+	 * to be woken up to process the reports.
+	 */
+	if (hdev->suspended && !filter_policy) {
+		/* Check if accept list is empty then there is no need to scan
+		 * while suspended.
+		 */
+		if (list_empty(&hdev->le_accept_list))
+			return 0;
+
+		/* If there are devices is the accept_list that means some
+		 * devices could not be programmed which in non-suspended case
+		 * means filter_policy needs to be set to 0x00 so the host needs
+		 * to filter, but since this is treating suspended case we
+		 * can ignore device needing host to filter to allow devices in
+		 * the acceptlist to be able to wakeup the system.
+		 */
+		filter_policy = 0x01;
+	}
+
 	/* When the controller is using random resolvable addresses and
 	 * with that having LE privacy enabled, then controllers with
 	 * Extended Scanner Filter Policies support can now enable support
-- 
2.43.0



