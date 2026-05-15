Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BDE3EFFB0;
	Fri, 15 May 2026 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861887; cv=none; b=WRnIbr/MAf5gj/enO/VXNzMSlVu47D3tN1Ms6J764pCleSWkz4XmNs9FmAE8Yhhj2ssIFkBSVew2M6R/2FR8TkioXC7NCFMasgr+H6G4yABv0FDOkTfuFFEfc7ZaQExsjaprNpJKnLAz3CEVWWqO3rhdUv7LzMKy6/OAXXPG/tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861887; c=relaxed/simple;
	bh=vqq2nGisvvF1tFaPAIkTp6963/9lFSov8ahLWap3Vxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sA8WGSLkW5JhzeKwC1BBBFaYWbxAlXREf7lYFknowWTF5vTJpSkmZzNn0gGoov8AYubdSbpIcjQuIGmkmcYTjw8/EqD3hCJ5qrwwub8Plvy7TxtNa34d7r0XetijiTqQRuW72yx9ntDKBxh+bRDHfDyEQxzZ0cRe5fbK/2ZfsPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asTZrSAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asTZrSAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCD9C2BCB3;
	Fri, 15 May 2026 16:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861887;
	bh=vqq2nGisvvF1tFaPAIkTp6963/9lFSov8ahLWap3Vxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asTZrSAIrV9L/gdbbjQIrTl83AgZvVAjPU6r9jg7Ssnj8I2UFQbciZ1AWNRqhIi9F
	 /xCDaWRN7I8POAeuJczRLUvvoL1MMxI30WQ5QqbZUQapzdlOsL/VDQvkYBM2x5nol3
	 gxa6UvxLvGqmsVzkEhyf4aGP645S1ph3s5do/pW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 027/188] media: rc: streamzap: Error handling in probe
Date: Fri, 15 May 2026 17:47:24 +0200
Message-ID: <20260515154657.897906581@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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


