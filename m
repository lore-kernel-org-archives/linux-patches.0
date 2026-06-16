Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE8632ED55;
	Tue, 16 Jun 2026 17:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631058; cv=none; b=mZmD7cbfy295JxWeKBgWndJIJVwGjJqZ6TSG8CGB8WFFAneUMb529+/L8y90QdCZQ+eGriaIebHXyGe9iNsDhwNWwNC7ksZ+pxo2LrmtH8cThTgTHBNRe9FoEeJeeRkWjKsri/XSQMGVHUGCvHNycXzginJkr7m6BQqYhWKtWPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631058; c=relaxed/simple;
	bh=5OcsJer5Gu1VFFyXovyh0ZcEkjKK/Q89Vm5+4eMvq2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyUN7o1PsV4C9OPGOGxbmVLWgx70WkHNOmX+XZh9faT3RxONFtGEcUajcA8wrLPZG31vzw1uBJnRI/iYkbbRahFu1RcU5wZlNIjB1Rfwjdq4keen6jl0goWWH/K0iTQAnkOgNufr/01MSecIDTJO2jcREUi20A5K/0iiFA/JA30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBwT30Vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBwT30Vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A11C1F000E9;
	Tue, 16 Jun 2026 17:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631057;
	bh=DocT8x8Egm016aIWw1FyampuUrgMuipxHllGo4aV+aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBwT30Vc1VJchWdBiM6tboKY1RggydUSc6Pl8IZTdbHxfQNt1Q06F2TcDufG1qZEk
	 XJnHv07uqDRa77IYDORQ1CQqh4UycVh1wtXc7KFDUPeLuFrbz9D0eKaN4Al9ODVfpS
	 sL1beDNJUJXdQZveqcCyZUVxcIm3HrB0AYC0Lz/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.1 149/522] usb: usbtmc: reject interrupt endpoints with small wMaxPacketSize
Date: Tue, 16 Jun 2026 20:24:56 +0530
Message-ID: <20260616145133.057922638@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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


