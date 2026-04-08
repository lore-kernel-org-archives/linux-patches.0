Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BDD35CB6F;
	Wed,  8 Apr 2026 18:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673302; cv=none; b=DO2lYi4i7bXS9tUXhdrRJ4tfSI/CARYFuie9T1J3nwXlMAcfHE7eXgvake7h48V5ENcP14MtDaYhVedy4xlA/5dS26EXR4iC6pRjd4VUpJy6N4jobgjngnN1wtHntqOeq3GD/waCK+pjHIBN1qhLoXIRfheaHVG85fDrWZOUjB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673302; c=relaxed/simple;
	bh=CW1n9OPL/wOcxzt3gwu4gc7MBFS3AgzPLxCrERmmniY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSJ0QGp6hT2bAQqXmTx1AQXs1X/0JFQbok6sGI+zibN7Byki0K5SB2Xx2Nk3yBDkaShSE+xhf6PPWUlDZ1rfRHHCzAt1rbk6QV829xb8gpKktxdEdQI4AU4WGYPMXsZKloTR6o3mkiU9b1oLzQs5cONVafUoiMON7Mx6tmWmncg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kufXaunS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kufXaunS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD6DC19421;
	Wed,  8 Apr 2026 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673302;
	bh=CW1n9OPL/wOcxzt3gwu4gc7MBFS3AgzPLxCrERmmniY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kufXaunSK/WfuKfU2CyvniYadYsgSTw52D6HPPG+M54L1gYjtEJ0MWjU7gUJF4Wd1
	 SYouf36w/6OHzTHV2mRmLf79YM9lkpW8O84yeEIr+1mUydia+CIl6wN8Ez9IU0yv1+
	 uy/eCF/X2jJEnbNY9nS65j1O25zZtBPMeiSQJcPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 178/277] iio: adc: ade9000: fix wrong return type in streaming push
Date: Wed,  8 Apr 2026 20:02:43 +0200
Message-ID: <20260408175940.511810052@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>

commit 57b207e38d414a27fda9fff638a0d3e7ef16b917 upstream.

The else branch of ade9000_iio_push_streaming() incorrectly returns
IRQ_HANDLED on regmap_write failure. This function returns int (0 on
success, negative errno on failure), so IRQ_HANDLED (1) would be
misinterpreted as a non-error by callers.

Return ret instead, consistent with every other error path in the
function.

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Reviewed-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ade9000.c b/drivers/iio/adc/ade9000.c
index 945a159e5de6..1abbfdfcd554 100644
--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -787,7 +787,7 @@ static int ade9000_iio_push_streaming(struct iio_dev *indio_dev)
 				   ADE9000_MIDDLE_PAGE_BIT);
 		if (ret) {
 			dev_err_ratelimited(dev, "IRQ0 WFB write fail");
-			return IRQ_HANDLED;
+			return ret;
 		}
 
 		ade9000_configure_scan(indio_dev, ADE9000_REG_WF_BUFF);
-- 
2.53.0



