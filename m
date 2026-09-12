Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D5D47A0CD;
	Sat, 12 Sep 2026 11:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213862; cv=none; b=oZY2+AoG4aHIDevI0NusrWYTSTvtYWl36glCEhM8P2pRwaFXFScsHAk4MXSz2HEMY63h+zcWfZi8RXDdXV2nsIJ9xls0ieRnnEYsJtxlzeL2voxevRIIpTg0DyYA0p57Tc2h35yxN7cCNbQQdABRqvbxok6eIc6W5ZMQ780WDwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213862; c=relaxed/simple;
	bh=bxdhkoDDf+yVK7p5nLetzwqnloe8m9kMJHvCbGPXScE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baf07Ej3xYNS0eX4nkswu5NCPAtRoKqcPq7VA4pQo+s5vtkES8ZQUvWmCswauuLSfu5rxpNsgSSuUD1DwDmc/hfs6sHgUL+Y0QOFLQ5k9GhYWxGXbwxgYsPsOxgEfipCIKBsE47ORobVSdj57xkzg2AdQIVfssA9AgFcozeH4Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MArixRre; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MArixRre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919DF1F000FF;
	Sat, 12 Sep 2026 11:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213860;
	bh=Ti90xDuK7jvtL/TLi5Rx15Y3VCChH0fjrTrQ/3gjlMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MArixRrerXO7KMoPgoK8PnBvpC7G0iI8bzvWZcftE/IKAc8ZqKrP2iWZkTkUswsJX
	 CLuzzMyLSJVvtLXSBTA10GLH5XsU1fcxIizZqRHeFiQYIobmg3l9VHrnGw0PFDegeO
	 PkPQVDid5em6PbAMdLDm5b4sQ+o+GCeXpJMBb7jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0208/1376] media: s2255: check firmware size before reading trailing marker
Date: Sat, 12 Sep 2026 08:43:54 +0200
Message-ID: <20260912065612.185316062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2289,6 +2289,11 @@ static int s2255_probe(struct usb_interf
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


