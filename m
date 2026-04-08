Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E844D3624B2;
	Wed,  8 Apr 2026 18:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673948; cv=none; b=BlWmG36vmlpMHTLGmccS0j4izvPDYVGgpdbKvKU5xGz9e3+7b0PsyGFOFkOi9Xg60YirrxecmBJgM+bvyNX4eSPgIdK8oRPQd4gEUPv9RmTqtavBiCH7ZQ9A3QUYV1itdR18WOs0A8lLvP2FKClaKTOTHXQZfpH5kf+lShLOMGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673948; c=relaxed/simple;
	bh=pz2WZlrLwMzii+W6QnN0x2cuYfiplu2mmhID6P217sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=celyLykrOHh1ww29vphhfoCnCiqe1NuYv2EqgG+fpzQs3xUzeq66VYyRyw58AO12obVtGecnDJ5OmbkDk+bAdz4h9scl6cNClHOFfS1zqgRTkEnShJtTnd2lNu4ZOYGOSo1YnjwvGHcqYiVTGgvC78R0NdEobXBVZW0ThOtrs8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzHaoZ2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzHaoZ2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEE7C19421;
	Wed,  8 Apr 2026 18:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673947;
	bh=pz2WZlrLwMzii+W6QnN0x2cuYfiplu2mmhID6P217sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzHaoZ2lcl00QXFdp9lGSAcnQVduBZ5n2S/kkYOA+Pn8mC2Clz1tNy+siZcSGmI2y
	 5K7OVrN2pYmW53CvUjG684Qs1HdPgFxP9+YhDKcBhCte33cAd7zaU4Oit9lPhGPl+J
	 fYpvNihnEp+b1NvWrxc9ci6vQmM6gveiV4FBwCDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 151/242] iio: dac: ad5770r: fix error return in ad5770r_read_raw()
Date: Wed,  8 Apr 2026 20:03:11 +0200
Message-ID: <20260408175932.743358589@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit c354521708175d776d896f8bdae44b18711eccb6 upstream.

Return the error code from regmap_bulk_read() instead of 0 so
that I/O failures are properly propagated.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5770r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5770r.c
+++ b/drivers/iio/dac/ad5770r.c
@@ -323,7 +323,7 @@ static int ad5770r_read_raw(struct iio_d
 				       chan->address,
 				       st->transf_buf, 2);
 		if (ret)
-			return 0;
+			return ret;
 
 		buf16 = st->transf_buf[0] + (st->transf_buf[1] << 8);
 		*val = buf16 >> 2;


