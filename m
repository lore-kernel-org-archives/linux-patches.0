Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5992BB1B;
	Fri, 15 Nov 2024 06:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653869; cv=none; b=j0cCx9WlRmz745c8V2kHVaUyyqBZj54/QEA9iZVXgvyVr8yMaYank+Ewk100DLgaqX9GYsPz5wIfxGA82YiDugU7qdgOW6FNK49DRpral+Oa/I7Sdq/ciQFitY4vOiF9bhoLutLX4c5BVOS4+D5r0VtyOEVgzOCWFlSOO6341Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653869; c=relaxed/simple;
	bh=I4B+QpZyg00eeb3t51UIE1I/WvMFHuynLkePBgfdzak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh2O6T0ICk404837RUZtSMN6EOr+qDFYL4AqshY85kR4SVDIH50px+a6HWB2T7YpOIby9T35eY7qSte6d7+mbvr6lib7+donnZvDmPBQxZ+7TRTWwVOsvCyFr8leu1mfpkaa2O09+CH6mO4Wq/S29PpsHSf9s/7/DscR53MSjN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1pGZenG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1pGZenG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9304C4CECF;
	Fri, 15 Nov 2024 06:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653869;
	bh=I4B+QpZyg00eeb3t51UIE1I/WvMFHuynLkePBgfdzak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1pGZenGU5K6f6vPW+QjMfKrKyMpJEFvB8Ksf647E7/WbYpuwX/eiHZu2Uqm1W8+y
	 oVp3tmKCql4h48OFp6DVU77RhJ+ffgIsOfcrppv57TiTjofchLwE1gGCnm0X/1j2rL
	 dIT5S4ZKAVXPX1PpKH0qvtLJQ1Lpt3hXe4856wiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 58/82] USB: serial: io_edgeport: fix use after free in debug printk
Date: Fri, 15 Nov 2024 07:38:35 +0100
Message-ID: <20241115063727.648490151@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


