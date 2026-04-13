Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E848A2EBB8C;
	Mon, 13 Apr 2026 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097198; cv=none; b=Dqz2U4If6d20V25DGwdFWnH8HoamEolvt0cFRg245dG7ksFymO5jxIIFS7kh4UFyRiZj7Ci2aejwS7D7nMVXydnCptlX4D+ysbxQiokFbrI9bPXzjZYKBedizzLoFa0qcj9cuU0P+4dsbRYU28lpKY/OYAwowDHE6DN3iMs3YL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097198; c=relaxed/simple;
	bh=zD7MFsfoPJDHRLj/b9pl0TavfnwH1y3ICtQGVZLnDmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVgidj8gF8vNCqhaTCpaZO8EawMxiZ3MEKD6t1kBvXFShNAlLtqtRVUazAV/bd4dBEa6JWoMRWWX8UW7a143vd1s6yLU9nGaR6kGP6QiIz1N7VQ3RsrSk3GnSkt8IYixCdn/ADlTSuHzxuiQIr1cdR9T0t9VDDz/JQlaXjkIgzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFW/17H6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFW/17H6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDA7C2BCAF;
	Mon, 13 Apr 2026 16:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097197;
	bh=zD7MFsfoPJDHRLj/b9pl0TavfnwH1y3ICtQGVZLnDmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFW/17H6AMdTEV6Iol6OOTTivJAW4Yyoclbd6uojhX/NheFE3d3CJkMWQKPBKuP8H
	 jEOJwoCUOutv6glsBKeUJjM9uH9OQJX5wsgRD1wHQP3l6SZYK+LeJLsYqUB44BPVmE
	 rV0jdXEL+XdIth3LBh0nAxMU1ejTaQuD+7MUC520=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 043/570] nfc: pn533: properly drop the usb interface reference on disconnect
Date: Mon, 13 Apr 2026 17:52:54 +0200
Message-ID: <20260413155832.041798331@linuxfoundation.org>
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


