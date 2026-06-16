Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1323C47AF5D;
	Tue, 16 Jun 2026 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631736; cv=none; b=SYMHGFx16jvKIDCZUdjprn0A+Jw27laG2ZHDDD58BYi8Di3QcvhW2yp+cRuhjWkbHRY5wL7XMaHuXsZdFgTPGZ5+DS1i7t06HQhJFnBKEpVEoKMd8JayQ1CF0jPmKgJvruvu5pZV9E3a5gEgz1SnDc9nxCR6TMp6CZBqPnqXHHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631736; c=relaxed/simple;
	bh=FxNaEmgaB01aOVDM9sVE8VPr5ociImJO14RzmmzQ4sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUlG4NdfIEUIuShjKhqrkQ1t2S2GkdAiGJEjQSLINAe/vc8q0wIcDK81Wx8czQL8xM3JyUZDrgIWrmJAdXKOgMai6tGxEL1/HQVIZZ53sST1rJEdXE6LO/OvxOSfrtheHh/UnHAEgJKnOGbnOuhDIO0v32xLtm3A3K5z5s0fun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHr+9LCw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHr+9LCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC151F000E9;
	Tue, 16 Jun 2026 17:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631731;
	bh=P3F34wZzrBg5XYTuPtBYxf/5fa14pDsXQ72IEeNDzWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHr+9LCwmtNBDcDtZzSa9FCUPtuXNvpbpbAGELefgYbZCt7iamt7oHRvfeZ4VsSvl
	 A1w7puWUXe8Z/bheuesdMgcxnw8bPsiYjD0IGiIdvomlD7VYzZxvpAUwN2XGuLkx5G
	 Foy7VyjavwIfRZALdmGHGLbmX9U8al+IB5PY/0Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Korwel <adriank20047@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 275/522] USB: serial: io_ti: fix heap overflow in build_i2c_fw_hdr()
Date: Tue, 16 Jun 2026 20:27:02 +0530
Message-ID: <20260616145138.828752869@linuxfoundation.org>
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

From: Adrian Korwel <adriank20047@gmail.com>

commit 0fd2b00b2d3d05e3eaa13342b3dfb0fa85c226ae upstream.

build_i2c_fw_hdr() allocates a fixed-size buffer of
(16*1024 - 512) + sizeof(struct ti_i2c_firmware_rec) bytes, then
copies le16_to_cpu(img_header->Length) bytes into it without
validating that Length fits within the available space after the
firmware record header.

img_header->Length is a __le16 from the firmware file and can be
up to 65535. check_fw_sanity() validates the total firmware size
but not img_header->Length specifically.

Fix by rejecting images where img_header->Length exceeds the
available destination space.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Korwel <adriank20047@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_ti.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -844,6 +844,11 @@ static int build_i2c_fw_hdr(u8 *header,
 	/* Pointer to fw_down memory image */
 	img_header = (struct ti_i2c_image_header *)&fw->data[4];
 
+	if (le16_to_cpu(img_header->Length) >
+			buffer_size - sizeof(struct ti_i2c_firmware_rec)) {
+		kfree(buffer);
+		return -EINVAL;
+	}
 	memcpy(buffer + sizeof(struct ti_i2c_firmware_rec),
 		&fw->data[4 + sizeof(struct ti_i2c_image_header)],
 		le16_to_cpu(img_header->Length));


