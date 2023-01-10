Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766F06FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC0DC433D2;
	Tue, 10 Jan 2023 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375384;
	bh=sOwc8x8/9w8lQ5AceYz1z9e5A8bHZuetFSUpcTEDFzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IAMRFxeyATGI4n8zrv3Fusc4cmcJpI14W5sNgg1HDFb2BPiRgt/gHR1/O5/O2u4b
	 rzhAJKA2C5jIC07BifyEs2eV8C3K3H5FIjYWRoSBjC2yWglPBFzmMWQZm1O9dYlRDf
	 nWVE8ml7wX4SZ7NyIAtrmfJlWKV4q/jsKDjRg3co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: [PATCH 5.15 129/290] driver core: Fix bus_type.match() error handling in __driver_attach()
Date: Tue, 10 Jan 2023 19:03:41 +0100
Message-Id: <20230110180036.286423590@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 27c0d217340e47ec995557f61423ef415afba987 upstream.

When a driver registers with a bus, it will attempt to match with every
device on the bus through the __driver_attach() function. Currently, if
the bus_type.match() function encounters an error that is not
-EPROBE_DEFER, __driver_attach() will return a negative error code, which
causes the driver registration logic to stop trying to match with the
remaining devices on the bus.

This behavior is not correct; a failure while matching a driver to a
device does not mean that the driver won't be able to match and bind
with other devices on the bus. Update the logic in __driver_attach()
to reflect this.

Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
Cc: stable@vger.kernel.org
Cc: Saravana Kannan <saravanak@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Link: https://lore.kernel.org/r/20220921001414.4046492-1-isaacmanjarres@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1127,7 +1127,11 @@ static int __driver_attach(struct device
 		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
-		return ret;
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} /* ret > 0 means positive match */
 
 	if (driver_allows_async_probing(drv)) {


