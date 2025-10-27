Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0C3320CBE;
	Mon, 27 Oct 2025 19:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593528; cv=none; b=ZvNnHJ+Hy32al2QOO9nLjgegn5iRAOc9jNkgma+NcjOGSM0rM8lAQSh+z1ymJIBt18h+k+gwE8l5824mM9pc4DVmwtnOiP9pPXim1c1igm+re8ERgjp/q0JRpNzZUQFDWHS6t7HQZOxHVoVYJdEIiOOEeyvhupexjT4syr4Vc7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593528; c=relaxed/simple;
	bh=X8LCVqnbGXfyr1sN0GftClq9rl57KOq2UeHHqnLXbds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImAzygl/LF2nM9OmsYKxilyoaH2RU4MgO/4XDMLL+ASKOBYX6c+l7lz2ercY2ruRZlcvxvqSiJOchHzLXHO/034NZJiysF+3mpVdPTk2OEcIEi0Pz4+XJzRtI5Ak7jmB+kDC7T1b4hHbqBPuV8TIA4Vh6yLAcrohGtFivK34WSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tV2L7d6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tV2L7d6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05BFC4CEFD;
	Mon, 27 Oct 2025 19:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593528;
	bh=X8LCVqnbGXfyr1sN0GftClq9rl57KOq2UeHHqnLXbds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tV2L7d61TefFPMcd21x7Lbrha8xGXD1B6Cgyb1/2lvrVyGYCzjek4ffIejFlqqmh
	 ykwRTkKVERAuK6ItcBB+aNGoiRAslr/dddNtOd5RqyRpoAkxVJ04j94mQX3NeXbR6T
	 9OtZ5ggxy/tDyVPCQUEUj86UtqNZa2O/ej1JHN1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+916742d5d24f6c254761@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Victoria Votokina <Victoria.Votokina@kaspersky.com>
Subject: [PATCH 6.17 163/184] most: usb: Fix use-after-free in hdm_disconnect
Date: Mon, 27 Oct 2025 19:37:25 +0100
Message-ID: <20251027183519.316427213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victoria Votokina <Victoria.Votokina@kaspersky.com>

commit 4b1270902609ef0d935ed2faa2ea6d122bd148f5 upstream.

hdm_disconnect() calls most_deregister_interface(), which eventually
unregisters the MOST interface device with device_unregister(iface->dev).
If that drops the last reference, the device core may call release_mdev()
immediately while hdm_disconnect() is still executing.

The old code also freed several mdev-owned allocations in
hdm_disconnect() and then performed additional put_device() calls.
Depending on refcount order, this could lead to use-after-free or
double-free when release_mdev() ran (or when unregister paths also
performed puts).

Fix by moving the frees of mdev-owned allocations into release_mdev(),
so they happen exactly once when the device is truly released, and by
dropping the extra put_device() calls in hdm_disconnect() that are
redundant after device_unregister() and most_deregister_interface().

This addresses the KASAN slab-use-after-free reported by syzbot in
hdm_disconnect(). See report and stack traces in the bug link below.

Reported-by: syzbot+916742d5d24f6c254761@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=916742d5d24f6c254761
Fixes: 97a6f772f36b ("drivers: most: add USB adapter driver")
Signed-off-by: Victoria Votokina <Victoria.Votokina@kaspersky.com>
Link: https://patch.msgid.link/20251010105241.4087114-2-Victoria.Votokina@kaspersky.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/most/most_usb.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/most/most_usb.c
+++ b/drivers/most/most_usb.c
@@ -929,6 +929,10 @@ static void release_mdev(struct device *
 {
 	struct most_dev *mdev = to_mdev_from_dev(dev);
 
+	kfree(mdev->busy_urbs);
+	kfree(mdev->cap);
+	kfree(mdev->conf);
+	kfree(mdev->ep_address);
 	kfree(mdev);
 }
 /**
@@ -1121,13 +1125,6 @@ static void hdm_disconnect(struct usb_in
 	if (mdev->dci)
 		device_unregister(&mdev->dci->dev);
 	most_deregister_interface(&mdev->iface);
-
-	kfree(mdev->busy_urbs);
-	kfree(mdev->cap);
-	kfree(mdev->conf);
-	kfree(mdev->ep_address);
-	put_device(&mdev->dci->dev);
-	put_device(&mdev->dev);
 }
 
 static int hdm_suspend(struct usb_interface *interface, pm_message_t message)


