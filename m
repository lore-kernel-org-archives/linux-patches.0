Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D833CEBBD;
	Tue, 16 Jun 2026 18:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633621; cv=none; b=PYdYCQIReRq1CaWY27sHY3zbuMPaRCYY/TUBfcupGteV+RHl9y30dF7Ieb09YlS5MPtAgipLoAkRWfoXdO4KdXOv1XnMEoULqlTe4YBpdjcXP09msGGIanHWSb6ehzxRdZVD61RdrhqXNvU3X+Qw3LWMlU6GS3p7luB6GfK2hfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633621; c=relaxed/simple;
	bh=LK112GgdR2QA0rt6oiag1CRCL97tf2uCzWzCMshTkas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJPdpFlxosz5vtvOuerSrJhNk2g9kp0CSn1WbfGqoz34wqpI/K4DR70/47BCO1vSrIdSTeaxBKPPOhLxQ0AFHQtEHvH+H//kLWxVg5qItIZwJyR4nbvJFyiKuE68nnjw0ylOhU9X7YK/fEkO4P5tQVfJGhtQ/gMOGg7s6m0WSKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIQt6LHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIQt6LHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5AE1F000E9;
	Tue, 16 Jun 2026 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633620;
	bh=O4KjTW9793UG7U/h6MnqPBhyuwfumXuxvLS9d1ih3I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIQt6LHjlMoev9UeF52QL8iVIGkGnVxmbE4aD7fyc+chGkxJv5U21hUjzXeW9G9mw
	 h2wjHbDUWKfUcgV+et09RQlki7e3OONCvoCBrxpiXiMwEyUNcCCMPIB6QLcrqSSUuo
	 g37rs2LXDNE2HEyaOhCCNymqKJ2AnzqlOOf1FT6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 5.15 113/411] usb: usbtmc: reject interrupt endpoints with small wMaxPacketSize
Date: Tue, 16 Jun 2026 20:25:51 +0530
Message-ID: <20260616145106.298816456@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heitor Alves de Siqueira <halves@igalia.com>

commit 121d2f682ba912b1427cddca7cf84840f41cc620 upstream.

The USB488 subclass specification requires interrupt wMaxPacketSize to
be 0x02, unless the device sends vendor-specific notifications.
Endpoints that advertise less than 2 bytes for wMaxPacketSize are
unlikely to work with the current driver, as URBs will not have enough
space for interrupt headers. Considering that any notification URBs will
be ignored by the driver, reject these endpoints early during probe.

Fixes: 041370cce889 ("USB: usbtmc: refactor endpoint retrieval")
Cc: stable <stable@kernel.org>
Suggested-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260505-usbtmc-iin-size-v3-2-a36113f62db7@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2444,6 +2444,12 @@ static int usbtmc_probe(struct usb_inter
 		data->iin_ep = int_in->bEndpointAddress;
 		data->iin_wMaxPacketSize = usb_endpoint_maxp(int_in);
 		data->iin_interval = int_in->bInterval;
+		/* wMaxPacketSize should be 0x02 or more as per USB488 Table 22 */
+		if (iface_desc->desc.bInterfaceProtocol == 1 &&
+		    data->iin_wMaxPacketSize < 2) {
+			retcode = -EINVAL;
+			goto err_put;
+		}
 		dev_dbg(&intf->dev, "Found Int in endpoint at %u\n",
 				data->iin_ep);
 	}


