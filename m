Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598DE51121D;
	Mon, 31 Aug 2026 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183781; cv=none; b=mamr8OLNalkzLh3qDM8h10f2394fVBOddTS38QZojGlDmpqa5phCNKbMkt6+nLnlCojmkg6Qm6N1XWOO8IFM71Knbvn6/EZwJwKoeWKH1twogY/finhbrvQkIylouaR2Tf77QG06gLiHHKt4YwDaLz0Sj4SGgw/tPTl09+x8hXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183781; c=relaxed/simple;
	bh=kd1Nwg5dgKl/b6mkRX4naRdRVzjdAanqwJzg6bCBxIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHNajYnix9oGFFQ+vtNqYBItyOJF1xF86Fh5zuYc+958gA9JDlx+30NLay6zlvKtRwIT+EO1OYardWMfhJWEKPkcESgJCYqm98Q+YQHwwIoBMV0YB9Y0WVhmgxMEKfWqUIspzP2iQrb0xHF1BV/+5GzmP5H1OQk19ORyIOn1YHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAGPBrBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAGPBrBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D541F00A3D;
	Mon, 31 Aug 2026 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183779;
	bh=KdJ/ILiecvNMOnwKPAJ83nzD1Wby8ZHc1pg4UsJGv8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAGPBrBCJxSIu6pEMu30Yx3EYqcknd5SCV5H2mch9LN6jGvNAR39knDE4BlZuKrE2
	 Ozop1qV2fnOx3n7kwoQFQXXQ32m5/yELI3TcpBRHzyByqx89pwhRIEloVXNK7MLgrV
	 P02zvhDm7pVN6t62cF6xxI1cVWfN/KVPbX5YRoVUYagWIrGCjWYp797QcDF9I2XiAk
	 k7gw5M8RJAGWc8/IWD2rEavorKD8qpmY53SImBQb1Tid44SX2i44DpgmeadRJjZECO
	 xpdEiwldxZ9XiQsp96Y7XpSU1WUFKBoyAzuHvUvaHd3vQX8+2DE/WofzXoyW2wxQ9w
	 JdrFhwYM38yzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xu Yang <xu.yang_2@nxp.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] usb: gadget: udc: skip pullup() if already connected
Date: Mon, 31 Aug 2026 09:25:27 -0400
Message-ID: <20260831133314.4125787-299-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background `git log -S` search finished. In this **v6.18.43**
checkout the history is flattened, so pickaxe only points at
`19eef1d98eeda` for `vbus_work` in `core.c` — it doesn’t show when that
logic was really introduced. That matches what we already inferred from
mainline: the dual connect path dates to the 2023 `usb_udc_vbus_handler`
workqueue offload.

That doesn’t change the backport call: the buggy code is present in this
tree, the fix is small and applies cleanly, and the verdict remains
**YES**.

 drivers/usb/gadget/udc/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index ab1bcc5512b2c..fa49746d54036 100644
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

