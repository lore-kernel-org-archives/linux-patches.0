Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1266834D937;
	Fri, 21 Nov 2025 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732259; cv=none; b=ViK4agfpy5pxrv5AhwKYtuAPM37lWfKfLpqMVCVuDSlUzuNuoZfnY3cgsY2aGhyzG7PB2fTTh15aWwfA343QrxQAZy1YX9xWale94F4zLdxru2V1Jii4AJnBVvHwzzkALWX0/yhqzx+vWuaBL0rzKbBi2+kIsPXtwqkYsoW4tm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732259; c=relaxed/simple;
	bh=DaiYBVEGH7XYJxpcxQODYL1yCLc8/UlcpkH5cYrPgVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+9k9TwJ04F0u4/f42POP6S2tyh/RzbH6E+EaxBPckAOvChhcyRdOsKJ002qyCrV84UTa/eJR53TP540nQ85hdEQXH6jibtBevOhZgknjTikg+wlxEWkAyxlM0Oadp/aAlLo32/9ANvf8hAX8dT8AcztTLyEuGWtYsgt3u94mbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxJNJImh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxJNJImh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DA7C4CEFB;
	Fri, 21 Nov 2025 13:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732258;
	bh=DaiYBVEGH7XYJxpcxQODYL1yCLc8/UlcpkH5cYrPgVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxJNJImhI3541CbyJpF0YE/IBliOmR51nV3Sp3ZbZxj2NADzw4Uw3mU7AmcHxmGLl
	 iUzIGvtQTtUhUUd8Q8VUejeOCxHf1vWhHDNrTvXpl9mQTqw8FeGd+7Zd2N7sDD+O4g
	 MomvYHFXpEyPGVHVQUeVrhksgHVkGKxX61ysGRno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Owen Gu <guhuinan@xiaomi.com>
Subject: [PATCH 6.6 057/529] usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
Date: Fri, 21 Nov 2025 14:05:56 +0100
Message-ID: <20251121130233.047409994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Owen Gu <guhuinan@xiaomi.com>

commit cfd6f1a7b42f62523c96d9703ef32b0dbc495ba4 upstream.

A race condition occurs when ffs_func_eps_enable() runs concurrently
with ffs_data_reset(). The ffs_data_clear() called in ffs_data_reset()
sets ffs->epfiles to NULL before resetting ffs->eps_count to 0, leading
to a NULL pointer dereference when accessing epfile->ep in
ffs_func_eps_enable() after successful usb_ep_enable().

The ffs->epfiles pointer is set to NULL in both ffs_data_clear() and
ffs_data_close() functions, and its modification is protected by the
spinlock ffs->eps_lock. And the whole ffs_func_eps_enable() function
is also protected by ffs->eps_lock.

Thus, add NULL pointer handling for ffs->epfiles in the
ffs_func_eps_enable() function to fix issues

Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Link: https://lore.kernel.org/r/20250915092907.17802-1-guhuinan@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1941,7 +1941,12 @@ static int ffs_func_eps_enable(struct ff
 	ep = func->eps;
 	epfile = ffs->epfiles;
 	count = ffs->eps_count;
-	while(count--) {
+	if (!epfile) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	while (count--) {
 		ep->ep->driver_data = ep;
 
 		ret = config_ep_by_speed(func->gadget, &func->function, ep->ep);
@@ -1965,6 +1970,7 @@ static int ffs_func_eps_enable(struct ff
 	}
 
 	wake_up_interruptible(&ffs->wait);
+done:
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 
 	return ret;


