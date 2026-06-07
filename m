Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3BF2D8378;
	Sun,  7 Jun 2026 10:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829375; cv=none; b=hJ1Ha8AAq7I8DMlth6NKZ6/MMKJrOIO1ERvTt+T87jYHttMJ9ibiHpkNq81QE0jE3AB/wITa17k+F9mMsxfN0aJYpCmBTTZAEDoF9jcZafm65AJ+S4vyqEwRclqfxN1tLtlf8kd+oTNykWATRdUzJ49MVXUFxly0syWyV6BPvpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829375; c=relaxed/simple;
	bh=dlo5ze5v3IBNXGV1E4pE3nGZz4qd3L5HOcS9VZQ/DtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3hwDwL27w6WQ5H2MweE07VhO5DODizPLcEjNA9aG3OZMPQYsWF/3Hgz22kapDIihzDCIdinm28guRNvQjiGVHxdTevnsW1AeUNi3m9JYmN0abGreiEo1ki3vc3qvEdw64khp32d//vj+pI/ESjrQIkvVvboZHzpnPz6DRVBJCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyB+2gCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyB+2gCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E19D1F00893;
	Sun,  7 Jun 2026 10:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829374;
	bh=3xfjE12CjfMtPM9JvdVmaMC80cMOXJzMmqVv6X3UbrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyB+2gCFjJHQE+YhOA6wmLIRqZ3RqA7spM7IhQZX0I5yfw5Dw62/leUm7JNCpV6gl
	 8U3UOdSlzaP9iWG1udxG6w0Gfvn0dIBsvqp8oLZmYQD4xYhyEGRI5LZ4b0QDCu+I/s
	 h1W0AYDEJoV/7E4RkfZct2cESNeX9YGZYiBL0o/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 242/315] usb: gadget: net2280: Fix double free in probe error path
Date: Sun,  7 Jun 2026 12:00:29 +0200
Message-ID: <20260607095736.452109105@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c8547c74988e0b5f4cbb1b895e2a57aae084f070 upstream.

usb_initialize_gadget() installs gadget_release() as the release
callback for the embedded gadget device.  The struct net2280 instance is
therefore released through gadget_release() when the gadget device's last
reference is dropped.

The probe error path calls net2280_remove(), which tears down the
partially initialized device and drops the gadget reference with
usb_put_gadget().  Calling kfree(dev) afterwards can free the same object
again.

Drop the explicit kfree() and let the gadget device release callback
handle the final free.  This issue was found by a static analysis tool
I am developing.

Fixes: f770fbec4165 ("USB: UDC: net2280: Fix memory leaks")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260427153651.337846-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/net2280.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -3790,10 +3790,8 @@ static int net2280_probe(struct pci_dev
 	return 0;
 
 done:
-	if (dev) {
+	if (dev)
 		net2280_remove(pdev);
-		kfree(dev);
-	}
 	return retval;
 }
 


