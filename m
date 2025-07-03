Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244912F19AD;
	Thu,  3 Jul 2025 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555604; cv=none; b=p9rYlnC2Lwu+MY8u+pGH16b2NM7XWZB7Zdk7GSUDI4lkH+imPxvX2GjlS6CWxiV9jgfyIcTgzHf68qzX9ZlM4YaItgutcB4zAt3M69AJScPVg8qiQ4f68gaW7Avj5o8hoG8wB6kLPiqXxT1GJt93Fjx88sCtpksfWYvOcu9Z2mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555604; c=relaxed/simple;
	bh=omI2RQz+7ecdotxcaXvS6P93SU3cC8yUyRTuiHe1RtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2QCa1VuvpqQ7gQcpOhFhFMVDC+HGpmy+tmeiYb9OGoX1nENPnlXGF4w0kklA8gvNUWgpPkJUZ3ESEIRI9gD6U4DWplv7SD5aKWxqBVxgxesRWMWrW1o1/tZlU/1q5MgewZZb0kMhgdmJpcdMN0YMaZuO19XG4OLAJo1ulQoiAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yymrhi78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yymrhi78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10BCC4CEED;
	Thu,  3 Jul 2025 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555604;
	bh=omI2RQz+7ecdotxcaXvS6P93SU3cC8yUyRTuiHe1RtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yymrhi78sibJwVygrSPUv36jdFZ/05JA+WatJz/Z4d1WukmbdPGAQlJkD0IhlHO1n
	 /Ut3yXkPbHlttutendXuQkqgF3pubqi9rw1bx9147KsT93oJ85TKEEq6K2szW+cR9i
	 AgC2QvcC8GPY5Fw5IApmHkdXY+ITgaXbd3suN2kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/139] usb: Add checks for snprintf() calls in usb_alloc_dev()
Date: Thu,  3 Jul 2025 16:41:39 +0200
Message-ID: <20250703143942.592733626@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 82fe5107fa3d21d6c3fba091c9dbc50495588630 ]

When creating a device path in the driver the snprintf() takes
up to 16 characters long argument along with the additional up to
12 characters for the signed integer (as it can't see the actual limits)
and tries to pack this into 16 bytes array. GCC complains about that
when build with `make W=1`:

  drivers/usb/core/usb.c:705:25: note: ‘snprintf’ output between 3 and 28 bytes into a destination of size 16

Since everything works until now, let's just check for the potential
buffer overflow and bail out. It is most likely a never happen situation,
but at least it makes GCC happy.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250321164949.423957-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/usb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 2a938cf47ccd6..da6d5e5f79e7a 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -695,15 +695,16 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 		device_set_of_node_from_dev(&dev->dev, bus->sysdev);
 		dev_set_name(&dev->dev, "usb%d", bus->busnum);
 	} else {
+		int n;
+
 		/* match any labeling on the hubs; it's one-based */
 		if (parent->devpath[0] == '0') {
-			snprintf(dev->devpath, sizeof dev->devpath,
-				"%d", port1);
+			n = snprintf(dev->devpath, sizeof(dev->devpath), "%d", port1);
 			/* Root ports are not counted in route string */
 			dev->route = 0;
 		} else {
-			snprintf(dev->devpath, sizeof dev->devpath,
-				"%s.%d", parent->devpath, port1);
+			n = snprintf(dev->devpath, sizeof(dev->devpath), "%s.%d",
+				     parent->devpath, port1);
 			/* Route string assumes hubs have less than 16 ports */
 			if (port1 < 15)
 				dev->route = parent->route +
@@ -712,6 +713,11 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 				dev->route = parent->route +
 					(15 << ((parent->level - 1)*4));
 		}
+		if (n >= sizeof(dev->devpath)) {
+			usb_put_hcd(bus_to_hcd(bus));
+			usb_put_dev(dev);
+			return NULL;
+		}
 
 		dev->dev.parent = &parent->dev;
 		dev_set_name(&dev->dev, "%d-%s", bus->busnum, dev->devpath);
-- 
2.39.5



