Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FC9246790;
	Tue, 26 Aug 2025 13:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214126; cv=none; b=ZfLzD9w/Pl4VFJ8b7N6uKM8RFrYOlu9Hkn4qWhLe/hIFA4tOwswscq5luEu2JLdgXTDGeEtBLOYuQjCDGBidSNIqFMNBmAtHqoV6UQa3VMePjBHBwtmN9GtaNWQLh5X7lNHPbkVmZcOq+mD4iJEwXATqoVAvt/MviVzQhNnAdX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214126; c=relaxed/simple;
	bh=LQzHDC7RM9afT6NCjKW4akwK3EVY4lXk79GGMvATgEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=clOlFq59FPz0k2Rti7jJRCW+IXSbnfS3QGJ6o2llmpTOFCrkrIKgcMrvKhREr+RCZqUbOg9K6akbWX2jeXyFuuwrtdT9498MqMvKVpshhL/k1w8x+zVHFedn0XC/ez3YEWGd6J3jFGTpieOuFYXat+LZTCYttIITnGKi+WCUsWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xln4iV+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xln4iV+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2CAC4CEF1;
	Tue, 26 Aug 2025 13:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214126;
	bh=LQzHDC7RM9afT6NCjKW4akwK3EVY4lXk79GGMvATgEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xln4iV+W6QePsmfd/qpcIbD3xRBPffSTH3UeFE3rAEi5gL8XVO1U0F74tpeZbVM5K
	 MgsONq4OkJyrlY3oXsD+1Ylm5Ie954MsoMaX0TxFCqlDFDmCgBYw7rVPfzl7NsAOTa
	 1pAp/iJZ/Nmf1ZPYzI+cCgTvbJPyZDUvUC8Fqu8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 021/482] sunvdc: Balance device refcount in vdc_port_mpgroup_check
Date: Tue, 26 Aug 2025 13:04:34 +0200
Message-ID: <20250826110931.314085390@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 63ce53724637e2e7ba51fe3a4f78351715049905 upstream.

Using device_find_child() to locate a probed virtual-device-port node
causes a device refcount imbalance, as device_find_child() internally
calls get_device() to increment the device’s reference count before
returning its pointer. vdc_port_mpgroup_check() directly returns true
upon finding a matching device without releasing the reference via
put_device(). We should call put_device() to decrement refcount.

As comment of device_find_child() says, 'NOTE: you will need to drop
the reference with put_device() after use'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 3ee70591d6c4 ("sunvdc: prevent sunvdc panic when mpgroup disk added to guest domain")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://lore.kernel.org/r/20250719075856.3447953-1-make24@iscas.ac.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/sunvdc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -956,8 +956,10 @@ static bool vdc_port_mpgroup_check(struc
 	dev = device_find_child(vdev->dev.parent, &port_data,
 				vdc_device_probed);
 
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return true;
+	}
 
 	return false;
 }


