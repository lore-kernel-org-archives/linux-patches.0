Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0465D23D7DD;
	Tue, 26 Aug 2025 13:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214793; cv=none; b=VhBvQg/w7JVgFSYfDHLDtb+1MdRtlE9FVTxOnLbqO+yE3Q85GvtC1UFmVbYxvfKJAZPSn1Wphm8fYrTHm5keOfpt7AyiaHug2ez7SAID3CF7v/3QQ1OiyynLJBcf7CrFe/NDROpya5uDfP7jBjBSZ5uNkztxRg4gqqaTWTYyU3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214793; c=relaxed/simple;
	bh=uCzyHbZs13tx7Tz7HYrQmk3p6OP+3+yly9o8AFvtuCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOGE7BFwXOkD9XoqahMf9ygjLxKyrwAHHbsOikpooW8NMrzeDTOkcFgzgXqB+KXIaHvN8ExI6sMCJnE8JtEI2YmyATWtNqlA7bq1DdrlRH0m/1fz3aqe0qfEOy01hW1o/BOgDBEAUYgCl8U6aUXWlY6Utewe2XlnZ8ZvOmCJtms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QFGoXBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QFGoXBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8324CC4CEF1;
	Tue, 26 Aug 2025 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214792;
	bh=uCzyHbZs13tx7Tz7HYrQmk3p6OP+3+yly9o8AFvtuCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QFGoXBsvY6/eNZnZw7kzW4WGnV3lZfVikcAdiX/9aOoj96NupfeA2DHj85bvYlpB
	 cjCt+J97lHm9AaVpFhzmR4HTtRL8MFkED9ACepCEbDBWcVQnAugeecFdTJTbznvDxX
	 lxeQrXbZRq+MsdAHS6YwG3dOiWnXWvlAhlgPzQBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 271/482] usb: gadget: udc: renesas_usb3: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:08:44 +0200
Message-ID: <20250826110937.464620177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2594,6 +2594,7 @@ static int renesas_usb3_remove(struct pl
 	struct renesas_usb3 *usb3 = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(usb3->dentry);
+	put_device(usb3->host_dev);
 	device_remove_file(&pdev->dev, &dev_attr_role);
 
 	cancel_work_sync(&usb3->role_work);


