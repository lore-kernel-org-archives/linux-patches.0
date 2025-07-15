Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C3C2E3382;
	Tue, 15 Jul 2025 13:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586367; cv=none; b=D0J7umI3mS5YP5B5l0d9yAaRR0rvPRAGJFs3MRC1niK05vZqDevLsp2NY/uG0hfQf1q4+Ls767NJ6BObRnpcP+Pc3AF3YM+IX6SrNxCsI++m85AJIUOGDu0zr7yWjSIE8sIoAJM/JRYLxF5SSnObInhs7MVFEnxcA/eRRknTdKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586367; c=relaxed/simple;
	bh=4MlSWjh7JitSy1QXqA+7y0AVOQwHuykeyHfV8CdDBog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+YZ2UszVToJTM3PQHNdvmSm25Kw70eHz06pM8wn+J5NFraoSkkg5t2FW95kAL0jM9tRq8w6AsDfqMl5EuAAxJlrrXc/GnCg3tbr4yt7Q6D2MUh3/8Be/BQ1KHSOp/5pmWJzyYCmOTT9lICma//I46NVZX0vOFJSxkdOZXAvHwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=As5vGvG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="As5vGvG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A85C4CEF1;
	Tue, 15 Jul 2025 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586367;
	bh=4MlSWjh7JitSy1QXqA+7y0AVOQwHuykeyHfV8CdDBog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=As5vGvG3C5R55Xym3GPM5pvthLvzVSEJBg83m7caB7QyAn6VcZiNrL7kXUFdFPssQ
	 Nof/X83RT4DNaSOpT+V7MlkhZcplASr3T/61y34BLFT8yHG74EKyv17OLwFrTgXe5T
	 uPN/YIh9iz3jWeg5PwzyLhnrfRgjzdMMsoCZbMlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/148] usb: Add checks for snprintf() calls in usb_alloc_dev()
Date: Tue, 15 Jul 2025 15:12:11 +0200
Message-ID: <20250715130800.676632290@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 502d911f71fa6..571ab8e0c7590 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -717,15 +717,16 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 		dev_set_name(&dev->dev, "usb%d", bus->busnum);
 		root_hub = 1;
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
@@ -734,6 +735,11 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
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



