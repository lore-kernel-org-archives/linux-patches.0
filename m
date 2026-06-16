Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC9C4779B1;
	Tue, 16 Jun 2026 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629304; cv=none; b=SI2NzcJva7FVg90A3Ow5815pMXRniZ7tAjcyuWVFkMU2BhjUef6OZSQifertQwHhWmxprPBiY7fVrpVZiPWuOn1cE5eIFGW3RBylP50maxpWY6Z6ADz4SuznSTM7U1Y2hd/6D32ZvPH4JLSwkIzwU2FU0JffFcgEtibRgHV9Xf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629304; c=relaxed/simple;
	bh=ub+cR1Grz7DO2qNydFVVAvEQ8XmL4Z/zPi+GcwhK7Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VImDUPa/QntsacsKu7YfMH1mGgkxVFNSY/3Y6qLrgtH0aWs4cu4npYLX7901FM4S5cOSYfVUOJrqc54US/ga4BfeNSzKtOfcVRA2fCgopGqNs/UWxpRTakomR3YdWin5JjYugGuU2Qo33+i+Q/EwSY2/a9iDojGCCzQkqURqk64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19atAefO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19atAefO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF96C1F000E9;
	Tue, 16 Jun 2026 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629302;
	bh=mNmmWcJ3UkSZHZdIurA7aPUlBuxpz/eD2YBDpZ+UkLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19atAefOnnnrz/N6YW6z1eKXMvIqhrhp1Tt8oTyvyQp0oyDpkP7ivqqFfvx4m41Rs
	 hZyEz1NVORaXB9UYYUaGcQpKcAg86S6mDlwxWvuDaw8G+vMo1WaqM/v8gstQEYggTW
	 jLKJjIySxuixu2BwaBXoJ9S34Bx6p749Bb9O3p5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/452] usb: gadget: u_ether: Fix NULL pointer deref in eth_get_drvinfo
Date: Tue, 16 Jun 2026 20:27:59 +0530
Message-ID: <20260616145130.894059284@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit e002e92e88e12457373ed096b18716d97e7bbb20 ]

Commit ec35c1969650 ("usb: gadget: f_ncm: Fix net_device lifecycle with
device_move") reparents the gadget device to /sys/devices/virtual during
unbind, clearing the gadget pointer. If the userspace tool queries on
the surviving interface during this detached window, this leads to a
NULL pointer dereference.

Unable to handle kernel NULL pointer dereference
Call trace:
 eth_get_drvinfo+0x50/0x90
 ethtool_get_drvinfo+0x5c/0x1f0
 __dev_ethtool+0xaec/0x1fe0
 dev_ethtool+0x134/0x2e0
 dev_ioctl+0x338/0x560

Add a NULL check for dev->gadget in eth_get_drvinfo(). When detached,
skip copying the fw_version and bus_info strings, which is natively
handled by ethtool_get_drvinfo for empty strings.

Suggested-by: Val Packett <val@packett.cool>
Reported-by: Val Packett <val@packett.cool>
Closes: https://lore.kernel.org/linux-usb/10890524-cf83-4a71-b879-93e2b2cc1fcc@packett.cool/
Fixes: ec35c1969650 ("usb: gadget: f_ncm: Fix net_device lifecycle with device_move")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260316-eth-null-deref-v1-1-07005f33be85@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_ether.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 49ff3fc62f7469..91b2d1f5ed005b 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -112,8 +112,10 @@ static void eth_get_drvinfo(struct net_device *net, struct ethtool_drvinfo *p)
 
 	strscpy(p->driver, "g_ether", sizeof(p->driver));
 	strscpy(p->version, UETH__VERSION, sizeof(p->version));
-	strscpy(p->fw_version, dev->gadget->name, sizeof(p->fw_version));
-	strscpy(p->bus_info, dev_name(&dev->gadget->dev), sizeof(p->bus_info));
+	if (dev->gadget) {
+		strscpy(p->fw_version, dev->gadget->name, sizeof(p->fw_version));
+		strscpy(p->bus_info, dev_name(&dev->gadget->dev), sizeof(p->bus_info));
+	}
 }
 
 /* REVISIT can also support:
-- 
2.53.0



