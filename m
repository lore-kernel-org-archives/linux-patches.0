Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3318F313E10;
	Mon, 13 Apr 2026 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098895; cv=none; b=ZZYQKNN38xHMxaUAPwnG2Ut7EJEJbEJCr5u9DyswvPD2nslRR9T+ng8oh4OtS1n/xJ7awMy7b33WyrgwkGEM1oVtLIrCOPjsahdR4FG3RBaB9TSvmGPizpC0ZZu9R/DiLzHIUuOgfSytmL4yug/0W/ezDBw0lcWMgO3H/lh+UVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098895; c=relaxed/simple;
	bh=47UcZBddRIkw8UjjtLg4uvU6y7fIfY999LIPMUWx5YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Au3KBawV4hiFs0gRTdj0FWOr4ID7d4vNbbRm54b6oYcpp5wIsfUuMWzLd/oqOpKxU8kVQNNDoaxoTr+WrQBAt0pnPCA6ZzxUaBbscMD54sVKergbEsskLHKT8nFqGlXd0WzasYIYvvhftTpx22JFVjiWTB+WB0F3c7PZUQCyPLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrPsa7s6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrPsa7s6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870CBC2BCAF;
	Mon, 13 Apr 2026 16:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098894;
	bh=47UcZBddRIkw8UjjtLg4uvU6y7fIfY999LIPMUWx5YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrPsa7s6cnx/yrCF7JW1dqtKADSA3WdwnCHSWv1T31jGawB6cZOilDp8zdI96BU44
	 akDNQzvlaMa1Ads2vZD8F8PYFzQAF21aMFjWjwg+VO2qnwrHv3MhvY+EGEonBK8SpR
	 jZzeCo1sfhf2r5EeXJgXpCre0ughQLtI42XQuvo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lukas Schmid <lukas.schmid@netcube.li>
Subject: [PATCH 5.10 130/491] iio: potentiometer: mcp4131: fix double application of wiper shift
Date: Mon, 13 Apr 2026 17:56:15 +0200
Message-ID: <20260413155823.908312077@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Schmid <lukas.schmid@netcube.li>

commit 85e4614524dca6c0a43874f475a17de2b9725648 upstream.

The MCP4131 wiper address is shifted twice when preparing the SPI
command in mcp4131_write_raw().

The address is already shifted when assigned to the local variable
"address", but is then shifted again when written to data->buf[0].
This results in an incorrect command being sent to the device and
breaks wiper writes to the second channel.

Remove the second shift and use the pre-shifted address directly
when composing the SPI transfer.

Fixes: 22d199a53910 ("iio: potentiometer: add driver for Microchip MCP413X/414X/415X/416X/423X/424X/425X/426X")
Signed-off-by: Lukas Schmid <lukas.schmid@netcube.li>#
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/potentiometer/mcp4131.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/potentiometer/mcp4131.c
+++ b/drivers/iio/potentiometer/mcp4131.c
@@ -222,7 +222,7 @@ static int mcp4131_write_raw(struct iio_
 
 	mutex_lock(&data->lock);
 
-	data->buf[0] = address << MCP4131_WIPER_SHIFT;
+	data->buf[0] = address;
 	data->buf[0] |= MCP4131_WRITE | (val >> 8);
 	data->buf[1] = val & 0xFF; /* 8 bits here */
 


