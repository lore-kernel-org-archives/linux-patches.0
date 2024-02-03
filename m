Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774BDF9D7;
	Sat,  3 Feb 2024 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933351; cv=none; b=SE+AcReFDSmdjI/1k2mTL13vtDH7MsGPDb2T/RT7cDUrf25jOvCfWU2uuFvuzbrmDd7uXSOvJb6kqrRj5eEjyb0/tGN9QeaJc3l2I/GA59/6h9RfPt4EY9cphLzljAp54XYw58UVq7Rj01FWKvOics/HMrjsVZfPpErAAQQU92w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933351; c=relaxed/simple;
	bh=n0x8oED9LFIZOY6+0EuwEgnUEkq9Lv8k4PSwHQc6sQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dhtt0FmhishNjEtQWaZbkc0WFcLt1NO9RJp522to/mpmfCHh8EPlf6x44w3RoMZGtGreQNxRixu1OLJlCsYl6D/9Xejq19j0pYVb8sOynAJWgrQ6a/mN3ofYW/nrSgyKUYakDLHLRIubQyGGZk23xGw39KKMhnyk3MX3+LqfLqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBzodRV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBzodRV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7D5C433F1;
	Sat,  3 Feb 2024 04:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933351;
	bh=n0x8oED9LFIZOY6+0EuwEgnUEkq9Lv8k4PSwHQc6sQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBzodRV0lZWRzwDihf42d118N7Qru3wTM/nJ0Mpn7Jdk2ksbyy41nqEF2wehA/YoL
	 A6ZZPshmuEBcoPiylkMTFTY2A4sVCZKWw1UIoLfg6Emotuw6g2hGTBTrdci/0Y2cjK
	 sL9c0QwYRoxFifP3NYmrL0Tj+IshcZxE3K3VXFCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herb Wei <weihao.bj@ieisystem.com>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/219] net: usb: ax88179_178a: avoid two consecutive device resets
Date: Fri,  2 Feb 2024 20:03:48 -0800
Message-ID: <20240203035324.662213010@linuxfoundation.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit d2689b6a86b9d23574bd4b654bf770b6034e2c7e ]

The device is always reset two consecutive times (ax88179_reset is called
twice), one from usbnet_probe during the device binding and the other from
usbnet_open.

Remove the non-necessary reset during the device binding and let the reset
operation from open to keep the normal behavior (tested with generic ASIX
Electronics Corp. AX88179 Gigabit Ethernet device).

Reported-by: Herb Wei <weihao.bj@ieisystem.com>
Tested-by: Herb Wei <weihao.bj@ieisystem.com>
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Link: https://lore.kernel.org/r/20231120121239.54504-1-jtornosm@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 5a1bf42ce156..d837c1887416 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1315,8 +1315,6 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	netif_set_tso_max_size(dev->net, 16384);
 
-	ax88179_reset(dev);
-
 	return 0;
 }
 
-- 
2.43.0



