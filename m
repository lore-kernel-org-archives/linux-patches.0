Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75662857C1;
	Wed,  8 Apr 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674809; cv=none; b=uK23hU4m5T6z6DKtlkfaRdHff1nj0C81u0BSajjzgfq/lDs+jwK1/mFxOkEleOwT+Z7fPnLZmVDQoKBVz6mtoqpwe3FT9AqYmlyHwgHFNU6iH8lc+DDKiYbAdf8moWmUr/XDJO2grqWWdKO/DsrVP0EnVoVb8tzDLOhb9nLIdx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674809; c=relaxed/simple;
	bh=8qQGmV5KgBHYEAyjHeiwNJiq1+yapxk7O8T9M35cuVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7nGRHHl7tQ8PmW/AmBA3404G4yF9ZyrRxpkkpHjy9t/4NkBQGM9T6VsDZ/rVpq0DWoM12pbepdlXL0jn5OlMP3qBgYJbjCd8G6bQk5qJzeiNmTtLBPwfDdxomgHWR+27yJuqZiqzxzxrmHRg9DyC7TPh9I4tkzDP18x3NqUwtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUC0JDia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUC0JDia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3BCC19421;
	Wed,  8 Apr 2026 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674809;
	bh=8qQGmV5KgBHYEAyjHeiwNJiq1+yapxk7O8T9M35cuVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUC0JDiaI5U/9iVGowCVIIogbVN4MGV9xkL4s+0koX7ym9ueoS462AJt/bbM5PqDB
	 qKWRqUNUqWuTrs6BOPvNbVzcT9p4hFrfeubkf09Gx+evAVdZ5clpFg3L/R9XymluDr
	 +QiPXP9+JhBXYCG1+XCBVGESyBP9QINMOxY69ofo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: [PATCH 6.19 240/311] usb: misc: usbio: Fix URB memory leak on submit failure
Date: Wed,  8 Apr 2026 20:04:00 +0200
Message-ID: <20260408175948.355488248@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 33cfe0709b6bf1a7f1a16d5e8d65d003a71b6a21 upstream.

When usb_submit_urb() fails in usbio_probe(), the previously allocated
URB is never freed, causing a memory leak.

Fix this by jumping to err_free_urb label to properly release the URB
on the error path.

Fixes: 121a0f839dbb ("usb: misc: Add Intel USBIO bridge driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260331-usbio-v2-1-d8c48dad9463@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usbio.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/usbio.c
+++ b/drivers/usb/misc/usbio.c
@@ -614,8 +614,10 @@ static int usbio_probe(struct usb_interf
 	usb_fill_bulk_urb(usbio->urb, udev, usbio->rx_pipe, usbio->rxbuf,
 			  usbio->rxbuf_len, usbio_bulk_recv, usbio);
 	ret = usb_submit_urb(usbio->urb, GFP_KERNEL);
-	if (ret)
-		return dev_err_probe(dev, ret, "Submitting usb urb\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "Submitting usb urb\n");
+		goto err_free_urb;
+	}
 
 	mutex_lock(&usbio->ctrl_mutex);
 
@@ -663,6 +665,7 @@ static int usbio_probe(struct usb_interf
 err_unlock:
 	mutex_unlock(&usbio->ctrl_mutex);
 	usb_kill_urb(usbio->urb);
+err_free_urb:
 	usb_free_urb(usbio->urb);
 
 	return ret;


