Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F13919049B;
	Mon, 23 Jun 2025 21:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715467; cv=none; b=PbleZeSx+tc/1ozo/eXA1Jnw7j9Aanl/yfWKW7299ye6nEXqXTF3R5s5X9ks9WrNl27FpVV09WLOrZGRpzdkKEnVluLHz3CooAA38cu6uU3FhEOFiYqgDy+7oFDBTED2561cQCDDlkY6M8OTmis7xoe/a5cHklzWbS2K6/W26kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715467; c=relaxed/simple;
	bh=p0ExdGpuZZBfa82pyDPiaoeY8MCskl+XGbYeaCIUHyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FktLpKfX0qMhIlFQj50ZYc6X93+/705BzXk7By4eIaa9KM7qNMD3KAIOlOg0ypIQVSrw34rop1DkclFq1iDko1pld1ldQkfPhpM2eXrJYPQ3/S+Cq331lKfuMqqWH+eXaAZUSqH+q6Egh9HuGahIVmZgSgRUnHvowhJsinmnHcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6ICDhfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6ICDhfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06829C4CEEA;
	Mon, 23 Jun 2025 21:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715467;
	bh=p0ExdGpuZZBfa82pyDPiaoeY8MCskl+XGbYeaCIUHyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6ICDhfpqxYtzDZi7MF/C4sBMtBaS7q9V65oebqg/M73I59OpSTGUd1ZP6Gt+Lzp+
	 MqjM73oHSOqeErXkZEOQ1AVqky9xF9/j8iE5WSNyVoFkIJZfsBu+UMQN5OrHFIsau0
	 oExmuDtzwsxgQf4jwoxE0EmvJNoQIYBPsh+4nhnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 163/414] iio: imu: inv_icm42600: Fix temperature calculation
Date: Mon, 23 Jun 2025 15:05:00 +0200
Message-ID: <20250623130646.111249585@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit e2f820014239df9360064079ae93f838ff3b7f8c upstream.

>From the documentation:
"offset to be added to <type>[Y]_raw prior toscaling by <type>[Y]_scale"
Offset should be applied before multiplying scale, so divide offset by
scale to make this correct.

Fixes: bc3eb0207fb5 ("iio: imu: inv_icm42600: add temperature sensor support")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20250502-imu-v1-1-129b8391a4e3@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c
@@ -67,16 +67,18 @@ int inv_icm42600_temp_read_raw(struct ii
 		return IIO_VAL_INT;
 	/*
 	 * T°C = (temp / 132.48) + 25
-	 * Tm°C = 1000 * ((temp * 100 / 13248) + 25)
+	 * Tm°C = 1000 * ((temp / 132.48) + 25)
+	 * Tm°C = 7.548309 * temp + 25000
+	 * Tm°C = (temp + 3312) * 7.548309
 	 * scale: 100000 / 13248 ~= 7.548309
-	 * offset: 25000
+	 * offset: 3312
 	 */
 	case IIO_CHAN_INFO_SCALE:
 		*val = 7;
 		*val2 = 548309;
 		return IIO_VAL_INT_PLUS_MICRO;
 	case IIO_CHAN_INFO_OFFSET:
-		*val = 25000;
+		*val = 3312;
 		return IIO_VAL_INT;
 	default:
 		return -EINVAL;


