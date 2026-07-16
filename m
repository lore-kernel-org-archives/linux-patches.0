Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4F54248D7;
	Thu, 16 Jul 2026 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210998; cv=none; b=DuORdTgW9EpAAY2FJFESGQDYzK3EkLSqLA8G5Vw1BRjxP9jid2XVpYkddfCs6ZDIORJbkiXTqEmJ+uSKQUXylNAjc7+F1WUqiUQmlBNyVL+gwaY38lbqqw4Z144O8m80rZ7LzcDK9CjGth7t9qGsPCSNogYZV9StGJNNmLlrmik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210998; c=relaxed/simple;
	bh=EpedEA88gPW4RPnWK8T81GaYLp9+3RJX/0Wgt2XNd14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDvJl4F2GUfqvKKLymOWt9X9hZpOyyWqnB7ZaV+QaOIEBeJZcj/EvHebR6ke2tsk9913BRelaicyx04dgHII6VY9W1rCzZ++13vdLwinFxLihI6iniHx4VZ2E5eL98u/X18CZAwRpVb92LFNcNqodgSJxf1GO0Ee5ACAc+Lzq1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJl7XVF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJl7XVF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F3B1F00A3D;
	Thu, 16 Jul 2026 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210996;
	bh=uPWQyGG+E5OUDwYqWyT/x7g5JINHpS3zNl2dP6WdeXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJl7XVF3ZVcjUuVr44mHcOIIBngexaKoH5FM4orogx0zX1j4bChK+VlGwNjNrKP9W
	 zU8KK+fMbaKb2T6zENuQOBYjCJwVeZOISi8hEo6iv3r/wKdrFqFxnIclBcE1SLg7Mn
	 NnPID4w9N91O44jq6YvNydr1peAIBQRtUNV10VXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 259/480] HID: hid-goodix-spi: validate report size to prevent stack buffer overflow
Date: Thu, 16 Jul 2026 15:30:06 +0200
Message-ID: <20260716133050.419199048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -520,6 +520,9 @@ static int goodix_hid_set_raw_report(str
 	memcpy(tmp_buf + tx_len, args, args_len);
 	tx_len += args_len;
 
+	if (tx_len + len > sizeof(tmp_buf))
+		return -EINVAL;
+
 	memcpy(tmp_buf + tx_len, buf, len);
 	tx_len += len;
 


