Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9527834104B;
	Sat, 30 May 2026 17:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160630; cv=none; b=aITxo3fS2jgakfgQuz/fvfSS+pkLuulf+GFkxMfhlAbBDaLccufr0P77GTQ4txSJyBqVPWLYaTAuRDT8nzbpXTKGhQvYeR5LqJgyop+SvvZpaahiQWya+zWeJ9aSTGVLQwL/2/4kiCieI41ky4Rl1jeYNYbcgHy4iY/VxslBbYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160630; c=relaxed/simple;
	bh=kUduNelLNLaVErVoG/kjQjj65YSjDpQawoCL2hVOnAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECtSzTFUhVCYMSC8cEFUuZyI16S5nPBpPhfsA+FPXYFK0OIOpU5UWBpkFdasnAgSxPXTVzsYiDR8D738VS1q8wGaI42e4dBdlAekCHW3/XzSvr3GeppMuFdr4R/hVpWwiLf+czk6FqZX7xsAePDpEl8erwQZoe+zl4C7hqdF2x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuDxcV82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuDxcV82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEDA1F00893;
	Sat, 30 May 2026 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160629;
	bh=xB3Osb8xCKKfCwRmg3EWIdIjt+vr0GAjOFxjaoK6o5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuDxcV82U2I9KYmS0Bu3HR7zVHPskAokNKqb2HhlWlBZaVmLOT69aQE3fRB8C7uBQ
	 dbMUdOSYxDwqR6LZOP2UsV9yoo3+yVgid2XN6qk5zI3nmbYLHzHuFcW/ZcOpVgrgLp
	 LTLHmh/QO4iWWlvZKWol92tULrjsV+q4F5V46o2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 389/969] media: rc: streamzap: Error handling in probe
Date: Sat, 30 May 2026 17:58:33 +0200
Message-ID: <20260530160311.047746269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit 42844992664f03ef9f930e64f7370fa481e9c267 upstream.

If submitting the URB fails, the device will be unusable.
Probe() must fail.

Fixes: 7a569f524dd36 ("V4L/DVB: IR/streamzap: functional in-kernel decoding")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/streamzap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -219,9 +219,8 @@ static void streamzap_callback(struct ur
 	case -ESHUTDOWN:
 		/*
 		 * this urb is terminated, clean up.
-		 * sz might already be invalid at this point
 		 */
-		dev_err(sz->dev, "urb terminated, status: %d\n", urb->status);
+		dev_dbg(sz->dev, "urb terminated, status: %d\n", urb->status);
 		return;
 	default:
 		break;
@@ -358,11 +357,16 @@ static int streamzap_probe(struct usb_in
 
 	usb_set_intfdata(intf, sz);
 
-	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
+	retval = usb_submit_urb(sz->urb_in, GFP_ATOMIC);
+	if (retval < 0) {
 		dev_err(sz->dev, "urb submit failed\n");
+		goto rc_submit_fail;
+	}
 
 	return 0;
-
+rc_submit_fail:
+	rc_free_device(sz->rdev);
+	usb_set_intfdata(intf, NULL);
 rc_dev_fail:
 	usb_free_urb(sz->urb_in);
 free_buf_in:


