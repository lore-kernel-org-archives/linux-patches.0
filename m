Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704871;
	b=Qg6t/twG/pq7DXkTAACIISs2Y5j5GvEPhcfr/8s7zs6fbphsNlRqTSHOJtMnzAVrsWD7
	 pYWk7MfT0+pXsKV+b2paWucRYYu17epp9rd5tvinXTTqqeomUEGvGR9+7Quikcl/JzSZL
	 guK6G/TdS+Cioq8APh2CHBkj4+iY+43p/JtL/7B2gIVpaKlCfVyzFQPs9770rwJIZWVtG
	 /zQF3+58xUwpqwI59666HOKs22XEW2DNAi6x1ReRkGBEdjx/o/4fkrKQ9+LpWw8z4B1zo
	 k6U1nomYuSUxtgRL/JX8NNnL67n6i0KIOINRRydmuZDTc46AWgiBYUOwPRc4w6tHZvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MuwKJsUud6YMpCiYfvSx6i1CAckwwrtbyMUfptpDDB4=;
	b=oK2DmTAY6RTXDN8YfKw7cpB55jk69X+rsDP7bqB5aR3VaYgUNfToM6owjsD43Wjcpv18
	 v4WzKwbhz1WKWkoppCcMTlIb7QPhLsRHsVvZyyXvpfoKyrOt1FUNAGLD292AZ1rZyvtTE
	 cHh01b19iXANr/i7WW4/BiS5gT+gRTS6LNotm+2T48bIxBTzvc0v7R0w1VVVdqvb1J9np
	 mKFwr9Z2ZYaltp5JYVhsuFKWP6/t8e5/uDiQceSorkjBIO5xji80yhCtGTYbhyMBiMWay
	 n07ndceR6ZGN/9E4EzR/IaRX6VpopA0UMttH/zRM5/cSIJbZNzJAQ2j9WhXQaNilQGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irs5VO+B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622D2606A31C;
	Thu, 26 Nov 2026 14:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irs5VO+B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C452E1F000C6;
	Thu, 26 Nov 2026 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704871;
	bh=MuwKJsUud6YMpCiYfvSx6i1CAckwwrtbyMUfptpDDB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irs5VO+BHEl/igNxo98jQc2Gn6Bgo4+uaI343+wbbcnt+88omjCAvsYWE4wV1y4b4
	 HRaEziXDUpDj5hDxce5GXhYUoevkrCUc4srz+Qc0fwu5m1oqWQOrYvokYxSUftTStR
	 JDB2D3WpuryR+3DHU/WJAw36UM2Q96ObMzTm9xII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Joshua Crofts <crofts@kernel.org>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 243/265] iio: accel: kxsd9: Fix potential use-after-free on removal
Date: Thu, 26 Nov 2026 15:39:33 +0100
Message-ID: <20261126143622.263583812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

commit fd7334314f63a3a2a4927f209b2ca0e33d111840 upstream.

Unregistering an IIO device with an active triggered buffer detaches its
poll function. Freeing the poll function first can therefore make
iio_device_unregister() access freed memory.

Unregister the device before cleaning up the triggered buffer.

This issue was found by our static analysis tool under development.

Fixes: 0427a106a98a ("iio: accel: kxsd9: Add triggered buffer handling")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Reviewed-by: Joshua Crofts <crofts@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxsd9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -484,8 +484,8 @@ int kxsd9_common_remove(struct device *d
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct kxsd9_state *st = iio_priv(indio_dev);
 
-	iio_triggered_buffer_cleanup(indio_dev);
 	iio_device_unregister(indio_dev);
+	iio_triggered_buffer_cleanup(indio_dev);
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);


