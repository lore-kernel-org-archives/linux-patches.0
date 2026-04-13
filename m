Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF624DCF6;
	Mon, 13 Apr 2026 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097103; cv=none; b=RIPR/yWLt8PKN25nPzOAzObyoImOeOHnfP7spRkzsBI9maei1FCQukppE1Reh0qkT2PK5Ket7MMnGj8TQ3sy333eK59RXIXjOGz9WpjvcGq/EZi79uaOnCHhuzBh8MrQ03vePsGCO96ZiftSnAAWuKyhFltx+N0Iv7FRZaeMSxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097103; c=relaxed/simple;
	bh=OE7ZN7pU+YxSBJ12DM3t8nsLC5egA954stA+PhCqgT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzfprH6h5/4mCnS/5bxtAfYeEpQnMZ4+P525HpjPzzYmWtlYz04P9BR9PMvmgRGkR+c3bFi+KT5bH5kCgUrgaS5NXYOUH8WzD7i8o/1CT8oUj7EdTBVRYOQrW7jHGmfiQ38ivdnDyPgK/PuIU1qlrePVQH30smbBTyN1LeDQ3yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvkX5iVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvkX5iVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03551C2BCAF;
	Mon, 13 Apr 2026 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097103;
	bh=OE7ZN7pU+YxSBJ12DM3t8nsLC5egA954stA+PhCqgT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvkX5iVuBZOPJCc7Q3Oxnnlgij7d+lSLjhWfZ+dzadm73/e1qXMWeET0OG42AXsSP
	 VWKYJl4Z9op6RgGYPuq/VX1sYSJsraDtA0Y2UKdm9R3Tv6mWpYJDebXpZYHgdjtfbJ
	 3dy8mJcy6a5HT3CmCkS0l95NDXOWOOR/h6jWWXMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 50/55] mmc: vub300: fix NULL-deref on disconnect
Date: Mon, 13 Apr 2026 18:01:24 +0200
Message-ID: <20260413155726.699181216@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit dff34ef879c5e73298443956a8b391311ba78d57 upstream.

Make sure to deregister the controller before dropping the reference to
the driver data on disconnect to avoid NULL-pointer dereferences or
use-after-free.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2371,8 +2371,8 @@ static void vub300_disconnect(struct usb
 			usb_set_intfdata(interface, NULL);
 			/* prevent more I/O from starting */
 			vub300->interface = NULL;
-			kref_put(&vub300->kref, vub300_delete);
 			mmc_remove_host(mmc);
+			kref_put(&vub300->kref, vub300_delete);
 			pr_info("USB vub300 remote SDIO host controller[%d]"
 				" now disconnected", ifnum);
 			return;


