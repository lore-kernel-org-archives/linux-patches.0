Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207CB4307AD;
	Tue, 21 Jul 2026 20:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664895; cv=none; b=u3eAnU8OQp81XITGRsuTk5IaqM2Ftx0RLbSVIhhzXggfHILr5OFoyUrHnYCtQy/m1/JP65ike6afyhguFRbq0yMMEPv9HUPFYbRvEnB0Hw+KRPWObYSrFne3MO5iixjIvip/Lvmxn0m3k1/oliBHg+RqO/C9lGIkOt/LylL42jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664895; c=relaxed/simple;
	bh=oWKrxSwIxbLn0FFwEP0OTYqejR0zshuzIPwAXjywtic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5XznKpi7TN4p/ORZBvMJLjuMjHf5DYTFqftDy70mQWsuFXE0jExbsByhHH8+SPeircs+fXAm2wDh7TTXdvtNOKDcxSbpjc1fdPFD1kpvsIsboHfkZG81EMHgQu/c8wqF+Qdurbc1tCEnpxlrnWuiv2/OodioxqQWoR5bdL5/cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/fGETLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/fGETLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8097B1F000E9;
	Tue, 21 Jul 2026 20:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664894;
	bh=w5mSFFIRY0Ug1ThxnKceboFZT/s4r4V8xPsTE5sFtaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/fGETLJwIwpEy8Lsl81Zdipvfk4WJqk8jY0a1MVXU7f9mOwIMYmmjZ35pr4QrFjF
	 RUW/AWukWhonP1FLcBGLujVPTNBUvvPEUBC0ldAo1UvKbK/ATsHHESWoFG8WkR0NZz
	 O8bAAJAeYseXkuUpmtVhWuySGcW5S1Ol/0dHnXIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0100/1266] iio: magnetometer: ak8975: Add missed pm_runtime_put_autosuspend() call
Date: Tue, 21 Jul 2026 17:08:57 +0200
Message-ID: <20260721152444.041310312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -746,6 +746,7 @@ static int ak8975_read_axis(struct iio_d
 
 exit:
 	mutex_unlock(&data->lock);
+	pm_runtime_put_autosuspend(&data->client->dev);
 	dev_err(&client->dev, "Error in reading axis\n");
 	return ret;
 }


