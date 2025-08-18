Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755EB27B330;
	Mon, 18 Aug 2025 12:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521475; cv=none; b=fK8fX2cewA5ribkZfmkz0mqsHUJuodRtFeSQ7HIFJk1ERAbH2S55P77dj6pVMor31HE4LG79siuwXEWuCGivaAPfclrOxK+BhzwufEuR7OLvjqTUOWgkoKPHj5Ra6NGsSGVV0eCn+XiKs1JTGqFbBVPrxGr3VumnFfx7V//nxgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521475; c=relaxed/simple;
	bh=INLHhBunOG8qDmAtIy1xKfpi75YaDcukJy/KGzfr1IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RKGl6czR72ZqdO7/WAkUtHTc8eWRiii82tblw45zP6UufZIY9CyCw3h7oGXBePjUw6xCa2wU8yk9w4g8iMPsXEnDHirxJcts2tnJndJSjwElMo34HOMfoi5Cgpht5DZfE2N2RpY6Xd5H3JSvHW6DvO62XEUpq44+A9HkSGKPYKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhgtJiL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhgtJiL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA076C4CEEB;
	Mon, 18 Aug 2025 12:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521475;
	bh=INLHhBunOG8qDmAtIy1xKfpi75YaDcukJy/KGzfr1IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhgtJiL5Ck9pTDovH6N75OKwwJ1d+rfCB6zUkPCOx9dOud91GQDfdg92E3EGveKVo
	 Vnml7V6BJgKMfw4DYxm1oIOa6ZXhfJQBsPKyHcVHKwheAjcqi2YXI3NDvlRRewsLcq
	 RRJ9gx4vG+52jJ6AyNxfprp4cUMXQxKuYtE7v0sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 031/444] sunvdc: Balance device refcount in vdc_port_mpgroup_check
Date: Mon, 18 Aug 2025 14:40:57 +0200
Message-ID: <20250818124450.096382361@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -957,8 +957,10 @@ static bool vdc_port_mpgroup_check(struc
 	dev = device_find_child(vdev->dev.parent, &port_data,
 				vdc_device_probed);
 
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return true;
+	}
 
 	return false;
 }


