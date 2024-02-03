Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A99B101C1;
	Sat,  3 Feb 2024 04:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933403; cv=none; b=mdFwkda2QRG1WaLZ+j6LYDIF9brWdY4fatZdcehwPEPioNc+af0K+5DFqevDUYaEqJTgimvZH8vcWTOqdUvXUHyXV1/MY9i5kOOAzeIAZNS/lYOcYmpZZTVk9t0NIfUdkS9oXTVqbliQmBpwLTb0PkPSR+OPUSSDU1WMk/YbCGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933403; c=relaxed/simple;
	bh=zz2p8MT9QvJEMqyfOCsXm87A7PtJjSHVJFcLuQexTlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4m+DS5+7FUJpX10XEG53Q9PK3B7at/TJvkl2OssUsTEv02sCaWqeLG5C6UlNJzYP9zoMbySjSjMEcHvlZoiM0qN+fioDuSIMG6743ek/uNvGlOstNzGm1GDg61ZoEj0KRNza2l5HDPuWiLZHW0WhuZxLUCIQoZZmcXt7MKhO18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y01DMftS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y01DMftS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219E5C433F1;
	Sat,  3 Feb 2024 04:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933403;
	bh=zz2p8MT9QvJEMqyfOCsXm87A7PtJjSHVJFcLuQexTlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y01DMftSowlt0mBwAD3wgwDNZM2pxrGPoD0AdP4qUWzY7YcBjKFF4BlTqhFQWMBnu
	 3rZuA942YKm4pN/KdInduewtiV2K8heR7MXZtNxi3poSpz6aAUEbC9cZHR5Ib9xIfB
	 9cUW4V/iFzfUakc98b/Wa8WxT+qTy5c20KJAd4bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	clancy shang <clancy.shang@quectel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/219] Bluetooth: hci_sync: fix BR/EDR wakeup bug
Date: Fri,  2 Feb 2024 20:04:30 -0800
Message-ID: <20240203035330.840411694@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: clancy shang <clancy.shang@quectel.com>

[ Upstream commit d4b70ba1eab450eff9c5ef536f07c01d424b7eda ]

when Bluetooth set the event mask and enter suspend, the controller
has hci mode change event coming, it cause controller can not enter
sleep mode. so it should to set the hci mode change event mask before
enter suspend.

Signed-off-by: clancy shang <clancy.shang@quectel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index d74fe13f3dce..45d19294aa77 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3780,12 +3780,14 @@ static int hci_set_event_mask_sync(struct hci_dev *hdev)
 	if (lmp_bredr_capable(hdev)) {
 		events[4] |= 0x01; /* Flow Specification Complete */
 
-		/* Don't set Disconnect Complete when suspended as that
-		 * would wakeup the host when disconnecting due to
-		 * suspend.
+		/* Don't set Disconnect Complete and mode change when
+		 * suspended as that would wakeup the host when disconnecting
+		 * due to suspend.
 		 */
-		if (hdev->suspended)
+		if (hdev->suspended) {
 			events[0] &= 0xef;
+			events[2] &= 0xf7;
+		}
 	} else {
 		/* Use a different default for LE-only devices */
 		memset(events, 0, sizeof(events));
-- 
2.43.0



