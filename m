Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E931746EF88;
	Tue, 21 Jul 2026 20:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665301; cv=none; b=N8jhFZI+kO3FKcRAD3MEnVZW0IUJysNV0+klnoJ+pIctkAnkBMEmO5CP5HrTI+Felg813tLxoY8HiIEyJ0coQcp8S/2aX6T00zANsSNNEwj28FzwFvMXY3a4NCqch+9sdrwD+2wDkiTmgttlMcoYLCccNHjM/LI+BSsZ3kCeCCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665301; c=relaxed/simple;
	bh=r/987kaMUUiAVubug6hBYhjR3qatdH6yZNK54r4kdDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/By3tsClUJoHsVJbwlMg13jy0PmVPBe2c0JOdtkontuQkdyPdKgdoB4VsbSl2DAskkjJ/xsGVzzvbYL8XLOuMIDq7LJJ+KOTH/YG8LPOUWgEYGRkizOvFnKLOWG4sFQpUNnEZSRj8WVjND4lFqyuU/wk4J9jap8ddKmTy/8MjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeUY5o6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeUY5o6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B37B1F000E9;
	Tue, 21 Jul 2026 20:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665299;
	bh=vHb315Z6lcavjKplLzkmE5IgZEjGlCwwuCNtSztZK94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeUY5o6wX4jQtX3VrpiRIIPjGk6W+Eiu6S5suY4vio2hHf8L42wwII9vdWp7K8Hzw
	 59iMWHkuie22gT9MNNSOTogX27K6EnrtuhlchCJWeqFuS6buDtCujn6DR3mhFiLVWU
	 lh0NB5EBSsecEGirQLVYo7dGfmNnh+BNVbPo1nyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.6 0252/1266] usb: typec: class: drop PD lookup reference
Date: Tue, 21 Jul 2026 17:11:29 +0200
Message-ID: <20260721152447.452280941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 43ae2f90b70cda374c487c1639a01d0f14e5d583 upstream.

usb_power_delivery_find() wraps class_find_device_by_name(). That helper
returns a device reference that must be released by the caller.

select_usb_power_delivery_store() only needs this reference while calling
the pd_set callback. Drop it once the callback returns. Otherwise the sysfs
write can pin the selected USB Power Delivery object and prevent it from
being released on unregister.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable <stable@kernel.org>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260702191329.2648043-1-shuangpeng.kernel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1277,6 +1277,7 @@ static ssize_t select_usb_power_delivery
 		return -EINVAL;
 
 	ret = port->ops->pd_set(port, pd);
+	put_device(&pd->dev);
 	if (ret)
 		return ret;
 


