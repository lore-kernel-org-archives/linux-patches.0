Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9802143757;
	Wed, 19 Jun 2024 13:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803478; cv=none; b=nk9j4tu7Ktu3S1Gr/oOE170dAkPbX/V/d4ATm/JEAet4kUbpU5V3rH8wzbg0xEQpI72mx7tGBphZJxWrrGbdR2Vkx2cNvhqff6gwM2LCNygtJPI2/MOu2Vv6PaAWUiIHobA8V6pZq81kuu/zpx5N1hhPUK4pZ3JMVBHXTND3RcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803478; c=relaxed/simple;
	bh=UrhWz/oX3Eyk/G3NXJfIhsaBOYjYrJfFrquHPfc/vFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUDHahFwcm8rwzuIXahNO4nTM2LNkuoU3Zee66hx/ytXDOevS5oZh3EYV/vKJp1dboXrJ7qI2w7Ns9KzXQ2oJK4P/buYbQGdkgFMesjceCxyzra9VeJSrajD12gjC8heB/kWHs+tqlqtsMyZwTSrL6kw/s/rLt0XKp7NyN4NVMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Th7m8jYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Th7m8jYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C49CC2BBFC;
	Wed, 19 Jun 2024 13:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803477;
	bh=UrhWz/oX3Eyk/G3NXJfIhsaBOYjYrJfFrquHPfc/vFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Th7m8jYpSxhFFcptcS6wo5IstRdnMS45oQAWv3Wslkth20RYBKBUuLI8hHXNLYgVJ
	 n1qrwsoev/EcEhclh9L+JIwqZeS2CubZPDwCiCQiQn10onbwvYnFJ92fOUS3l/T9dm
	 V0I8GQBFaUVfFuaz7y3FQ17nGTatnahDrNsa319w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dima.fedrau@gmail.com>,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Andrew Hepp <andrew.hepp@ahepp.dev>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 249/281] iio: temperature: mcp9600: Fix temperature reading for negative values
Date: Wed, 19 Jun 2024 14:56:48 +0200
Message-ID: <20240619125619.545229096@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Fedrau <dima.fedrau@gmail.com>

commit 827dca3129708a8465bde90c86c2e3c38e62dd4f upstream.

Temperature is stored as 16bit value in two's complement format. Current
implementation ignores the sign bit. Make it aware of the sign bit by
using sign_extend32.

Fixes: 3f6b9598b6df ("iio: temperature: Add MCP9600 thermocouple EMF converter")
Signed-off-by: Dimitri Fedrau <dima.fedrau@gmail.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Tested-by: Andrew Hepp <andrew.hepp@ahepp.dev>
Link: https://lore.kernel.org/r/20240424185913.1177127-1-dima.fedrau@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/mcp9600.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/temperature/mcp9600.c b/drivers/iio/temperature/mcp9600.c
index 46845804292b..7a3eef5d5e75 100644
--- a/drivers/iio/temperature/mcp9600.c
+++ b/drivers/iio/temperature/mcp9600.c
@@ -52,7 +52,8 @@ static int mcp9600_read(struct mcp9600_data *data,
 
 	if (ret < 0)
 		return ret;
-	*val = ret;
+
+	*val = sign_extend32(ret, 15);
 
 	return 0;
 }
-- 
2.45.2



