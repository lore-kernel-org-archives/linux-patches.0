Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CF31B6CE9;
	Tue, 26 Aug 2025 12:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212669; cv=none; b=KkDnmDbUEzNftN288ihdHdyP6jWvy+ltZRxp1QULP9n05EQExK5G124FTEe+KO8TgcDXd9LSTLwguppN6mFXFCTRdi3YAlS6bN0VME8UbRT3PGwfQojefOywS+d5p8Uqr2eWp8damZA2tFE8i35x7hxRgJw1P/Q8/EYStbmWxVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212669; c=relaxed/simple;
	bh=A5GDUt7kG67QmQtp3qHalMbsARswyIyNjVSay6+QKJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kn6bwnf4jgfwE2Qlb3qqVgiAA83uGcGbTg6FJQdgPto+Es1PouU/WtsddIUyoYzby3WR2t43zEitKzuCoKWMu3HkwIVc5Vcz8iqZuNIe/D3+0A/TVfIfQXW+EqBKh3RyqEu1jbOZ6BvnG3MNHGPw5bvxSDTFb7peg10VcGKAFB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vl+UydYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vl+UydYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26389C4CEF1;
	Tue, 26 Aug 2025 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212669;
	bh=A5GDUt7kG67QmQtp3qHalMbsARswyIyNjVSay6+QKJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vl+UydYDYTkGC0jPtzyujGnW+3TSoi9XVaE+N7s7NA1e0otij9XZdpB7UN5EoVIxZ
	 wT0jhm/zyzTUE9Nim98Dp721U5qoAwPAmm9tEnBYPlXMPogGuDaVJsG0uGrwaP40XC
	 W+NEiHW1NXtMBPczhVN2Sb4wdEl7K/y05INe8rM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 027/587] sunvdc: Balance device refcount in vdc_port_mpgroup_check
Date: Tue, 26 Aug 2025 13:02:56 +0200
Message-ID: <20250826110953.641367748@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


