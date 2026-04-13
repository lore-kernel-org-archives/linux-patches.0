Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5049C2F8BC3;
	Mon, 13 Apr 2026 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097435; cv=none; b=c4UR9ghMeq4EoNButKysPOIG+ihv4h7sia697KMNc1LbCmHuX7wnSAs8zQ+JFu5uuzoIFb00ggnystiKdJHGNk8cIK0orSpxduK6Y19C1fsCqluaDAC2/0tgYSKCFTGvv/KXFfhAjkCXAytfEcuWTmZv3B0E7cOuN+nysGzDqko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097435; c=relaxed/simple;
	bh=7C+eggGTjp9V6gpvG0IrwF1fifvDzsbWzRQ0pLeo7Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGOCD/dsPCppTWEFekm2x0f8CHECGIllor7xP2cLebzUwIMYVTVHoiuGjavQljqEKNMKaEc15mF7tYKEB6SUB4fY6tlzFZMJQuP6yYi0f0ickS1u7Cc7S5Dd+ZxsZQLZspt6bNpLeYozIM+vYgQw1hvYgHnQDtlhpXrsO42Mr88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL8L/aNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL8L/aNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA328C2BCB0;
	Mon, 13 Apr 2026 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097435;
	bh=7C+eggGTjp9V6gpvG0IrwF1fifvDzsbWzRQ0pLeo7Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vL8L/aNBFKknBMa88ibBk9UHMKXV+mNr+DEyGOoKT5tu4mVjrQ5qbl01XPMaEeuIr
	 2olFWJr+4eS48pCrf3+5KDhguVT3tx13+Cp0Vzsm9/pvO08rsIAAL23Nw0zYR9EQxa
	 55XWl9ZZb56xEcKze29un4JZydJM+i7oxoY+x35Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 136/570] usb: yurex: fix race in probe
Date: Mon, 13 Apr 2026 17:54:27 +0200
Message-ID: <20260413155835.537523715@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 7a875c09899ba0404844abfd8f0d54cdc481c151 upstream.

The bbu member of the descriptor must be set to the value
standing for uninitialized values before the URB whose
completion handler sets bbu is submitted. Otherwise there is
a window during which probing can overwrite already retrieved
data.

Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260209143720.1507500-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/yurex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -272,6 +272,7 @@ static int yurex_probe(struct usb_interf
 			 dev->int_buffer, YUREX_BUF_SIZE, yurex_interrupt,
 			 dev, 1);
 	dev->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	dev->bbu = -1;
 	if (usb_submit_urb(dev->urb, GFP_KERNEL)) {
 		retval = -EIO;
 		dev_err(&interface->dev, "Could not submitting URB\n");
@@ -280,7 +281,6 @@ static int yurex_probe(struct usb_interf
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
-	dev->bbu = -1;
 
 	/* we can register the device now, as it is ready */
 	retval = usb_register_dev(interface, &yurex_class);


