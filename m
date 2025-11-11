Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A242726ED5E;
	Tue, 11 Nov 2025 01:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823373; cv=none; b=dY/36POTFZVbKm2DlVThMW9dVpX5zrpDu1JNcvvNIwOwdPuR7nHdBDSCXdHidYMNPfDC2R7lJW9nxjKp7x5rJFgCf4Nz+r+OQ+/wy6QBUyaYHYp7N6hiLcjA9xtNQ4wC4yuM/iTG8tMgTftmDcb0KiUbbPEgWx9j3HlznMlsg1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823373; c=relaxed/simple;
	bh=iIh7DpSA+plwPsh/DRjgyVGHwdKxbmjPCqJ02hmRfXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDrY3nyckwcmJt4aNbq2m7f5ywnycQyO/u71wIJovcoaxOhesoBN99Mp54NIDzbaf2deJv7QMuvUbUMRnt2+h72M/dzonIY9EqOM1x10VT/H3Uv0o3dIok74VI9y1h88UEqcnFYcpUTX+MBkNybow4jIRhppffqeubAOG06YzoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFwWmCX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFwWmCX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435FFC4CEF5;
	Tue, 11 Nov 2025 01:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823373;
	bh=iIh7DpSA+plwPsh/DRjgyVGHwdKxbmjPCqJ02hmRfXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFwWmCX3cGjPjG79KktwfQZksY5nCFRFEN1dKgB/m+GXHXOudlbEVD2FUqEGYe5E0
	 t1hl+VkRnGVOb57fSlVwYbjq7gjQR6pJzgAav8iiaRuBZWyWDOUArAgetCCAtUTtDo
	 qh9/6Or9bTpLTUU9EWa6Kk0CVCT2OLiZMR2DvlMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	raub camaioni <raubcameo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/565] usb: gadget: f_ncm: Fix MAC assignment NCM ethernet
Date: Tue, 11 Nov 2025 09:41:25 +0900
Message-ID: <20251111004532.068784725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: raub camaioni <raubcameo@gmail.com>

[ Upstream commit 956606bafb5fc6e5968aadcda86fc0037e1d7548 ]

This fix is already present in f_ecm.c and was never
propagated to f_ncm.c

When creating multiple NCM ethernet devices
on a composite usb gadget device
each MAC address on the HOST side will be identical.
Having the same MAC on different network interfaces is bad.

This fix updates the MAC address inside the
ncm_strings_defs global during the ncm_bind call.
This ensures each device has a unique MAC.
In f_ecm.c ecm_string_defs is updated in the same way.

The defunct MAC assignment in ncm_alloc has been removed.

Signed-off-by: raub camaioni <raubcameo@gmail.com>
Link: https://lore.kernel.org/r/20250815131358.1047525-1-raubcameo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_ncm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 3afc9a622086c..28e57d93973ac 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1464,6 +1464,8 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 
 	ncm_opts->bound = true;
 
+	ncm_string_defs[1].s = ncm->ethaddr;
+
 	us = usb_gstrings_attach(cdev, ncm_strings,
 				 ARRAY_SIZE(ncm_string_defs));
 	if (IS_ERR(us))
@@ -1759,7 +1761,6 @@ static struct usb_function *ncm_alloc(struct usb_function_instance *fi)
 		mutex_unlock(&opts->lock);
 		return ERR_PTR(-EINVAL);
 	}
-	ncm_string_defs[STRING_MAC_IDX].s = ncm->ethaddr;
 
 	spin_lock_init(&ncm->lock);
 	ncm_reset_values(ncm);
-- 
2.51.0



