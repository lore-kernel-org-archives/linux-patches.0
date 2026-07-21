Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6985B46C4DE;
	Tue, 21 Jul 2026 18:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658546; cv=none; b=ffVLXm2NAJE0cdDol6+LjmYJzbbJVCvUer0SL7aUoSoemKOajvlJu5cw8AkTLKng1I+mKrS+lCONcVfsHTywQkppIBITiuG3IwHMi1znufQiy8SqIwS4rB3aZ5kDy34zfI7D6RJMvoW6ZiJgaf8t/nmqurokwNgDmUL3EUYF9fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658546; c=relaxed/simple;
	bh=/jjMLCTlBdCMeRKdyM9vyb2BqjHzPhdwKVZEFn7EjIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFYcUEY4MFITV79by5Ar5ZzZV6hn4KwZpATtKTfFtAbrB5x+u14p7kPRyO5uVwvR8ulOaYJmTovpTjCwLEHODjh9DAMpQYhsJuM0FHtZZkb0u6yzz2STOCJM0WuhJ4fuaIpZM7hl8hyIZa+SgML2Rn197C7HfLc0wMiVfrgXd0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOpIxceW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOpIxceW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5651F000E9;
	Tue, 21 Jul 2026 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658545;
	bh=l8GoIyLlVm21YOX44yDGGPibkZ5osi+ZEJUzUii0wvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOpIxceWUOJOQ3hU54a1yY1OpdrVcibPQ1zMVaTrbgboQldtuhmuRQfcPc2dKVV/b
	 TWj53hNS1zuFBUB17HTng3BmtGzbqB1c5SxvqJ+izfSY76Cu7muLwnUn88jl1wAn0A
	 PY72WhuTP8+wfeqpIOyQgB/8RIUqda6RON23rCN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 1184/1611] mfd: sm501: Fix reference leak on failed device registration
Date: Tue, 21 Jul 2026 17:21:40 +0200
Message-ID: <20260721152542.063603601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 8c2f0b42fc252e1bf1c7746447091a468e784ca1 upstream.

When platform_device_register() fails in sm501_register_device(), the
embedded struct device in pdev has already been initialized by
device_initialize(), but the failure path only reports the error and
returns without dropping the device reference for the current platform
device:

  sm501_register_device()
    -> platform_device_register(pdev)
       -> device_initialize(&pdev->dev)
       -> setup_pdev_dma_masks(pdev)
       -> platform_device_add(pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: b6d6454fdb66f ("[PATCH] mfd: SM501 core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260415162627.3558789-1-lgs201920130244@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/sm501.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -704,9 +704,11 @@ static int sm501_register_device(struct
 	if (ret >= 0) {
 		dev_dbg(sm->dev, "registered %s\n", pdev->name);
 		list_add_tail(&smdev->list, &sm->devices);
-	} else
+	} else {
 		dev_err(sm->dev, "error registering %s (%d)\n",
 			pdev->name, ret);
+		platform_device_put(pdev);
+	}
 
 	return ret;
 }


