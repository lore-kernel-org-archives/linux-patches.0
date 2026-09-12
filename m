Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFE92D0C94;
	Sat, 12 Sep 2026 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237766; cv=none; b=c2Q02uMNE7pRUWz3/nDXluKhvbjnj0NuuH7egarRT4u6UeTEXB+xMtL6A3uTdVF3aGhrt+XTM9+DMVLlnOcSE0tTpK/QKKcYQVbbrMIkBgr9FHAxTJ6rCXXeLTJyZccUZpYCFkr2DTD0XGA3fdRoh7vkLThqvPwywvpP/pgp0CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237766; c=relaxed/simple;
	bh=0UvtiX1B/h3nltfecBvytL5LP4xB4mnKyIl31Qbp5Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5LHa50gAfpC/7XLBZCuRH01mk1SS2kGSoFkd0C4DTaC885xXCZxuCO2xt+llx40V+QG7shwNJIz/omX0rSmsv2EujGa+hEM7cHaR82/mvdQ1zyycK/aQeF631MaFI/Nusa9H9X/v7ZxX6CcmVWbBcr7nYH8Pt/xF0gjJG41vu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp2sti91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp2sti91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA341F000FF;
	Sat, 12 Sep 2026 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237765;
	bh=fxPEdciu2t8rHj/YrKkSldAKInHNlnqwKAQ3GhBYhNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mp2sti913Myxv1/b3uR7uUjn1gcGRV/lw05WI1Fh83NNtw85PO7V/AN+gtiku8q1Y
	 OxAko0LbOMp9t5r96PG5FGCvqpeCoQO4reMDsp4s0vWVOr9Ezz337i0vUU+rDgDDdo
	 rPYhJbQDRYAQtzpUoZeyxMWdJ0U5GgSBMlThS6fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 325/935] media: s2255: check firmware size before reading trailing marker
Date: Sat, 12 Sep 2026 08:55:55 +0200
Message-ID: <20260912065534.258176183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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


