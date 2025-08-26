Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAC42BEC45;
	Tue, 26 Aug 2025 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217696; cv=none; b=ZYM3Ik+j1ZWxzyY8WRzOxo9KbOiVfwDkfIZZgn7mPqBmjCXX+byKknQXs3VnCrxPIXoIg+hoQW/o1P+mWnsgGmZGiWT5cnF3tL1F81g6ZppuSVBGqY+kRaJyMW+6J9aE7ykYIrORpkntcjTzlIZTYsskv94GaK6HdtNVbv4Z+xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217696; c=relaxed/simple;
	bh=cvpdV7MvMEjtjg71HLkHKSqFOgzo1wp93HtFwTsPh/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ngc/LTLT1FWV3cy43uqRVdD7tgFJ6p6TemWd47w1cv4+KjFyRPTHOsJokHW2Kw/E75aWPJGcZDemf6U+YxCJQC+WsIZ04RZm0OGHJU197dd6IATKtXzhCf9iVt/FU8qBG7DSQQx6nJeIfsxmusUmXVG4yT3CTScVfMfhjypnviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlfVgrPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlfVgrPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C896C4CEF1;
	Tue, 26 Aug 2025 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217695;
	bh=cvpdV7MvMEjtjg71HLkHKSqFOgzo1wp93HtFwTsPh/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlfVgrPEDlxdufqdOuYCbmNarI8lwLYSg0DVr1dNeKWbVsyckUwXS1pmS5V73O11d
	 1C1CbBdHNWT7/2XvjY7HZox/kUGVv0qWXRNmrBEgVPgsJbdiFIOYrfMU8kReFmL9px
	 si8BLLN/0c+PdTdOAgDZfOPQ26YxNYXE8JHX5Qdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 200/523] sunvdc: Balance device refcount in vdc_port_mpgroup_check
Date: Tue, 26 Aug 2025 13:06:50 +0200
Message-ID: <20250826110929.381602883@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -968,8 +968,10 @@ static bool vdc_port_mpgroup_check(struc
 	dev = device_find_child(vdev->dev.parent, &port_data,
 				vdc_device_probed);
 
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return true;
+	}
 
 	return false;
 }


