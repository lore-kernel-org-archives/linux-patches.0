Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD25472524;
	Tue, 21 Jul 2026 18:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658669; cv=none; b=jKLVE8Fzhv5WdCVsR6/yDrtvLwD3mKPbbIXMTABmm3nDG/GM56SpkKVnGWZXVk4bBnZbto1V73n2TTlDciT4sPg5Cy3bKhqlouGp6l4MnvMgI3ZMenvHFPlOsFgtthoB4GX9Q+y0WbGeUhqdulI6u48nYEEbsVy47mzkvqV/4PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658669; c=relaxed/simple;
	bh=yF1EVqb+DTma3gKQkQ5fpf1OYabUjh6PVRlQBcuYc9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svhICcHpu18n1/xWFa+ELnVgYfgV1bdHUKhheoXxw45Q97KhJvfbUhqJmdxweGmUquIiixknWWEaR5uPWdGzANZFPxZybVW6khNS0tOvfITJFefPzhGrCbZlQE2apKtxindf/uu00jbTkRGBSnGkuBZwu89mbheSYi/ovS5mbqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ygh/7P3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ygh/7P3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880DA1F00A3D;
	Tue, 21 Jul 2026 18:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658668;
	bh=n+VNTWGo/7C7fh9t4m+m114aY5LViqyLyHANlmjOh6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ygh/7P3hKKqnB8lTjkvX1XQOhPS7zWmFWKFhCopD8v3z6sCnlcKVpWWAzkHErCLsx
	 VAm5PxZ7Zpp2r66cNapPuzkQrFglO4AF870V/vHeNN7QzfO4FErjQ62bBinSclgHXP
	 piSOqxBJGrK0zMAwj6seFKmuLLBjWhPzgVV8Qyyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 1230/1611] power: supply: max17042: fix OF node reference imbalance
Date: Tue, 21 Jul 2026 17:22:26 +0200
Message-ID: <20260721152543.105911987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 68d234144b7dffd1f50b07ba74d0d6e833ef43a4 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 0cd4f1f77ad4 ("power: supply: max17042: add platform driver variant")
Cc: stable@vger.kernel.org	# 6.14
Cc: Dzmitry Sankouski <dsankouski@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260407123338.2677375-1-johan@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17042_battery.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -1165,7 +1165,8 @@ static int max17042_platform_probe(struc
 	if (!i2c)
 		return -EINVAL;
 
-	dev->of_node = dev->parent->of_node;
+	device_set_of_node_from_dev(dev, dev->parent);
+
 	id = platform_get_device_id(pdev);
 	irq = platform_get_irq(pdev, 0);
 


