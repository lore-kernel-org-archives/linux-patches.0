Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E26851356C;
	Wed, 30 Sep 2026 17:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789841; cv=none; b=kcma3utAOuMcamkWwXTzUVMBnskcVY1CMWZqyQEAQqahPI4cZ0qAGIm/H6G9TCW5ayplnZZU56+9IWt5WujNaLIvr/lW+lhP7tAqO6tGIJNfVujwxQm1boFB5KC31Ch3aXa69Chx2D3Vhz/350OHlLylpCd8xXkuIOUCkDKLy2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789841; c=relaxed/simple;
	bh=gK2w40vE2vOCsxxBwdrw3j3xkfV27cIVonr6+XW958Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j3zBL4oq1CaqXptb+UUNhJQpBv/aVVjPUc1WKJ6/33kioHZiUSVTeDzJikezQk+EUebYYuu6lfJrUs6AEXupm1Ec+k0kC9sewtCyuC2PICMlXjDoKGAxf3+YHpfiAznS/UCR9oTLfp5VPFsIGgfANRdGw0Im/o691c+0a/a0/dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwoYiy4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwoYiy4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5401F000FF;
	Wed, 30 Sep 2026 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789840;
	bh=pcLenmvzbruRgPd1sAUp0MzKyH9goxinbWkGRE8CRHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwoYiy4nUwyzoPhHc6Q/i+TMTp5QJMVCo+1wHluE+4+VCjbSxcgKhTzvEql4qOJgZ
	 kpl9oYuiSQhfIrAbmX/t/0etnUQis5jbNlH/HzBKZmq0CNCz57gfoRz0Lj7Q5MngQf
	 FAIe+F6Oi3ZCosABCG5tiwvQ+YLavx/wgM7DeO4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 619/877] usb: cdns3: rename hibernated argument of role->resume() to lost_power
Date: Wed, 30 Sep 2026 17:25:30 +0200
Message-ID: <20260930152428.010232033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 0bde749c58c72405c54a1eabf6266a0273377226 ]

The cdns_role_driver->resume() callback takes a second boolean argument
named `hibernated` in its implementations. This is mistaken; the only
potential caller is:

int cdns_resume(struct cdns *cdns)
{
	/* ... */

	if (cdns->roles[cdns->role]->resume)
		cdns->roles[cdns->role]->resume(cdns, cdns_power_is_lost(cdns));

	return 0;
}

The argument can be true in cases outside of return from hibernation.
Reflect the true meaning by renaming both arguments to `lost_power`.

Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20250205-s2r-cdns-v7-3-13658a271c3c@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: eae6460f6173 ("usb: cdnsp: fix wakeup from S3 after controller context loss")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    4 ++--
 drivers/usb/cdns3/cdnsp-gadget.c |    2 +-
 drivers/usb/cdns3/core.h         |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -3484,7 +3484,7 @@ __must_hold(&cdns->lock)
 	return 0;
 }
 
-static int cdns3_gadget_resume(struct cdns *cdns, bool hibernated)
+static int cdns3_gadget_resume(struct cdns *cdns, bool lost_power)
 {
 	struct cdns3_device *priv_dev = cdns->gadget_dev;
 
@@ -3492,7 +3492,7 @@ static int cdns3_gadget_resume(struct cd
 		return 0;
 
 	cdns3_gadget_config(priv_dev);
-	if (hibernated)
+	if (lost_power)
 		writel(USB_CONF_DEVEN, &priv_dev->regs->usb_conf);
 
 	return 0;
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -2025,7 +2025,7 @@ static int cdnsp_gadget_suspend(struct c
 	return 0;
 }
 
-static int cdnsp_gadget_resume(struct cdns *cdns, bool hibernated)
+static int cdnsp_gadget_resume(struct cdns *cdns, bool lost_power)
 {
 	struct cdnsp_device *pdev = cdns->gadget_dev;
 	enum usb_device_speed max_speed;
--- a/drivers/usb/cdns3/core.h
+++ b/drivers/usb/cdns3/core.h
@@ -30,7 +30,7 @@ struct cdns_role_driver {
 	int (*start)(struct cdns *cdns);
 	void (*stop)(struct cdns *cdns);
 	int (*suspend)(struct cdns *cdns, bool do_wakeup);
-	int (*resume)(struct cdns *cdns, bool hibernated);
+	int (*resume)(struct cdns *cdns, bool lost_power);
 	const char *name;
 #define CDNS_ROLE_STATE_INACTIVE	0
 #define CDNS_ROLE_STATE_ACTIVE		1


