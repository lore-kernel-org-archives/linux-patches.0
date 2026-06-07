Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA78F4071DD;
	Sun,  7 Jun 2026 10:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829449; cv=none; b=V01sG9TK58xRv/Wo362mPb8Yun3z+yOVbzjChj81GVpbdCineYl795PzuZ+tnFg6pwL/xrnu4fpMwRlq9WLDqdY36kKBDmWTTGqLF69l6+OJDpXgkMSgiFQFuLmQRXmFP/4EdpjBTDQHJji5m95DWrFDiPxdlkpf0XXPF4qcyDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829449; c=relaxed/simple;
	bh=73bGdKsYW6bAH716Hg4brE63MeU7jRxuGULAryZuLqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AU3qENFsHdr+dCOysnLDzVjPy+2HKxGErQCaKU2j/qiQ0+IZQRlbCaY9MDQ7wl6EJhrDylR766af3Ersgq55otYI0GaC1PUHxyVDI3prqrMZS+nfWilIUnNiPHnxXxFVUMi8CvdABqHg6viBfHcG5hUypWTtr0DUbxe2tQnfmdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYxMBFXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYxMBFXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE23A1F00893;
	Sun,  7 Jun 2026 10:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829446;
	bh=Jym0Zq/wYDIMn5dZmtTJhmL209ejBwlRdfM4vO4N+FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYxMBFXcJQ1DdTdyx0w1Aw/O6BDbNXboWeRNf7LzKbdelIBqg2FzPPtPb5yqqXxjd
	 YxbgiFWzC/KV+7wJqzDGOriQZufYhN4jtb6aSTrj+VW6FIx47e+tIvRRjcQ9/pBFBc
	 b114kqWi0HxqZWx4Tgm7Q/0+3tIHm4QcXcV3UoT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 225/307] USB: serial: belkin_sa: validate interrupt status length
Date: Sun,  7 Jun 2026 12:00:22 +0200
Message-ID: <20260607095735.970298498@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

commit 4ce058df2ee02cc2a0f0fd5cd64ce6f1482a0b65 upstream.

The Belkin interrupt callback treats interrupt data as a four-byte
status report and reads LSR/MSR fields at offsets 2 and 3. The
interrupt-in buffer length is derived from endpoint wMaxPacketSize, and
short interrupt transfers may complete successfully with a smaller
actual_length.

Check the completed interrupt packet length before parsing status
fields so short interrupt endpoints and short successful packets are
ignored instead of causing out-of-bounds or stale status-byte reads.

KASAN report as below:

BUG: KASAN: slab-out-of-bounds in belkin_sa_read_int_callback()
Read of size 1
Call trace:
  belkin_sa_read_int_callback() (drivers/usb/serial/belkin_sa.c:202)
  __usb_hcd_giveback_urb() (drivers/usb/core/hcd.c:1630)
  dummy_timer() (?:?)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/belkin_sa.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -194,6 +194,9 @@ static void belkin_sa_read_int_callback(
 
 	usb_serial_debug_data(&port->dev, __func__, urb->actual_length, data);
 
+	if (urb->actual_length < BELKIN_SA_MSR_INDEX + 1)
+		goto exit;
+
 	/* Handle known interrupt data */
 	/* ignore data[0] and data[1] */
 


