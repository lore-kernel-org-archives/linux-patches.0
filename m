Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EF45678EC;
	Wed,  9 Sep 2026 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962356; cv=none; b=LR4HXNLURIP7l4wUeaCWDAp4QudidRvDcRgcU9vBY9cru9YFX4Ac6BKCN2361y8MXcRQ4doiF0DehxV/p08tN07uDXe5x278Ka4+fidityAfIMwFMeZDAdcROg7SNiDucrE+ewVDaJ+3fTsDH6KxoRBqlX3EB+jfHLCETdh4fgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962356; c=relaxed/simple;
	bh=YGP4WFVMvDerqnSO4SapM2PR5b65GHPFmFA6HiBz9no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2A9l8mXh0FPweb0qrcCS1wKq6A6mS/cWhnMejvrqhHA5+hrabeT7X0L2U0TfkWF3mxo1rzRap+frQrKN31a2Y0pzq/Xmg/QJ0Uxj9Y0fU0rR/+f358q/qJyeozVbOFxubdo1muxNveBQfAv4kiDTAGrpNC0iov0p3SgqziHlpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qJifDEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qJifDEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7981F00A3A;
	Wed,  9 Sep 2026 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962355;
	bh=cfSLdMBu4nWy359fwCzlwofwlyT5WUjHiMYtFDWrQks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qJifDEY2lF0dWJFVJe7veWu2waxz3M8oUG0SKvTQPJExctkcczq+LFcxiA5WAinU
	 l+9/7BNNLNilF54l9j2oAk3Zxu/IBqezBlWdOtXoNGK0SuGLmr/RLlD/NKaxkjKeib
	 9PBSMM5NxnkK0D5/yE+hVuArfia98ZBn87d1+Zwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Matteo Martelli <matteomartelli3@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 263/556] iio: adc: pac1921: fix wrong channel used in trigger handler read
Date: Wed,  9 Sep 2026 15:39:03 +0200
Message-ID: <20260909134239.792814099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit 3364c56b20c1c496bdb8c8df32f96a9947dbf98e upstream.

pac1921_trigger_handler() walks the enabled channels with
iio_for_each_active_channel(), which yields the scan index (bit) of each
active channel, while ch is a separate counter used to pack the samples
contiguously into the scan buffer.

The register to read was looked up with the packing counter instead of
the scan index:

	ret = pac1921_read_res(priv, idev->channels[ch].address, &val);

pac1921_channels[] is ordered by scan index, so channels[bit] is the
channel that is actually enabled, whereas channels[ch] is merely the
ch-th array entry. These coincide only when the enabled channels form a
contiguous prefix (e.g. all channels enabled). With a sparse scan mask -
for example when only the power channel (scan index 3) is enabled - the
handler reads the wrong register (VBUS instead of VPOWER) and pushes it
to userspace as the enabled channel's data.

Index the channel array by the scan index (bit) to read the correct
register, keeping ch only for contiguous packing into the scan buffer.

Fixes: 371f778b83cd ("iio: adc: add support for pac1921")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Acked-by: Matteo Martelli <matteomartelli3@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1921.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/pac1921.c
+++ b/drivers/iio/adc/pac1921.c
@@ -1037,7 +1037,7 @@ static irqreturn_t pac1921_trigger_handl
 	iio_for_each_active_channel(idev, bit) {
 		u16 val;
 
-		ret = pac1921_read_res(priv, idev->channels[ch].address, &val);
+		ret = pac1921_read_res(priv, idev->channels[bit].address, &val);
 		if (ret)
 			goto done;
 


