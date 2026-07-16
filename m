Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060F6298CAB;
	Thu, 16 Jul 2026 14:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210533; cv=none; b=WO/hIVW+r7qdiTHoex9gLVe6Ez9Q41SMUo/zbHg66TZY3bAbX+u+JF6IpFlfTuzRIXVQhZpacE08k6tZLdgbnT872SMTn5SvFfe67DV/od6BD4dpDALAEoPl5HSIHyF/Jx1fP+RPjoztNdMmb+qP8e33b1r3cYBbLWpxAzTTOmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210533; c=relaxed/simple;
	bh=+Yi1HP8xIUH98+7BffsHrSjwST2SP+8ikoE741RL9Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugBSl5qCkbMMf/zYmAz1CgHBgLA5GYfRtgtOM7DdupUG4CIvBYmnD+K5Vsh+DWlxWDxNgFoghVJ3MltHmDXSNj0NDPQ1SRlnUrDQY+xJSDEmAOpI1VtoqHcwUK6Qusw98m5Sk38C13jM1ctojpOZIulghSIGVynmWroOglwA+jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGtGVubK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGtGVubK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1D01F000E9;
	Thu, 16 Jul 2026 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210531;
	bh=ScyRwRXnbnqDcUxAlHX/rXuulKgM7wtrDiXFX4eP9v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGtGVubKd2xHEDg+GJvsQrVLa57SL3X7apNhP3sSOy4py0CmvaV88d/VLcv2gYP62
	 Tfc88EWNYeG4r69aXkNxTqF+Qh0XLwKq0XA3Mm/Bo91ICC4dAMBesrjggOMtjtlrXN
	 i5AYZ0nvg5cr2bW6Lo1by1FaS6sWgxyw4GgiG4Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 082/480] iio: magnetometer: ak8975: Add missed pm_runtime_put_autosuspend() call
Date: Thu, 16 Jul 2026 15:27:09 +0200
Message-ID: <20260716133046.483967722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e94944d7364d3ddb273539492f9bd9c9a622549a upstream.

On the failure in the ak8975_read_axis() the PM runtime gets unbalanced.
Balance it by calling pm_runtime_put_autosuspend() on error path as well.

Fixes: cde4cb5dd422 ("iio: magn: ak8975: deploy runtime and system PM")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260505-magnetometer-fixes-v5-0-831b9b5550fc%40gmail.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/ak8975.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -784,6 +784,7 @@ static int ak8975_read_axis(struct iio_d
 
 exit:
 	mutex_unlock(&data->lock);
+	pm_runtime_put_autosuspend(&data->client->dev);
 	dev_err(&client->dev, "Error in reading axis\n");
 	return ret;
 }


