Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B23587DE;
	Sat, 17 Oct 2026 17:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256783; cv=none; b=YHfm2oZlAw6s8WBF09hQmzCbs6GfhMPokNyIpY7fThE1y9QX9aScIKkdswNQMLfo+g4b6gOlqSkLFuZBZMREsoCIeIxMa4DOglvcR8kzX9r+CtnXCJJN/xufdybSsPG9ndWDlQGlyEVvZNWhR4Tys0ZGk+XiccqYUIYW5cHfIeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256783; c=relaxed/simple;
	bh=yOmR7CVkZh7nefsMb1wLgEiVOGGcF5N2ekfDCwhytI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tssRjRIKItSEetxsPFF6j5SDGKSd8xLMrv2MKqQyXco12rq1cd67IN+DHHiKGHt0jWSQw4dJaEUCgYeCTFc9N6GQ5mZcsuQ+/6zONY6QHyK2DpXWrXCeMOiC2RL+giNZrIkojrLUb331KfNaI9rg5ergGUQgMDKDvsRKVLubzzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hj9kc4vI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hj9kc4vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22A61F000C4;
	Sat, 17 Oct 2026 17:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256782;
	bh=NU3v0TzqY9NC0UDFzy8j0wlIJfzK0Btqn6WUHEyS35M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hj9kc4vIvJD45TBfoTwLKCWgH6OC+kInBekg9Kyj+hm56gIE4m+Yd+a13rx9IIu67
	 TiWaPMpC85qQwh5HWDVyEU1LDPq6zYkaWuD4+EEQsHghbKq1NUCXQuwD9Jf2T97iM3
	 HE9HxArNW/qX0cnmFBlh+FwORuU6ZmsMU4aTVlJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0351/1674] iio: proximity: sx9324: Correct proximity channel resolution
Date: Sat, 17 Oct 2026 17:43:43 +0200
Message-ID: <20261017160440.134883147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>

commit fbf33cb18334e7cab1ed4ad2e9a98a1299ad874c upstream.

The proximity channels were previously defined with 12 realbits.
However, PROXDIFF is read from RegDiffMsb (0x65) and RegDiffLsb
(0x66). The SX9324 datasheet assigns bits 7:0 of each register to
PROXDIFF and documents it as a signed two's-complement value
(Revision 3, Section 8, Table 8, page 43). In contrast, RegOffsetMsb
explicitly marks bits 7:6 as reserved. Thus, PROXDIFF is a 16-bit
signed value.

With realbits = 12, sx_common_read_proximity() uses bit 11 as the
sign bit in sign_extend32(), causing samples outside the 12-bit
signed range to wrap into the [-2048, 2047] range.

Correct the realbits value to 16 to accurately reflect the hardware.

Tested on an SX9324-based device: a phase 0 DIFF readback of 0x7fff
was reported as -1 before this change and as 32767 afterward.

Fixes: 4c18a890dff8 ("iio:proximity:sx9324: Add SX9324 support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9324.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -223,7 +223,7 @@ static const struct iio_chan_spec_ext_in
 	.scan_index = idx,					 \
 	.scan_type = {						 \
 		.sign = 's',					 \
-		.realbits = 12,					 \
+		.realbits = 16,					 \
 		.storagebits = 16,				 \
 		.endianness = IIO_BE,				 \
 	},							 \


