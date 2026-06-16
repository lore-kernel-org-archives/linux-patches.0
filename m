Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAF43D5656;
	Tue, 16 Jun 2026 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633642; cv=none; b=R2TwngXwNY51ETh0+OCGHIuF3YMPeO/WXCEN8Nj+V8FTuK/dlvtm31vSck30A7mZq7mhLwlKlNP2Zdaosy+LflFj2ns4+jekehjY2j+qd6QADrNBvzuP9o6Uk5VS0mKxLy8lK9z2RL0Gf6O9IPZ3pLMj+tAEFDig9q8AeuSwkic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633642; c=relaxed/simple;
	bh=0irLk/tSY6dQuF1QnRwMp/hDAxr2vqh7R3HT91AyExU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdHXdF0JtP9e3KExOMWRIgHKAvAH3N7tupXnOG6IupvArV2IHMizMGFRtD8PeQJmIOI7+FWnF3CxokCgZvXHiriYx4ZyMIj+sLpmX3VgbiYMHnh3T/JAiNkWlqXgqawdCWVdFvkcFXw2WWc1h0eBCG23MqLISNdhVrEP0CI4skw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dM0PROcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dM0PROcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F85A1F000E9;
	Tue, 16 Jun 2026 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633641;
	bh=d3NQ2B9tt6MsttF+uduu335r8oA7Xjd1b+fnqJIO+S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dM0PROcx1NO5QB5/ygh/yM/YzBmnrlzq8P1bMy9vh9lAPJJwv/YZD1pb786oqXCB7
	 onHYW9VhbRyTMSFoM9D2BeQsf9hYOx6uYcgZm40sugUMRfgNQzyBVhLSMxpcf3AZJx
	 b0YuWLUqbJvpSzPSdaRGBLirZmZXXy+MKOygIzO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 116/411] USB: serial: belkin_sa: validate interrupt status length
Date: Tue, 16 Jun 2026 20:25:54 +0530
Message-ID: <20260616145106.469684611@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
 


