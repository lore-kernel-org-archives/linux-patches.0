Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CE733AD8B;
	Fri,  9 Oct 2026 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557585; cv=none; b=CBYas5WO+YskUaxzEO8EKUqkETBjATz6K3+5yMcoFFCoYuu+vvt101c4QDqJ37X4xT7q0dOpVN2PQKUDgJgSLQsGa2OxcwuYve8OH7IYNYn/4yCO4gMtSAAEk38+iJT9Ifsk9RHrbZqVVXH3eP+ZxcwcI3iEc1qIg0hoNUuNzYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557585; c=relaxed/simple;
	bh=xTwt5xwRX3fNyMJd8w81wU66YEJ1c4Kgpl9t6asC0Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUSLqSAoWwDN3pNj1UqYdSO5ZW1zKYsUw/3IwnWQDVMoB7Yp2lF0mVQXKrXbCwt+fkCr2tb68L1LknRAfSWomk91zuSR4+9Kx3+Fol5EssFo1pXrlXwdrlKY1iqNsPjEhdubNiHBRJskanoXNp6EEg0Rwb9+OOALX4RiBdZ6T2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDwKkOp/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDwKkOp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7586B1F000FF;
	Fri,  9 Oct 2026 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557584;
	bh=zPH+lB1+tlDJ7MuN4asFBAuYwPyEYM2t13QPBpM1ybA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDwKkOp/mWsUHEdOne1fA22ZeANlh0TJjzDfTcItYTlcy1x4UDoali8ANWf+8t8gU
	 RxtFD5JhBeSNKy3pfNWQ/nnwtDM2cFf6JIeV7U+KPHia5qtD5CBd5NWpEk+RWrIONK
	 kdL3IxQW0h8gJpxn8uEOnLnKpKi6AnBbA3T9i4Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 411/428] iio: proximity: sx9324: Correct proximity channel resolution
Date: Fri,  9 Oct 2026 16:12:28 +0200
Message-ID: <20261009140955.256116878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -222,7 +222,7 @@ static const struct iio_chan_spec_ext_in
 	.scan_index = idx,					 \
 	.scan_type = {						 \
 		.sign = 's',					 \
-		.realbits = 12,					 \
+		.realbits = 16,					 \
 		.storagebits = 16,				 \
 		.endianness = IIO_BE,				 \
 	},							 \


