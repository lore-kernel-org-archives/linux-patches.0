Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D12814A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5PNt/wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194CFC433C8;
	Mon, 23 Oct 2023 11:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059716;
	bh=zHlveqMFY3ASo9XyzXYO/IfV2A6BEWPx8yA9TMv2wt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5PNt/wrR0+BytJ57qGanoRDPbbdlNxDhi8rAX/ZYjgZSwAiLXGCO0IbuXxpYf/jm
	 hccu5DjL0dPd6q6kaZW7T3LWn78m4EeqmWXN1lkNnDZ0NmnN/OPzQ8Y3mkPDoijNfi
	 bls30KnX+YpjNgpZZifWe+/PGNaLP/tvQPqP5h+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>,
	Jose Javier Rodriguez Barbarin <JoseJavier.Rodriguez@duagon.com>
Subject: [PATCH 4.19 28/98] mcb: remove is_added flag from mcb_device struct
Date: Mon, 23 Oct 2023 12:56:17 +0200
Message-ID: <20231023104814.578935044@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>

commit 0f28ada1fbf0054557cddcdb93ad17f767105208 upstream.

When calling mcb_bus_add_devices(), both mcb devices and the mcb
bus will attempt to attach a device to a driver because they share
the same bus_type. This causes an issue when trying to cast the
container of the device to mcb_device struct using to_mcb_device(),
leading to a wrong cast when the mcb_bus is added. A crash occurs
when freing the ida resources as the bus numbering of mcb_bus gets
confused with the is_added flag on the mcb_device struct.

The only reason for this cast was to keep an is_added flag on the
mcb_device struct that does not seem necessary. The function
device_attach() handles already bound devices and the mcb subsystem
does nothing special with this is_added flag so remove it completely.

Fixes: 18d288198099 ("mcb: Correctly initialize the bus's device")
Cc: stable <stable@kernel.org>
Signed-off-by: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Co-developed-by: Jose Javier Rodriguez Barbarin <JoseJavier.Rodriguez@duagon.com>
Signed-off-by: Jose Javier Rodriguez Barbarin <JoseJavier.Rodriguez@duagon.com>
Link: https://lore.kernel.org/r/20230906114901.63174-2-JoseJavier.Rodriguez@duagon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-core.c  |   10 +++-------
 drivers/mcb/mcb-parse.c |    2 --
 include/linux/mcb.h     |    1 -
 3 files changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -392,17 +392,13 @@ EXPORT_SYMBOL_GPL(mcb_free_dev);
 
 static int __mcb_bus_add_devices(struct device *dev, void *data)
 {
-	struct mcb_device *mdev = to_mcb_device(dev);
 	int retval;
 
-	if (mdev->is_added)
-		return 0;
-
 	retval = device_attach(dev);
-	if (retval < 0)
+	if (retval < 0) {
 		dev_err(dev, "Error adding device (%d)\n", retval);
-
-	mdev->is_added = true;
+		return retval;
+	}
 
 	return 0;
 }
--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -98,8 +98,6 @@ static int chameleon_parse_gdd(struct mc
 	mdev->mem.end = mdev->mem.start + size - 1;
 	mdev->mem.flags = IORESOURCE_MEM;
 
-	mdev->is_added = false;
-
 	ret = mcb_device_register(bus, mdev);
 	if (ret < 0)
 		goto err;
--- a/include/linux/mcb.h
+++ b/include/linux/mcb.h
@@ -66,7 +66,6 @@ static inline struct mcb_bus *to_mcb_bus
 struct mcb_device {
 	struct device dev;
 	struct mcb_bus *bus;
-	bool is_added;
 	struct mcb_driver *driver;
 	u16 id;
 	int inst;


