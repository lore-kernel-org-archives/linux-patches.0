Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09052FC89C;
	Tue, 26 Aug 2025 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219258; cv=none; b=DykuQGTPkEQD8I75YfgEC3LcbtJJaDE0bsyc1lMQX0OpBd4cPNwP+el5zxmAPvWlfltn/tfSYqqopTjVKC2DBd+HPd3obVeScxWeDVxI/I0XRpibHtGx/ZyYo0FQ6Ijxff2YaFyk3NAToTlxdeXubZkPrsam4zVqIALz0sPytKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219258; c=relaxed/simple;
	bh=Et7jdhk7XkMtYMn8A7Ax810llaiX7yCPtofZhYEPVyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgjT0G6H0U5MTp/powWS113TyKMFFQxsNKudUJ1eUuKUcvQ5pPRpGhhqdNeJRiVa0lgF8nDtYbdUUpRAc6PMuMSMcR/xcOxT7xbjtUreBoEmWT64s896CmuVZ5v8guJ34xmV+ctlMaaxZu22cVo3C80aj+4++mzFNIKZ17+joAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JC5Lrbqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JC5Lrbqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDE3C4CEF1;
	Tue, 26 Aug 2025 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219258;
	bh=Et7jdhk7XkMtYMn8A7Ax810llaiX7yCPtofZhYEPVyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JC5LrbqymOIeTuH/74ibmkdp+WBW1Dw26T+o36YbTxZ+kWBfpFIU7jDSsvN/1HrRp
	 +bMWw9buq2F5IRqI20rbggD0uZwBoLxiXlmfKZv+IWlwG55xzWMYLrYzpadoMbko7a
	 pMd5Zu/LnojTd7t0Fjp5QkeK/kc+UJ6LtNNyswHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 286/403] usb: gadget: udc: renesas_usb3: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:10:12 +0200
Message-ID: <20250826110914.711235376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 868837b0a94c6b1b1fdbc04d3ba218ca83432393 upstream.

Make sure to drop the reference to the companion device taken during
probe when the driver is unbound.

Fixes: 39facfa01c9f ("usb: gadget: udc: renesas_usb3: Add register of usb role switch")
Cc: stable@vger.kernel.org	# 4.19
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2551,6 +2551,7 @@ static int renesas_usb3_remove(struct pl
 	struct renesas_usb3 *usb3 = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(usb3->dentry);
+	put_device(usb3->host_dev);
 	device_remove_file(&pdev->dev, &dev_attr_role);
 
 	cancel_work_sync(&usb3->role_work);


