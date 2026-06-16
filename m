Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA903CFF55;
	Tue, 16 Jun 2026 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635684; cv=none; b=gxwYbr5NxqcCfWxVwOmbEIw1zoJlOF9yKH1/fgkzT0ST+2u6550nxs7jmgfkr+Xs0vLJCVOeVVetvERZb6nWsbV3jv7lgHo7U6QWk4TPLQ7lUE/UmWeCxyJ+AhLVfbICh0HXrahFqpjzdeKuOt2/XEIJea73sET89u/hWhiRhMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635684; c=relaxed/simple;
	bh=K7kGBaJK7uJA8leAHjOjz5q1UAabtey47IE5pMDnoa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElvoSS2Ctv/ohA/q7tX43166sAO2RAcrAZEssbAAkIRZ8j+AeRDBI2KWl1l6VVhJ0IE1Aqq/inMPTHSw8kYm6T6mtLTHbCj4Ud/6HZbootj2NOYO0D43vX8I9niD9yPG5S3A7Auna2d6/8dSa8u+vjSBjfYAPBaMoGTRwTwMBFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snRpgoIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snRpgoIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554641F000E9;
	Tue, 16 Jun 2026 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635683;
	bh=EOpsBVjeyI6cmx5YRuPwR7gQBnHpAC9nF7DmfMoNkFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snRpgoIWcqbXcC1gXIiljCP0yilofwLP7MvSgVDwC4nAWw8ehgHOwpYx9mrUP8XEH
	 IOmpmEUzKntPRv5OY/OIl2pSfe/+71NEGgldJpJ+ykXg9JRMA5na2TofgqAr1nBhp4
	 8CyHhkNfBSo08sae4vpyaGp6Q6Cf7PtK3O1xZ44k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 5.10 096/342] usb: usbtmc: reject interrupt endpoints with small wMaxPacketSize
Date: Tue, 16 Jun 2026 20:26:32 +0530
Message-ID: <20260616145052.702924522@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2402,6 +2402,12 @@ static int usbtmc_probe(struct usb_inter
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


