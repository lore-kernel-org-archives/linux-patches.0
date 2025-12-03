Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0338732C92E;
	Wed,  3 Dec 2025 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777019; cv=none; b=Z5/4FlRd988z/sjDTCZlnloTrs0WRY1pcwqhnqXOhL08GU+RpFK0Y/K6DgCQRNqF2HODVdW9IAHRjlowTGlai2z7m7HXBvVnm5E11cUv5CuHycpVbr5ZzC4IlMfIWhel9oELCM3ENJTOEfS3SOeYx6EzrMZj45vTyh36H/ntYn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777019; c=relaxed/simple;
	bh=c4hNJ4QgEi1e8LYYWn+AEGf/F7PSx0YEnvu8nJoZXOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rts+VhZbZ3mxUGdu7hRMrwcocrBq/Ng1gecY3/BsleQKBdOmudrY2LsEIjFMEE8/fEeSXptS7P/O1PXJxAi7tLRpRIKDrzGYZLG0xSoOGz0hNSRWrmcoHpsK1+CTdT/Hl+HlPJFNh/h2l9umeR+KEoCF4cw20hFE3m6Hj6BJ0EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrWd6Bhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrWd6Bhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BFAC4CEF5;
	Wed,  3 Dec 2025 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777018;
	bh=c4hNJ4QgEi1e8LYYWn+AEGf/F7PSx0YEnvu8nJoZXOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrWd6BhyC4Zei8F4/mglBFgVZGSnOjXAO2zisrV+gYDGt4ayi8puaVBSLxdmGJJwz
	 k9J/0mhe2VvpgukdbHG5Z68adLdWt2Eq9AndqoC6lQgUQtVBsTBC/yCxo8zZxWstjR
	 b4gKvp0Yj7lBjHJi5Ca+1uQB8JcNrO71if7TSaws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lesiak <chris.lesiak@licorbio.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 057/146] iio: humditiy: hdc3020: fix units for temperature and humidity measurement
Date: Wed,  3 Dec 2025 16:27:15 +0100
Message-ID: <20251203152348.557167346@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Fedrau <dimitri.fedrau@liebherr.com>

commit 7b8dc11c0a830caa0d890c603d597161c6c26095 upstream.

According to the ABI the units after application of scale and offset are
milli degrees for temperature measurements and milli percent for relative
humidity measurements. Currently the resulting units are degree celsius for
temperature measurements and percent for relative humidity measurements.
Change scale factor to fix this issue.

Fixes: c9180b8e39be ("iio: humidity: Add driver for ti HDC302x humidity sensors")
Reported-by: Chris Lesiak <chris.lesiak@licorbio.com>
Suggested-by: Chris Lesiak <chris.lesiak@licorbio.com>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Dimitri Fedrau <dimitri.fedrau@liebherr.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/hdc3020.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/humidity/hdc3020.c
+++ b/drivers/iio/humidity/hdc3020.c
@@ -301,9 +301,9 @@ static int hdc3020_read_raw(struct iio_d
 	case IIO_CHAN_INFO_SCALE:
 		*val2 = 65536;
 		if (chan->type == IIO_TEMP)
-			*val = 175;
+			*val = 175 * MILLI;
 		else
-			*val = 100;
+			*val = 100 * MILLI;
 		return IIO_VAL_FRACTIONAL;
 
 	case IIO_CHAN_INFO_OFFSET:


