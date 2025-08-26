Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3242B26B747;
	Tue, 26 Aug 2025 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214990; cv=none; b=KBxI0kkuFdcCfIBCKYDvQbAfYP3QotdqX/VRGV8w6Hs7KI3MmEyru1AEmKkQgBD0RMqtH5V0Wwa7SfJ0IcV/U1xTKKOoPeuSTFMaKpD8BcOOLdgMLLG9KxKz+gnH1seXqoH+ujLKgV3DsgZvRvx3TFDwwpvIyS7C/7qUV3DbSX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214990; c=relaxed/simple;
	bh=Ef6V15cxSLNYOwlCGH+A171eu0yhmq8mki+NixvC6qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8695DYLqZVJxcOTax6q7Cy1DGdXxd1EVKzeHJSV6V1EXXZRRZlokf5uoRjPHbrqAZiprH7GKCYnd/7fseozuTFqa0KhH9X+ck8UnO8G4b+9AEGf0Vf8ZC1SJtwcdSHY4luGrBqRodaihTpbw4HG33LzNAoxRKmkBevXcZXgiiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoqDBuLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoqDBuLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD4AC4CEF1;
	Tue, 26 Aug 2025 13:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214990;
	bh=Ef6V15cxSLNYOwlCGH+A171eu0yhmq8mki+NixvC6qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoqDBuLQ6gbFn/h7oUhZaRny4CYEy8rorJPmfwqHPo9J9pAWs4Fk7DKV3EjjHA7/n
	 sKfYUyJ4fkcTOvPxi2AJXK+Wv6oCbUu8qE+WJZQO0W8jr04cZoAmT3mrghb2Q8bK0S
	 Ztd76kN7HztH8Cmup/z6GpGDc6EjpfYI0NF4MLZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 345/482] iio: hid-sensor-prox: Fix incorrect OFFSET calculation
Date: Tue, 26 Aug 2025 13:09:58 +0200
Message-ID: <20250826110939.351344359@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 79dabbd505210e41c88060806c92c052496dd61c ]

The OFFSET calculation in the prox_read_raw() was incorrectly using the
unit exponent, which is intended for SCALE calculations.

Remove the incorrect OFFSET calculation and set it to a fixed value of 0.

Cc: stable@vger.kernel.org
Fixes: 39a3a0138f61 ("iio: hid-sensors: Added Proximity Sensor Driver")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250331055022.1149736-4-lixu.zhang@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ adapted prox_attr array access to single structure member access ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/hid-sensor-prox.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -103,8 +103,7 @@ static int prox_read_raw(struct iio_dev
 		ret_type = prox_state->scale_precision;
 		break;
 	case IIO_CHAN_INFO_OFFSET:
-		*val = hid_sensor_convert_exponent(
-				prox_state->prox_attr.unit_expo);
+		*val = 0;
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SAMP_FREQ:


