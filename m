Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72C2568FDA;
	Wed,  9 Sep 2026 14:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964109; cv=none; b=bJnS/KjgqxV4EIab3qnBvWjSKe8y5aj9dsiPmgi4dPuFkUXYYVeuPfkjU75dh71CYQDAUDwHxOFpagNHggcNiez8lPi9URVc98ACxwEQ5GSgP54vwCS8gEQbFw/H/3zvHJbGieW99SdQ5ayxMIX532IIosA+67iqKUqPTmmSgsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964109; c=relaxed/simple;
	bh=R4W4J2dDA6s+a7XV78HnzMMxwF3tGE1RXE8aW8LlmVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEn4bqgFIxtpk7kxrBuJSaBt4ZMaV6TeAx+pksZf0RYJsSJNyFokTqZmR1z7hkRi2nHT9t2uAaWKb0DwffD8SzpPxmNdy2RvEs6y0sJrAeYK3bAH6PxVrdGQalBt9QVhc0oT1x1eEfiUOgXYuNX4wQXIHKWtm0XTUflhARvJCxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMM6kD8N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMM6kD8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9F41F00A3A;
	Wed,  9 Sep 2026 14:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964107;
	bh=Ld+d+5v733rLmHEDmxxmH/05FwdiZdcHXTWLbsOkC/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMM6kD8NorXUT/Y73OzuaUBYO2WvL1cu7B8BoAHzlysSF8bLN6R+08XRgV/YohijC
	 7XRu3Z9X1hBNtZtadmHhE3MPXMPmKejosAy8CpjnSFscumyP2dkK5JxajRqBBNEt0D
	 BWFBMjSw2RBc2Wrgcw3KdNscMQw2bIvbNxairdLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 308/583] media: s2255: check firmware size before reading trailing marker
Date: Wed,  9 Sep 2026 15:39:53 +0200
Message-ID: <20260909134248.681454465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Huang <huanglei@kylinos.cn>

commit 330f2936ab768c7215322a476f033143e8891d28 upstream.

s2255_probe() reads a 4-byte marker and version from the last 8 bytes
of the firmware blob (fw->data[fw_size - 8] and [fw_size - 4]). If the
firmware file is shorter than 8 bytes, fw_size - 8 underflows and the
access reads out of bounds. Validate the firmware size before indexing.

Fixes: 14d962602c8b ("V4L/DVB (8752): s2255drv: firmware improvement patch")
Cc: stable@vger.kernel.org
Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/s2255/s2255drv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2287,6 +2287,11 @@ static int s2255_probe(struct usb_interf
 	}
 	/* check the firmware is valid */
 	fw_size = dev->fw_data->fw->size;
+	if (fw_size < 8) {
+		dev_err(&interface->dev, "Firmware invalid: too small.\n");
+		retval = -ENODEV;
+		goto errorFWMARKER;
+	}
 	pdata = (__le32 *) &dev->fw_data->fw->data[fw_size - 8];
 
 	if (*pdata != S2255_FW_MARKER) {


