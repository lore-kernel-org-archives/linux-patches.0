Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484173D6694;
	Wed,  8 Apr 2026 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673400; cv=none; b=BwcowiNMEDyGte1/KK5032CXbEbFfXQRPCd2sozTHeBBBOaXKeA/75YTyugMMJxTDo/Pzx5JhUGTLdaazeBrWIpHf/YKZppIYHiBb+ETdvEviEnVZM9u3Sb8GkrAi1mQPU54xrXk9WTYhMCyr1tV5FDI3aO4j15BuwIKcaMFjIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673400; c=relaxed/simple;
	bh=QNHyByrgJlcKZt98N5aPpeahC8LIUa4uydtkxxzAONs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVgpIggDE3SQut0Qvs7jaMfinFPDdSIwA+AWsv1mt8HW6QqafZHMB3XMGaeVHfhIvFvF07QuTRgfFs7Lyg+rRCLoSQn9WSTGVy2C+qbQru6TbCRiAYBhnVb08oCi4gXt5b6QuITwwgAR61PfmiB6G4i0ZRqocoxFrXf8yfioU8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4Z3zJu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4Z3zJu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34D2C19421;
	Wed,  8 Apr 2026 18:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673400;
	bh=QNHyByrgJlcKZt98N5aPpeahC8LIUa4uydtkxxzAONs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4Z3zJu2lTtmgULegmd0T/RS4Vms3zQTHkePKhh/G21s5mFnNVcVzLh/Tiu4u1lmw
	 uiV71JZ3PYo10hKnsfsNi4ysllrIr5bNz4UwS3FfUuvuUoNnUFuR4DCoKeOz44KYwL
	 IepUZ1YjfQUJWdMLrrCNSmmgFwQt9qRXUlJewcmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 185/277] iio: dac: ad5770r: fix error return in ad5770r_read_raw()
Date: Wed,  8 Apr 2026 20:02:50 +0200
Message-ID: <20260408175940.771392033@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
@@ -322,7 +322,7 @@ static int ad5770r_read_raw(struct iio_d
 				       chan->address,
 				       st->transf_buf, 2);
 		if (ret)
-			return 0;
+			return ret;
 
 		buf16 = get_unaligned_le16(st->transf_buf);
 		*val = buf16 >> 2;


