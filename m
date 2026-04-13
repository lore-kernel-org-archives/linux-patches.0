Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ECB1A680C;
	Mon, 13 Apr 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098499; cv=none; b=XozBW0/Jk9/zKqv11pGpgbtejg4h2rw22FeluPBr9tFsg3LX5ynwnSM7CMdnzTfsFuF2kb+rm0IWb8+BxRSfASXk4NFozkH2nTMfvkmSAyyvB4BjqeWCcn3oxzA5YBQeq3qKCYd/pUCxM6fhFsEmDFJInEpTyXugHlEUH1tZitw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098499; c=relaxed/simple;
	bh=zBbF8Xq4b6KwQlT2Xqo6AA4MJC32aPqdPIkCFfM2fDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZG8j1khOmFSgaLpssBDlOauQFF8AD1EsRhviyrfW5i3BtJKqcFrb48n9noKNaiUct5jUS9TVsNPHnnG/CKRGaI6YhuCLt9t2k5mHIyyUC/NypoFJlUCQx7U9wUlswnHE6oSmVXHGwjVScRgIuwwn+oRTUK8xhsCNsf6k7IKHGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/mslR4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/mslR4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C11FC2BCB6;
	Mon, 13 Apr 2026 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098499;
	bh=zBbF8Xq4b6KwQlT2Xqo6AA4MJC32aPqdPIkCFfM2fDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/mslR4wcBFTNgePBEYgXYe8+HJVl+eSEplpa8AQibs1wuQ0KZSRyY0yQWh18IefJ
	 adEigZoq6Vti+YfCKOUhlfA5xb+usvdXBf0Jhn3BIfAfczhSEfGmNRJp+84oyvP3kq
	 SHsRPrUWVQBhWiJ0PuzL74o+bocsLiRoi77lIXiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Thanki <vishalthanki@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 506/570] wifi: rt2x00usb: fix devres lifetime
Date: Mon, 13 Apr 2026 18:00:37 +0200
Message-ID: <20260413155849.406892323@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 25369b22223d1c56e42a0cd4ac9137349d5a898e upstream.

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the USB anchor lifetime so that it is released on driver unbind.

Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
Cc: stable@vger.kernel.org	# 4.7
Cc: Vishal Thanki <vishalthanki@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260327113219.1313748-1-johan@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -830,7 +830,7 @@ int rt2x00usb_probe(struct usb_interface
 	if (retval)
 		goto exit_free_device;
 
-	rt2x00dev->anchor = devm_kmalloc(&usb_dev->dev,
+	rt2x00dev->anchor = devm_kmalloc(&usb_intf->dev,
 					sizeof(struct usb_anchor),
 					GFP_KERNEL);
 	if (!rt2x00dev->anchor) {


