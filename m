Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6164845BD4B;
	Tue, 16 Jun 2026 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631013; cv=none; b=m+MP1HSWvccKiSnzE4AwRHteYwSGNtRXueaxcgbf7gr1AS3exRxkgd0zWOk/AvQf/Olng+go2QSEqbtcqOMuGs3Q/Jxj8JNcUgx+zVLj8HNmx30q4QrTnMFBlDhPvYspiMhgjgt4jl6F4q4xmZ3Ls8NRrcmadlafT8+oEOndNdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631013; c=relaxed/simple;
	bh=BwoSTh5CeDK6rt9ag1AZZnrxAdTzvvYWY7bb/dCD3Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtXnnr8iDuUNWxfjOew0l25OwpOu/wJYkdw/LWQBazjWOUmSNyGoJ7MXqhF0A4mMBXjtgj9J3WaU3Rlvq3Q2oIWPXQOOxOFfK5gh2KygpCxpGhe66xBS4DTlT++Sn5mrdV8fjuqutnShmSdpRwd2PiXwgBvPczS7SDKKTaAx+LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoUAkl/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoUAkl/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601041F000E9;
	Tue, 16 Jun 2026 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631012;
	bh=PoUI1nll+ocgJUv4y84OktlG1noGAOfPMHNsBE8LALQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoUAkl/IhZE/zdHAqJLM8eACjEVcwm/ar/sQX7hIrEwLufNDoyqPq6NSykwIfFcvQ
	 lVx4kDRBx7uf72qabRt/1NPvoAgI3isgYxE9hRD/Us1zCV4JN/e4Hkq/8sIIOSbdP4
	 cHB5eOJlEFlpWRrOjYDmlAZqLdmoGUSSfNDmfhsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 106/522] iio: dac: ad5686: acquire lock when doing powerdown control
Date: Tue, 16 Jun 2026 20:24:13 +0530
Message-ID: <20260616145130.900691552@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Alencar <rodrigo.alencar@analog.com>

commit 5237c3175cae5ab05f18878cec3301a04403859e upstream.

Protect access of pwr_down_mode and pwr_down_mask fields with existing
mutex lock. Each channel exposes their own attributes for controlling
powerdown modes and powerdown state. This fixes potential race conditions
as those the write functions perform non-atomic read-modify-write
operations to those pwr_down_* fields. This issue exists since the ad5686
driver was first introduced.

Fixes: c2f37c8dcadc ("iio: dac: New driver for AD5686R, AD5685R, AD5684R Digital to analog converters")
Signed-off-by: Rodrigo Alencar <rodrigo.alencar@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5686.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -30,6 +30,8 @@ static int ad5686_get_powerdown_mode(str
 {
 	struct ad5686_state *st = iio_priv(indio_dev);
 
+	guard(mutex)(&st->lock);
+
 	return ((st->pwr_down_mode >> (chan->channel * 2)) & 0x3) - 1;
 }
 
@@ -39,6 +41,8 @@ static int ad5686_set_powerdown_mode(str
 {
 	struct ad5686_state *st = iio_priv(indio_dev);
 
+	guard(mutex)(&st->lock);
+
 	st->pwr_down_mode &= ~(0x3 << (chan->channel * 2));
 	st->pwr_down_mode |= ((mode + 1) << (chan->channel * 2));
 
@@ -57,6 +61,8 @@ static ssize_t ad5686_read_dac_powerdown
 {
 	struct ad5686_state *st = iio_priv(indio_dev);
 
+	guard(mutex)(&st->lock);
+
 	return sysfs_emit(buf, "%d\n", !!(st->pwr_down_mask &
 				       (0x3 << (chan->channel * 2))));
 }
@@ -77,6 +83,8 @@ static ssize_t ad5686_write_dac_powerdow
 	if (ret)
 		return ret;
 
+	guard(mutex)(&st->lock);
+
 	if (readin)
 		st->pwr_down_mask |= (0x3 << (chan->channel * 2));
 	else


