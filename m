Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E46C57EDB2;
	Wed,  9 Sep 2026 14:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962852; cv=none; b=dlxfhgi++IbpG8gLiO4i7fM5ilaM3kkkWU7tBoBjDJMSKJ5vKPL8LN5mNJsBCEgCCJdyQOCXRLVBIpMNHYASAiT+OR6UzGcoQUJGnTf7+bH/3mtwjTMB3zrUoMhBX1zfWy57JTydQtuyTOjLqZlzw6+bF29NAYswuPWbqGug5tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962852; c=relaxed/simple;
	bh=o8PErX13f75WWO+hhQp/laLkWqXPe0NWS1/gUhnOx/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTGYQEvaFWNCsXINY79VtiMb3Nqkmxtpswhdvmsz2B5Hos5xqKApZMDmb/YiMhGMuMw2f7rnQJ5ZECifaRrSFAj4I5laxozW/vD9MR+sMwtq+IN7m6i2v0ZMYJmiy+YCD7op5bDPHnoE7UZYJDM3uTdVqVQLQFKIaq4cRLAJAHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKkm8Atn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKkm8Atn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541B71F00A3A;
	Wed,  9 Sep 2026 14:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962850;
	bh=Ez+vmLtTVTcFmps1F43ygas6uONK+vZdgNKyb+NkEeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKkm8AtnId4SQg2XuylnGlrVz107ZkU8Bm5pjAPtpB1ZRc9RNLI35ri+zSmLkEmk/
	 cNrutyJXwy+4dSCfWKsr6CYBjeYw8Enf/qoUuLuNuvltL1SwCXNuYcQCbEFrxKfAkc
	 CcjTg0Eihav6v8+iTwISsfBGZB6+iVmKbotbfCUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 393/556] media: s2255: check firmware size before reading trailing marker
Date: Wed,  9 Sep 2026 15:41:13 +0200
Message-ID: <20260909134244.482879645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2283,6 +2283,11 @@ static int s2255_probe(struct usb_interf
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


