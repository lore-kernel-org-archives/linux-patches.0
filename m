Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2979A3C81B4;
	Fri,  7 Aug 2026 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116294; cv=none; b=NhwGUGB/F6UOwrXfKh+IZNWnV/djLIkcBHzW3nuR/T/I6vHSdjvcYe+cR1mU7idyeM0A7EZrpl6BlbZRuaB/y8C2Y0QNsGGqg9ciIXZ4/yqEaxpM2CmUgVj4EXgvp0dRkm6Ya0mxB1cJof/7463O89W81H4yOO8UhA5gxsvvGIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116294; c=relaxed/simple;
	bh=C6RB+2vsMeSIzZVyXLzwA/oPqxuv+T/BP2FlYxxDXHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGI5CTXJRrWqMYPZDdWZjXm/wu1mvifVP262tlJ+3b7EOUH3w7g4GsxLph672sZ4Jfvg90/rQYCi5L8IacVXHzHmUok5fOvg9dSwJNK2FZ3MT9HqoADDBM8F6xKfms1da7Slvw/8G7bH1wWCv2UCLT7anfL5ub//8o5HTNm3Hhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQn78jUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQn78jUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8681F00A3F;
	Fri,  7 Aug 2026 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116292;
	bh=E4sejrHC5NJMwlN6tcgAVDvuGC3nrERxgkMyv+r537g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQn78jUOZZsopDjS/QsMB9Ggkantyu2Ut8eNQ/4iRzINwDwIgVz2vUMP9JBJaZFbr
	 IELiYrFPKy1VJg4iiUoBeQMh12v++o0C9a1prI2l2faaIZAVosJ7G24WznpbLb52l4
	 Qi+A1FbNFROC9SCeYnYG5W3jkiGQCVUIia0AKea0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 180/261] can: peak_usb: peak_usb_start(): fix double free of transfer buffer on URB submit error
Date: Fri,  7 Aug 2026 16:38:57 +0200
Message-ID: <20260807143419.245454548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 9b3d5a6d952c38bbcf07f903cbeadefdb56b9bc9 upstream.

In peak_usb_start(), each RX URB transfer buffer is allocated with kmalloc()
and the URB is flagged URB_FREE_BUFFER so that the final usb_free_urb() also
frees the transfer buffer.

If usb_submit_urb() fails, the error path frees the buffer explicitly with
kfree(buf) and then calls usb_free_urb(urb). Because URB_FREE_BUFFER is set,
usb_free_urb() -> urb_destroy() frees the same buffer a second time, a double
free of the transfer buffer.

  BUG: KASAN: double-free in usb_free_urb.part.0+0x91/0xb0
  Free of addr ffff8881069ccb80 by task trigger.sh/285

  Call Trace:
   kfree+0x113/0x3c0
   usb_free_urb.part.0+0x91/0xb0

Drop the redundant kfree(buf); usb_free_urb() already releases the transfer
buffer. This mirrors commit 03819abbeb11 ("net: usb: lan78xx: Fix double free
issue with interrupt buffer allocation").

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Closes: https://lore.kernel.org/linux-can/178159320216.2154888.16953451793788581739@maoyixie.com/T/#u
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/178163373110.2507866.216458825145756798@maoyixie.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -470,7 +470,6 @@ static int peak_usb_start(struct peak_us
 				netif_device_detach(dev->netdev);
 
 			usb_unanchor_urb(urb);
-			kfree(buf);
 			usb_free_urb(urb);
 			break;
 		}


