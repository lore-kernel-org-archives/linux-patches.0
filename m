Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE4421ABDC;
	Tue, 26 Aug 2025 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216142; cv=none; b=G/zTPzT0yP9yIcmVhXd63cE7R2qzqHY+q0TMZFvvx8ukWBj1BeB94htE1rKlZoQfirCWARIl/sj/qrtCkBMb88Bx2+DazxZu9K0twkpsM9q3N2x3vED59tTPU0K0JtlahdaTGEvxRNabeTJTO3r1AYcvwi6PmlE5p5AV05EICs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216142; c=relaxed/simple;
	bh=xkmVAjN+vkVTiyrNUpM7dZgjvNWAWnBI3PRoNu3Zwaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U9E+gZ3yHqbUxj3o2JQz4Y3+xCSHg/hcq5MYbHt/pVD4fBX6K14DIuk2b2zc/P5F5zUwB8Trponj4Cs6Idd+ipQCrrtISMutXsDqe5ZQeP2VP2Sj/+ANHJJmiWrSWWvMP3T0tnTHt4fyjx+REXMLeEYypRGbkBAPg4fvj2/fhyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fqvm1kNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fqvm1kNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9534C4CEF1;
	Tue, 26 Aug 2025 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216142;
	bh=xkmVAjN+vkVTiyrNUpM7dZgjvNWAWnBI3PRoNu3Zwaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fqvm1kNv53I01vNdLXW4B7G21Rz4eclTAS+n8ymW+Um/KLGy+Qc8VKlc1ftgYwzXK
	 /1ioj4C2d2FxlJ/3eM1rQQ6wRnKsLXi2/Dll3yf0Na6u8OGEmnykTSGW7xjGASoOfp
	 oYDIunkAGeyy3jeNrhETiM8wGU+4BItlVS07oDwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 268/644] sunvdc: Balance device refcount in vdc_port_mpgroup_check
Date: Tue, 26 Aug 2025 13:05:59 +0200
Message-ID: <20250826110953.013726536@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -948,8 +948,10 @@ static bool vdc_port_mpgroup_check(struc
 	dev = device_find_child(vdev->dev.parent, &port_data,
 				vdc_device_probed);
 
-	if (dev)
+	if (dev) {
+		put_device(dev);
 		return true;
+	}
 
 	return false;
 }


