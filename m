Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF67399CE9;
	Fri,  9 Oct 2026 14:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556886; cv=none; b=Y2mg7uCD2SdDTnMya4Gw3kygtYCrSBEiD62UTOBJZcIwwZbm+MhDOPXzruBc2JIkZOSWtZkVZIyMjvF/zlgJqCTBYVqwGBcdNAMcR22Y1JrZ28SjU7r0HRYC55n/bkSTrVXwxm3cFhe1bFTuLxrxkh4n4cUgstcUW/Od9i5umKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556886; c=relaxed/simple;
	bh=OBkf5Lj+P9bMxm/Z+c5sk428NZjF0gKDZzkVzG5/bsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpKDeT40J3pa2kzbhZf1wLlstDNrSN0NoCC1LQBSH8CqOr+j5sahfP42OhyXS5FIkjYLAUVejvlGfEj5ECgjGQmWkVS/cUjkHOhDwHHu44J7aOwyveRVm9CEU3uEzdwFBk+r/xtSRLxsjNHwKXG8s54evTvoMTuQc4WZfgeb/bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCJElXCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCJElXCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24891F000FF;
	Fri,  9 Oct 2026 14:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556885;
	bh=fFqHa+c3yvNCmgja/sof3U+N4AspnfH5TE9G7/GT7q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCJElXCHxkQ6epvNEgqCqrpxKNknSDZs25MNpbNQEWDd3wYZmBKRTNMVfG7U6e7y9
	 vJIDJj8KMlL0W+x6PzkvkqMLw2p6ZWO7EHs87zauPK76mQWPQFM7yVBDMUHx19lZa0
	 R0bHrmtJ3q9i09XkFtwcT211i679On9onbLAS1hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 309/403] iio: adc: pac1934: check ACPI label duplication
Date: Fri,  9 Oct 2026 16:11:10 +0200
Message-ID: <20261009140959.443022982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

commit 64c82e7bd9c82b0c9276297df34a3579e8658f55 upstream.

A label duplication failure currently reaches the terminating-byte
write. Release the ACPI result and abort before accessing the missing
label; earlier labels are managed by devres.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 0fb528c8255b ("iio: adc: adding support for PAC193x")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1934.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/adc/pac1934.c
+++ b/drivers/iio/adc/pac1934.c
@@ -1108,6 +1108,10 @@ static int pac1934_acpi_parse_channel_co
 			devm_kmemdup(dev, rez->package.elements[i].string.pointer,
 				     (size_t)rez->package.elements[i].string.length + 1,
 				     GFP_KERNEL);
+		if (!info->labels[idx]) {
+			ACPI_FREE(rez);
+			return -ENOMEM;
+		}
 		info->labels[idx][rez->package.elements[i].string.length] = '\0';
 		info->shunts[idx] = rez->package.elements[i + 1].integer.value * 1000;
 		info->active_channels[idx] = (info->shunts[idx] != 0);


