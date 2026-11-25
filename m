Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626257;
	b=WMQcjmsjEXovSKuch5HDHpnGHmkuf/dtCMSWKwar7p0XklOrS80HWPkcZgKJaNgOeR1g
	 gJ6vgxn0CVQmYiAgROj3DxLPxokp3+20/LVfoyryLza/7saMCDS/jQw0ygLC1Cf7cYFjq
	 99JqOggqb05mIYnu504P8CfSEVm4tzD9RMeI2VMeBYheL8RO/FIatEQhuUvDJyWVvMwR3
	 jsHjKlx6eF27WBvjy2a2UMjB4uBFzTBeWqrXBm7Inbp8da21Vzj7I+jst1Gj51W2EyXl+
	 T9XPNM9kWPysSqmP6NHhryQoyx0VWHECvyVB+wxianWpAJV26GrJdzWYwJMqXuAfPnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Szt3H1QKy7SaD65PB6rqrikQOEpjseNWDibweoJ8/M=;
	b=AGM7Q50NvrU+bOPOLmf2nzX0PJ0F6cKB7fnUb+FyBCky9DSnx4eUV28/BrBy6XrsDUVr
	 0KFknspPAgT27fKfFiPS7Ro+lDFVwApalavEjKeb6CZSDGdJ+3+8Fly0UoouI0ZJgm2eD
	 VIZAJEXi/K4rf0dWf05S2/P3Ih/xbBs4wxi6If60exOTrmj44UuQVZE/ojqcN8FdQ4j/S
	 hE+Oqn9Zx4LonIb+c+OpNOufMKzo7KjECF7cexOkpR/8mdNP2kqXmsNv/yc+ohUGyY1jd
	 CHrOmbqc7dV1ck59lo62DzoTg/c3AfLUk1Bd1zon2fvM5ZBw8LeAEellJcX0qXbBQHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GLn7WDAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46E3606A321;
	Wed, 25 Nov 2026 17:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GLn7WDAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6D41F000C6;
	Wed, 25 Nov 2026 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626257;
	bh=/Szt3H1QKy7SaD65PB6rqrikQOEpjseNWDibweoJ8/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLn7WDAfbPnygj3dQlvlbkFiF4l5lGmC0ndczv3yn5MvplhapbivcqPef5SMgupyx
	 wLCH64mLRXcdFAhBEJaCoI6eQqhKr/f8NvctkCfBiaXkyjhfXGmnpQvL8Gr1WRpB0i
	 cvNWKDAsjWFn+mhFQY76IVXddzZCPVgGNEBeAGV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Amer <and.amer@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 783/816] iio: afe: rescale: expose offset if rescaler or source has one
Date: Wed, 25 Nov 2026 15:38:51 +0100
Message-ID: <20261125143907.298480845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Amer <and.amer@gmail.com>

commit c293f0db308fe76a0a9b0f6674cd2dea149b03aa upstream.

A rescale channel advertises IIO_CHAN_INFO_OFFSET only when its own
offset is non-zero. A child rescale therefore hides a source offset,
and consumers apply raw * scale and drop it, even though
rescale_read_raw() folds the source offset in.

Expose the attribute when either the rescaler or the source channel
provides an offset.

Fixes: a29c3283653b ("iio: afe: rescale: add offset support")
Signed-off-by: Andrea Amer <and.amer@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/afe/iio-rescale.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -304,7 +304,8 @@ static int rescale_configure_channel(str
 	chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
 		BIT(IIO_CHAN_INFO_SCALE);
 
-	if (rescale->offset)
+	if (rescale->offset ||
+	    iio_channel_has_info(schan, IIO_CHAN_INFO_OFFSET))
 		chan->info_mask_separate |= BIT(IIO_CHAN_INFO_OFFSET);
 
 	/*


