Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759D63382CB;
	Sat, 12 Sep 2026 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242102; cv=none; b=aVr0aOHGtd87tTVcFz1L7VeczkhhQSdliH15hHPhfWxFkT5EPiyfDP2G5L8LIkWaQ1Lx4BtxvPAcY+ScbaHqZgHdn4hcwd8L87Q+fkMBye7nrJZeNocZP5dog9ZsBvP9NXQOeNYQJD5Bz8R8qPHZO/cmu1w+xye0sB08fCpzJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242102; c=relaxed/simple;
	bh=XosRHBBJWAf7QxGyOFO4g0Us+hoRKhpcI+kQH/ssb5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP0XMTKzqUkjWiYG5E07sE4T1ljPpU/DtqWhCpntHyGVJLc7DSHu5zl46AoAriXVYYxRnZke34gjxYYgHV4Jd8Pk6ED44bpM98cUKo9zrBJOyLTRwdMjItXT1ZxNgFr6IJG57oYBhN7TS77Ud86RyZzSH3XUhahSSLMe3xmi1cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15WT3kTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15WT3kTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66FC1F000FF;
	Sat, 12 Sep 2026 19:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242101;
	bh=gX1EVuQZ4LJgH4+fWS3cSCo7JHovZ3dXOfv4uI5sTiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15WT3kTnW2wzTj2Oh3uVZSbpBh6YajdnGQexX/baJDFsgtbpRXsmOEfxt+tHYopD0
	 Bx5jNtUYshMZCe7RDmD2G/Hu3xXu2KLcboJhz57gMx88Nt+D5enaRpNIx4VALFF2iL
	 yi2kt1FGUo7j4MUNqV7uSOoHG1kT0Wu8NzYRC/cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 284/798] media: s2255: check firmware size before reading trailing marker
Date: Sat, 12 Sep 2026 08:58:32 +0200
Message-ID: <20260912065523.671697306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
@@ -2290,6 +2290,11 @@ static int s2255_probe(struct usb_interf
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


