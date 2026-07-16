Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F68243305A;
	Thu, 16 Jul 2026 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212106; cv=none; b=nfBrDjYgP6WQFCMd3Ukjc4I63eyS34JEEnPodPi0dOnshLrSPhIKnflAR7ajl1mOo9R/iqrJtmVu819gQH2C/vdyZlvTSd+9klfInu8wEsWwXLftCsSkQlaDraDGeeWKt1VoHQfmadcYl3+xJ17bvNkPtsmAgklJnxz+EIGNpPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212106; c=relaxed/simple;
	bh=JQUvwrlD92cIxp1RLDFC5Zd8rj/vY2CNshvrOgrW3SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiDJQo1UAiSsVio6uIvM42Xa1PSXIMasl7sUeP1C5B+R95mAKhzZ8jbMrkzrW3wVsv/zIAN97yS4p/BbOJbhRS4WaI06ha+HEiaMKOTft21Uer0my0XI8KZzSysaajRrfabJFlxfDCx9EK5KoB3PgwQgGVeiqX25KeX+eLlxQ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRY6rxsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRY6rxsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7361D1F000E9;
	Thu, 16 Jul 2026 14:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212105;
	bh=9hwUgL4MH5aI0PlpME7ps5MIcVh1ZwXU4te3jv3aZFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRY6rxsHc9OzrhvNFNMHHG+gGxbrTGQPUEdG5TgkKL+glRIMCyqHY9W8JBacMJHt8
	 o39r2n0AKpwx8tMpI6pTZJ5ov/Scu3M+AYu326NAFDN74RTCIraiv0lGM9+SnEgm7t
	 /Dx6jgx2Vek9u0pYw4+s8tMgJ/pjQ4wQYF+mRSLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 202/349] HID: hid-goodix-spi: validate report size to prevent stack buffer overflow
Date: Thu, 16 Jul 2026 15:32:16 +0200
Message-ID: <20260716133037.889879799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

commit db0a0768d09273aadadeb76730cd658d720333a4 upstream.

goodix_hid_set_raw_report() builds a protocol frame in a 128-byte stack
buffer (tmp_buf), writing an 11-12 byte header followed by the
caller-supplied report data.  The HID core caps report size at
HID_MAX_BUFFER_SIZE (16384) by default, while the driver does not set
hid_ll_driver.max_buffer_size and performs no bounds checking before
copying the payload:

    memcpy(tmp_buf + tx_len, buf, len);

A hidraw SET_REPORT ioctl with a report larger than ~116 bytes
overflows the stack buffer.

Add a size check after constructing the header, rejecting reports that
would exceed the buffer capacity.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 75e16c8ce283 ("HID: hid-goodix: Add Goodix HID-over-SPI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-goodix-spi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-goodix-spi.c
+++ b/drivers/hid/hid-goodix-spi.c
@@ -515,6 +515,9 @@ static int goodix_hid_set_raw_report(str
 	memcpy(tmp_buf + tx_len, args, args_len);
 	tx_len += args_len;
 
+	if (tx_len + len > sizeof(tmp_buf))
+		return -EINVAL;
+
 	memcpy(tmp_buf + tx_len, buf, len);
 	tx_len += len;
 


