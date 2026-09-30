Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A10509EEF;
	Wed, 30 Sep 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784063; cv=none; b=rvOfZUY73+2gZHJqGMFoQXW1TU+O/3QkagJdgvHbPHnQsuHpcQMLeczownCGZMOnprEqDwhwAEsqvIcg9ljFzbqIuX1Jb9QgBmG3c9WeuIe4A+x1pAt1JbzwoakuTLS72080b7v6rTX1K75JPr2ix1g7fzLqW8+jvPI+akjXCXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784063; c=relaxed/simple;
	bh=kTMfVO5e71EuZt2u7iH+5NKQ7AIlp7EcilEnKVw5BOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjLRgeqZoRHPiY3z/9fm9arpocCWItz9uC7esWyFDVSMqjPQKG+meSbkFC4ZRzyIQk1YwJTi4/XafogE6JTSxRXXFYDUsIn7hKmDYEciWPO3kkDDgGdcwAG/NXGJt6wf4pkME+DHwUaTkS6Qb5sTM96U9QQlx+OoitoRiCccEeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQgMukni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQgMukni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687501F00898;
	Wed, 30 Sep 2026 16:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784057;
	bh=h2151UB51isHTp2cs7hXg6EEHGYywXF15e42bAqpyzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQgMukni4VAHBWyRTXJcrH/LpMaje/aUDPWuKfyDhmEnaxYP0GaouCTfRKTjNNKlc
	 SubmM+D3iYomLa7g0oWIq/2gF+RwX8gdHiYFAcFBEcvNBOTAEqQGFI6HkoS4x2Ug0R
	 m7lyqC+VA/XqIpe3NiyMtyZJsDgcftRk8tUxOvkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/982] usb: gadget: udc: skip pullup() if already connected
Date: Wed, 30 Sep 2026 17:12:21 +0200
Message-ID: <20260930152416.899670375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 62911bc82b0332aee7546156800d3516500fa1e1 ]

The device controller may update vbus status via usb_udc_vbus_handler(),
which tries to connect the gadget even though gadget_bind_driver() has
already called usb_udc_connect_control_locked(). This causes pullup() to
be called twice. Avoid this by checking if gadget->connected is true.

This also set gadget->connected as false in usb_gadget_activate() if it
became connected while it was being deactivated. Otherwise,
usb_gadget_connect_locked will return early and pullup() won't be called.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260423095355.2673035-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 577f7945cc303..addcff2f77110 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -714,6 +714,9 @@ static int usb_gadget_connect_locked(struct usb_gadget *gadget)
 		goto out;
 	}
 
+	if (gadget->connected)
+		goto out;
+
 	if (gadget->deactivated || !gadget->udc->allow_connect || !gadget->udc->started) {
 		/*
 		 * If the gadget isn't usable (because it is deactivated,
@@ -887,8 +890,10 @@ int usb_gadget_activate(struct usb_gadget *gadget)
 	 * If gadget has been connected before deactivation, or became connected
 	 * while it was being deactivated, we call usb_gadget_connect().
 	 */
-	if (gadget->connected)
+	if (gadget->connected) {
+		gadget->connected = false;
 		ret = usb_gadget_connect_locked(gadget);
+	}
 
 unlock:
 	mutex_unlock(&gadget->udc->connect_lock);
-- 
2.53.0



