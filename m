Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2196A347DD;
	Mon, 23 Jun 2025 13:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685519; cv=none; b=BkzOuxmm4OorwQ7OhuQgVD9VlXDlbwtgWgRsKN8t3FPpSRdnovjFC9RewdaDKjBF7egqod7YC6RY9p6WTPH+Kv9IFM+rR5gSFycaIowMM5zJLYUoyvoCavKWMpCsKDTbNUiet0U1wWsDZY2LHswew+t0vbPHQaFAexBCWyUQZ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685519; c=relaxed/simple;
	bh=xGwIIxaX9M0a6ZU/k396wVPyPdYis+WG3qPLJY04+vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mzo+BxTeCvEFB9+pb6bldWIX7VmLy3MxZ8sOmpBb2KnvCUlTcorU60iElxL8PGC2bRiSOe2tnuaNS5AgmQ5VpAy8xO/f2c3NVTM0TlJKAcknz87m1GP0mAfV0cUHm6p3C9nZ3reg28Fpr4k74hhOmlVtXBULwtJK192qtiW9hx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKwPRVQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKwPRVQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B91C4CEEA;
	Mon, 23 Jun 2025 13:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685519;
	bh=xGwIIxaX9M0a6ZU/k396wVPyPdYis+WG3qPLJY04+vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKwPRVQ1VmomwbgR56d2CHFWdZrHxHFRTBRGtwxhbFjSlPAU5YFZ5zZQ4d3h3UEPY
	 yCJ+x/HUff3Rem3cC37x2WEDnm7ZXPvlHsVvzxdXAtCUD4n9vH80Wva4//mkXXodcU
	 t2nu4RvLb5d+X02kk3kS7mlf+urzkLeIybMavbZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.1 012/508] usb: usbtmc: Fix timeout value in get_stb
Date: Mon, 23 Jun 2025 15:00:57 +0200
Message-ID: <20250623130645.556060034@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dave Penkler <dpenkler@gmail.com>

commit 342e4955a1f1ce28c70a589999b76365082dbf10 upstream.

wait_event_interruptible_timeout requires a timeout argument
in units of jiffies. It was being called in usbtmc_get_stb
with the usb timeout value which is in units of milliseconds.

Pass the timeout argument converted to jiffies.

Fixes: 048c6d88a021 ("usb: usbtmc: Add ioctls to set/get usb timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250521121656.18174-4-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -483,6 +483,7 @@ static int usbtmc_get_stb(struct usbtmc_
 	u8 tag;
 	int rv;
 	long wait_rv;
+	unsigned long expire;
 
 	dev_dbg(dev, "Enter ioctl_read_stb iin_ep_present: %d\n",
 		data->iin_ep_present);
@@ -512,10 +513,11 @@ static int usbtmc_get_stb(struct usbtmc_
 	}
 
 	if (data->iin_ep_present) {
+		expire = msecs_to_jiffies(file_data->timeout);
 		wait_rv = wait_event_interruptible_timeout(
 			data->waitq,
 			atomic_read(&data->iin_data_valid) != 0,
-			file_data->timeout);
+			expire);
 		if (wait_rv < 0) {
 			dev_dbg(dev, "wait interrupted %ld\n", wait_rv);
 			rv = wait_rv;


