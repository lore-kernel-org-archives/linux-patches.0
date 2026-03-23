Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2904282F3D;
	Mon, 23 Mar 2026 16:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282209; cv=none; b=eSNqF+NlvnArhsrYJ6crfeD92QnlVLcSWJ7F8A5F/eokuuH7DjElfY/NWbikW2fYFQ5fmAJbA/T+CxfvL15cwIbwG0I4aPFVk7zzlJIGEeiubFx/j5EcTj7hU/qfOSCw1P9HWyGBaQ4+kz2z9XKSa1L/oVbtLlI61c7BEerj4Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282209; c=relaxed/simple;
	bh=gcr/6Cv6JA0l3lNrn7YLDDBk19DZQ7CdkxqOMQkm+fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpuhqCxkGVSXQgSEcrDdoaGMDVnODr3jugCN4sSRgnH0REtow+0FCU5Y2/e/nGZEwiunQEI2vuyrBVbB2dBP52oHzQbUcSy2GmYJ8bhIxya9mNI6nHZXwXbw1K1ijfbZGiqNeqm9g7qpi8ysd1H3TOiaylVP5e2ppEn3ZZHiNFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1FkWFPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1FkWFPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30565C4CEF7;
	Mon, 23 Mar 2026 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282208;
	bh=gcr/6Cv6JA0l3lNrn7YLDDBk19DZQ7CdkxqOMQkm+fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1FkWFPnKwvHyKkHLSEmmWmKWuYQjCqMKq7Y/cIYiDUxh6kVrsVLULNDbIwkjWqvc
	 +CaejjOOY0EHFFMe916rahaBdXYhWMeTJt5yMaclNtKalvxZ6hHajRJJKE0sLi90cI
	 WtgS5E3pjkI6SBezFwfauXSiNHPfsjDeFAoSBB9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 071/481] nfc: pn533: properly drop the usb interface reference on disconnect
Date: Mon, 23 Mar 2026 14:40:53 +0100
Message-ID: <20260323134526.964889457@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 12133a483dfa832241fbbf09321109a0ea8a520e upstream.

When the device is disconnected from the driver, there is a "dangling"
reference count on the usb interface that was grabbed in the probe
callback.  Fix this up by properly dropping the reference after we are
done with it.

Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
Link: https://patch.msgid.link/2026022329-flashing-ought-7573@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -629,6 +629,7 @@ static void pn533_usb_disconnect(struct
 	usb_free_urb(phy->out_urb);
 	usb_free_urb(phy->ack_urb);
 	kfree(phy->ack_buffer);
+	usb_put_dev(phy->udev);
 
 	nfc_info(&interface->dev, "NXP PN533 NFC device disconnected\n");
 }


