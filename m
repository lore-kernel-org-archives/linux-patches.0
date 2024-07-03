Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7787CF1F;
	Wed,  3 Jul 2024 11:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006133; cv=none; b=coxN69XWyHdHLPNuAUAx1wVukwB3/azs9ZH2dbDPHPHjJwDgl02DBT4kBT2kimMH+R/jzLcvqUYbqp1Ork/lYAr8KO8l7jCZiyWrtFy94d92CKJNfxhrhZpWlkQmu7DM4V5bwzXKIQqRZicunT5Z48LUU3JdS2d4ZGX35ZNWdZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006133; c=relaxed/simple;
	bh=fneTiy3wM0FQImOM9Co4XKb2Jt1nSPJVEapV41B3UpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FU8Bjjb13gTeJnlil52HMYlTjOIeh3tbBGR4AogYr2EkVWLsp8tcUwwwB2IDCJsShvpSt9rxK6BmosZ6lVkfXnGgtinsK6H1FCUvIdqaVR4IHao+48QUief93CgUIYoXudpgTcNjk8mBHJUyrwnphcfa1yupzif8W3JUho/FSyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvAQdmoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvAQdmoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B944C32781;
	Wed,  3 Jul 2024 11:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006133;
	bh=fneTiy3wM0FQImOM9Co4XKb2Jt1nSPJVEapV41B3UpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvAQdmoMWhbDh23IvXtEsXhGoeP+wWs5l3uuefo0cS5FUG79fy01tb8D6+H1UXWrj
	 5DFf/DfWD1eM6GUsDuX1E75BLrNqS6iUKTRu3XXsZQYMRNP7U2m8GdVeGmvgeGinzo
	 Veq9OoBuKUgAjMFVrc2tOA7/UR9EXNdTrxUtYveE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Yang <hagisf@usp.br>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 310/356] iio: adc: ad7266: Fix variable checking bug
Date: Wed,  3 Jul 2024 12:40:46 +0200
Message-ID: <20240703102924.840903254@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Yang <hagisf@usp.br>

commit a2b86132955268b2a1703082fbc2d4832fc001b8 upstream.

The ret variable was not checked after iio_device_release_direct_mode(),
which could possibly cause errors

Fixes: c70df20e3159 ("iio: adc: ad7266: claim direct mode during sensor read")
Signed-off-by: Fernando Yang <hagisf@usp.br>
Link: https://lore.kernel.org/r/20240603180757.8560-1-hagisf@usp.br
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7266.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/ad7266.c
+++ b/drivers/iio/adc/ad7266.c
@@ -157,6 +157,8 @@ static int ad7266_read_raw(struct iio_de
 		ret = ad7266_read_single(st, val, chan->address);
 		iio_device_release_direct_mode(indio_dev);
 
+		if (ret < 0)
+			return ret;
 		*val = (*val >> 2) & 0xfff;
 		if (chan->scan_type.sign == 's')
 			*val = sign_extend32(*val, 11);


