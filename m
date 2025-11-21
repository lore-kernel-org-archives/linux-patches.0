Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E0433438C;
	Fri, 21 Nov 2025 13:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732529; cv=none; b=ChpyAnb8TjoqawtpJ6gNwkCmyz8qVXnPZGwohccX8GaB1B/OtOnko5dfYQLlUWqgAysHMqMp4hxUQ47p4BURw+Oc9wAeq3VbBLV0wa4ON2rmuWkveYxvt3AfiSWrdJ/+SCrL7EZZk4hlygITLwYFquj7LqugwXwwNmnteencFuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732529; c=relaxed/simple;
	bh=p+9+I52CXyKLKQ0tL2hpgd/MLTesw4yzDoVKU46lv8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LO6tU8roauFOhDr03xoePAQ5vw660tHFKzWOIJGHHQ04vN6zQ89s1K3MAJuepi6bKBgCYBlQwpBzfjmjD8F0NhgfrSd9CYdG6hkZxgntSyoKXtoeHVOQIwGksP5O4CX8AeG/ceL6BglZoecncaewx6OR1Aydc31aUdc17799S7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/35xhOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/35xhOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F0AC4CEF1;
	Fri, 21 Nov 2025 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732527;
	bh=p+9+I52CXyKLKQ0tL2hpgd/MLTesw4yzDoVKU46lv8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/35xhOMKHaeut4BOTrR3vU8BDaqHeTPIvxZ/mxZAKPIRd9u7iROhUiVzi/Q93RzO
	 RDWotIXVxGClIaWaP9bH0EOs4hQgz8iflqYknn8RVOVtKOKxb3YeTAw4OrzMzbDg5r
	 9yu5UxizLB/JhLEmCMD9/RgrGwt/2TfnmjUoCdKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	raub camaioni <raubcameo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/529] usb: gadget: f_ncm: Fix MAC assignment NCM ethernet
Date: Fri, 21 Nov 2025 14:07:31 +0100
Message-ID: <20251121130236.427303812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7aad737901e83..1da4e59338c56 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1449,6 +1449,8 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 
 	ncm_opts->bound = true;
 
+	ncm_string_defs[1].s = ncm->ethaddr;
+
 	us = usb_gstrings_attach(cdev, ncm_strings,
 				 ARRAY_SIZE(ncm_string_defs));
 	if (IS_ERR(us))
@@ -1696,7 +1698,6 @@ static struct usb_function *ncm_alloc(struct usb_function_instance *fi)
 		mutex_unlock(&opts->lock);
 		return ERR_PTR(-EINVAL);
 	}
-	ncm_string_defs[STRING_MAC_IDX].s = ncm->ethaddr;
 
 	spin_lock_init(&ncm->lock);
 	ncm_reset_values(ncm);
-- 
2.51.0



