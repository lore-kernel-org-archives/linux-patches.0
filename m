Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDD52DBF75;
	Sat, 12 Sep 2026 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228609; cv=none; b=Qd+arbeLCUqB71aq0cRu7NJapgz6w2/RFV8qHDsB2MgJhsaTPCqvSdU6PfoQNe4C+9QWDuV9W1UYOFqHTAyfVu0GXUY3HpFMtj0IP2djtXIXmHGH9lPuhTx6sz7pvdPT8rn5pGwKB2U2/3UADC6G5buWPbc4arO+QIicXL5u31g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228609; c=relaxed/simple;
	bh=fCE7gIztrYuPpP3X2FoS1DheOEPJPZyFlHZUc+DAqvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9sL8sJDz1DOzte9bZjdh/bOlKg4kiDesPhG4NU0jijwsazZkqo5jKLWcnlDCTpP8KpzwFY6/W50eKyUvXG30TtOmL0K+KTVx/TBxk6g30y5ZsHaYoH9bxLyDZHI/thY9Fh2UazJm8S11raH7bs35I9YZKDvwx+4FT4Qps1arnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVLSMbRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVLSMbRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFF61F000FF;
	Sat, 12 Sep 2026 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228608;
	bh=qJv5ohnFZQkl5rT14B/Wp7C2knfvBNP0XCitW99ur9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVLSMbRKJbMGC0eYhf6P7C/IBoCokKAfyMHkKBANPF9nYBo45AtJR469rN7SGOrcV
	 Apy9Enl65nZE/jwFaZvGgBNuim1164Bw0AjZEmIetb5hEMza7tbTirOftztObC7Zo6
	 vIO+bVPM5mKfoND9BfbkhLDZ64MS80x53Soe1890=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0378/1191] media: s2255: check firmware size before reading trailing marker
Date: Sat, 12 Sep 2026 08:51:46 +0200
Message-ID: <20260912065556.724185981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -2288,6 +2288,11 @@ static int s2255_probe(struct usb_interf
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


