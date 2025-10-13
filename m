Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BFF257828;
	Mon, 13 Oct 2025 15:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368400; cv=none; b=X0advcXpgu2LjER9mfDYyVCYUTCw47Jv4kiH96ED3QRIDEQHsrF5fyUGH+ouk+BbjxZS7I9YRfHCBd/ZhkaJBRrnM/syf8lBHhEIs6/h4f7hoXh4HjJTelCWI2SnFk4xYYW2vgBB/m8aNs1D300cYT2JPRhY4IasvKjPXgzlyDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368400; c=relaxed/simple;
	bh=qn4FoQrJsvDaVm4GWnlT1tN2lvRuFYTXYuD8HDfg03s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WI8qHkZm4WMNH/RqPD5Lxad0Z7cSUb9LixmXS1wu4yViwYtQsTOXxbyl5PWPpQiu4uauh/P2mZe9ENzpwDl7tpL0vOq2yosG8d1XeGD09Of4g83tgCJdbp+KcoqU0ZaCaJ1Y2wXKS7WEZu/mOI8mVkd7IfAr3dW3GZEzor9FGig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3RO43yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3RO43yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5E7C4CEE7;
	Mon, 13 Oct 2025 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368400;
	bh=qn4FoQrJsvDaVm4GWnlT1tN2lvRuFYTXYuD8HDfg03s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3RO43ydi446X8UVe4XLU3/HdOAsmaEyl3mKyela53brJnv5qYFiCL/HTXL3XGZgX
	 97Zd/XV5k8z80pjIIyzf5UV1CgJnBJCPSvc8fCgE5oovVCogXaE0Y+WIo2n+p/Yb1C
	 RQqtO+ieqp5/JrU/AZwRB9xvJrK1/RuIR2IXJHIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Beguin <liambeguin@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/262] iio: consumers: Fix offset handling in iio_convert_raw_to_processed()
Date: Mon, 13 Oct 2025 16:44:43 +0200
Message-ID: <20251013144331.201568229@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 33f5c69c4daff39c010b3ea6da8ebab285f4277b ]

Fix iio_convert_raw_to_processed() offset handling for channels without
a scale attribute.

The offset has been applied to the raw64 value not to the original raw
value. Use the raw64 value so that the offset is taken into account.

Fixes: 14b457fdde38 ("iio: inkern: apply consumer scale when no channel scale is available")
Cc: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250831104825.15097-3-hansg@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 0f394266ff8c0..85ba80c57d08f 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -638,7 +638,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 		 * If no channel scaling is available apply consumer scale to
 		 * raw value and return.
 		 */
-		*processed = raw * scale;
+		*processed = raw64 * scale;
 		return 0;
 	}
 
-- 
2.51.0



