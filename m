Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B93198E6A;
	Thu,  6 Jun 2024 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683426; cv=none; b=YhstKj3kLPUWMFbx3PwVNiCB4/jJrNpFk7RzS0C+1BdJBX0OPTXRPQ2ybH/XHzW/WhJwdbtC490Fb8sYLjKJXKM7aIDyZpiKUN7RNKZtsSRhb4aFRyJWV1Q5nDPRNwXl+WkQzZ70U+/byifC7F4IRoPjdjmTloL6jCuIjfWNlpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683426; c=relaxed/simple;
	bh=k+l3mWykUKeQdX9XpR+pgJsC4VA8nVNfCXd2UQizCuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edjavY1JLHBP+D/haptd0LJVke0Tt1IQGS6U1ICwB/0sVkUxUlh/CpbAXcYPfPNgWySzbzQAsSR1fc351tZpjB1e98dTWcu4L1HTxe+VYeWZ7TXA+1DgV3bCfdfjM9xri3l8uLfSrVMN7yAG7pd8c+BH0HUpwrCza9rU3WGgLd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqgRGMNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqgRGMNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E044C2BD10;
	Thu,  6 Jun 2024 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683426;
	bh=k+l3mWykUKeQdX9XpR+pgJsC4VA8nVNfCXd2UQizCuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqgRGMNtSAjojDlObqYsQD6RIH9WgAI8BqlgUOQ/LdXxUt5m5W8pXE7WbMnXkxPA9
	 3tYSFMECTUXhwG2bD7R5hY43Upd5wAxo/VunRuRvl7FimU+S6RmGAETBuHrkghojAt
	 wQSwAVPdgbARWr2WlkqGCvgrRzQ57+qtadYsZ0WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 312/473] iio: adc: stm32: Fixing err code to not indicate success
Date: Thu,  6 Jun 2024 16:04:01 +0200
Message-ID: <20240606131710.259680081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 3735ca0b072656c3aa2cedc617a5e639b583a472 ]

This path would result in returning 0 / success on an error path.

Cc: Olivier Moysan <olivier.moysan@foss.st.com>
Fixes: 95bc818404b2 ("iio: adc: stm32-adc: add support of generic channels binding")
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20240330185305.1319844-4-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index a5d5b7b3823bc..6fede34091cc2 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2079,6 +2079,7 @@ static int stm32_adc_generic_chan_init(struct iio_dev *indio_dev,
 			if (vin[0] != val || vin[1] >= adc_info->max_channels) {
 				dev_err(&indio_dev->dev, "Invalid channel in%d-in%d\n",
 					vin[0], vin[1]);
+				ret = -EINVAL;
 				goto err;
 			}
 		} else if (ret != -EINVAL) {
-- 
2.43.0



