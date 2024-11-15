Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3516F188722;
	Fri, 15 Nov 2024 06:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653062; cv=none; b=ZMgh1f2B8Teinw01y6uki9F/XRN2ks4cmI8vycbce3UTTqpoyi2kRGI9bDO6MKR2rGOi+Ibrp7OvpVShR4zGZtDE+lv/nSJFQ1U73Tc2/GRFLcjE9Ot8bZ+RjesSsY637EwKdLd5gPKCqNqTbjAOL4k1mKLTThECSe/cGz0sh2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653062; c=relaxed/simple;
	bh=VIsKTITuBodzwfP/uDAXTMnVvFyjYRpkR1X2+WaWwhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uquKWHV1/oVToRqM8FePtO6jdnH9l+8rGjlt3FqD8yJM6+utxNUq4LV0WSjPseHhgMTNqhcQTUfc5NMBj7yj+nIEqF4R4gSEl2X9q7DAZUtEh0gSL8Ict4kVSTKhdnhlxYntO/pkEp612Esrqfsjj5r5/m3xJ/JMDdt6/1c1zpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlvmjoGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlvmjoGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A62FC4CECF;
	Fri, 15 Nov 2024 06:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653062;
	bh=VIsKTITuBodzwfP/uDAXTMnVvFyjYRpkR1X2+WaWwhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlvmjoGZwyDA7cDV0DdXws0bi3RcUDHvc5z9t8HLEsgv20oUVCA2LEMeubVcJjb+K
	 BfsF+Y6zu8BIhqrpeRFfEXmAu5CRwrMWVqkjjwCDEx3+g8HlKwDkG4OTockOb4BKPP
	 OyJKpPvxhuOr+9hJ+oYSi2wsCl7u//XvhW3z9OtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 41/66] USB: serial: io_edgeport: fix use after free in debug printk
Date: Fri, 15 Nov 2024 07:37:50 +0100
Message-ID: <20241115063724.328414967@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 37bb5628379295c1254c113a407cab03a0f4d0b4 upstream.

The "dev_dbg(&urb->dev->dev, ..." which happens after usb_free_urb(urb)
is a use after free of the "urb" pointer.  Store the "dev" pointer at the
start of the function to avoid this issue.

Fixes: 984f68683298 ("USB: serial: io_edgeport.c: remove dbg() usage")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -846,11 +846,12 @@ static void edge_bulk_out_data_callback(
 static void edge_bulk_out_cmd_callback(struct urb *urb)
 {
 	struct edgeport_port *edge_port = urb->context;
+	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
 
 	atomic_dec(&CmdUrbs);
-	dev_dbg(&urb->dev->dev, "%s - FREE URB %p (outstanding %d)\n",
-		__func__, urb, atomic_read(&CmdUrbs));
+	dev_dbg(dev, "%s - FREE URB %p (outstanding %d)\n", __func__, urb,
+		atomic_read(&CmdUrbs));
 
 
 	/* clean up the transfer buffer */
@@ -860,8 +861,7 @@ static void edge_bulk_out_cmd_callback(s
 	usb_free_urb(urb);
 
 	if (status) {
-		dev_dbg(&urb->dev->dev,
-			"%s - nonzero write bulk status received: %d\n",
+		dev_dbg(dev, "%s - nonzero write bulk status received: %d\n",
 			__func__, status);
 		return;
 	}


