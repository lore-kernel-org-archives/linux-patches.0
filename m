Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBCB3B19B9;
	Sat, 17 Oct 2026 17:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256515; cv=none; b=l5Gl4el6bSWZUgK09eRjb/tnaYNrzaiQ1EzxWZ0WMDZm/5h49ff/KoIXa0+5Z5kyKCuToqbcjtGyu0dfs7vegsUvdsqjdxJVSdfxLamm9StJtKonNhW8QkVbcm8m/cOubKr42vde8inkuZI9hh28gpQYhg+MdmIqhHhKCn0zWpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256515; c=relaxed/simple;
	bh=+F10NV54XZK754bJeXoMzeih+h39fnO06dPbn+XXm9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShvLQ2l4PDVurtl0O6EVyT1TzmGDgihNKx5c/QR+3uS27qBbrmnTpq6CaTJuBZMg8Pdl2ViHtqVzIrfHmw0MOxjp/Ckshjlk5wRJOL++txmpDVLJ9oGrxg3z8ZwlK3u7LqtgmHu8HwqZSpjZNL1Lo9KGzHWcB2ZFX2X+OjzpKng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SspZDxZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SspZDxZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C761F000C4;
	Sat, 17 Oct 2026 17:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256514;
	bh=9ykGwscD+yGJgfdbfCceK9osntCD8weC8Qwj/U2N81Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SspZDxZZRTiGFIXqjBhUGPzv4V0Wx7bFB/ICIrRWFoCX8gD5SEfauiGNboAXSrcWS
	 NFmw9nfzJGxszGu17yGt3AhRmooBqFflQo5HMWRgqfplGq80vdhVDOjWEI9pUz+aiP
	 VMitJdXUaiU2r4Z4MBmJI+0Kmz/CnmtsNM6gtj9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 0262/1674] usb: ohci-s3c2410: disable controller wakeup on removal
Date: Sat, 17 Oct 2026 17:42:14 +0200
Message-ID: <20261017160437.852154187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 8dd8451c527e2a723bca20da5a6d724b8592551f upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-3-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-s3c2410.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -335,6 +335,7 @@ ohci_hcd_s3c2410_remove(struct platform_
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	s3c2410_stop_hc(dev);
 	usb_put_hcd(hcd);
 }


