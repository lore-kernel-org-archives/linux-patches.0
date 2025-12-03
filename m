Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8F731196C;
	Wed,  3 Dec 2025 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776116; cv=none; b=SiZrpzBXDa/f0DS8MCuzuLdfyLkPv7NTnsuJYe+CwfIejFJD9/tYOSAHpq7a+5cH3LkYvObZE2uTOQFBsKHcp8NB3v4fajs8pD2ZnZkfrMbe/wiUdQstk7owDcWDILaUEf1W+eSBdLdC9CZxWi/T7Ih+XcvOcEE5ZVRk3y5sDCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776116; c=relaxed/simple;
	bh=ADKCDZyyHJwmGjkqFpX4soDkc9uPAYZgnTpX1WPbXZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpQZfZOnL9wTxym2oCKRWqLToWhTRNtQ2XMgPFxg3sr+P2eafZ/tyoew1j44d6hG8jBRVd3QShiUubgKOF4xIYiFzWkn5QUaQNIjKYbxsATtYU6DNkzGdCtCsvf4Be87R5jMTNvfypteQy9Hx1461jSFi1Di2aQgHqgDI/5aNzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFRch/eI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFRch/eI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D35C4CEF5;
	Wed,  3 Dec 2025 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776116;
	bh=ADKCDZyyHJwmGjkqFpX4soDkc9uPAYZgnTpX1WPbXZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFRch/eIeBDfCwJsuLOUzwQV0GvsuTJTyriLA9J9yvNM/glIAyttaIvTFvjKAzbNy
	 KWVsqrDvydgsq+dq++5eBTo4jhvpppfjlr4XqFTgU59Ql7lPCJQ7Z0bommQeO3u/QT
	 mmZAWaFBWgTKcUBhpdEy0R/jV6xIwdEwlaT46myk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	raub camaioni <raubcameo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/300] usb: gadget: f_ncm: Fix MAC assignment NCM ethernet
Date: Wed,  3 Dec 2025 16:24:49 +0100
Message-ID: <20251203152403.772758260@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 752951b56ad3f..ea5f2cf330206 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1472,6 +1472,8 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 
 	ncm_opts->bound = true;
 
+	ncm_string_defs[1].s = ncm->ethaddr;
+
 	us = usb_gstrings_attach(cdev, ncm_strings,
 				 ARRAY_SIZE(ncm_string_defs));
 	if (IS_ERR(us)) {
@@ -1735,7 +1737,6 @@ static struct usb_function *ncm_alloc(struct usb_function_instance *fi)
 		mutex_unlock(&opts->lock);
 		return ERR_PTR(-EINVAL);
 	}
-	ncm_string_defs[STRING_MAC_IDX].s = ncm->ethaddr;
 
 	spin_lock_init(&ncm->lock);
 	ncm_reset_values(ncm);
-- 
2.51.0



