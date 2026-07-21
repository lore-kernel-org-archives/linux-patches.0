Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479E83B9950;
	Tue, 21 Jul 2026 20:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667311; cv=none; b=Y2MyfO7zW0oO571iMOs0le0mxD2LoXbnIUksRXNFXKkr1Dj92uziblzypscICKL5DPnlBp/mLOe0lCldGt97IpKBkREuFNg472FzCKZfrXySS1Tl/uAe9ojxmPR5LoLsWfJNb7cZ00FMtVrVFVvLF5/WfBivHcE7NC8jPoyyWcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667311; c=relaxed/simple;
	bh=DfG8xNY4TPFCHsfh8PvaK2Eumxebj5MgGpYs6vpykTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0Ryw22zg6gqvMxSqhvhiBTIfXSh+gnJvpDa74jxMGIn1lGvCcdTZLs6MPsgzQ/LwWMN1GYqsmkTo0y3aeO2CCwdY7OZVpAXvKZawTL4crErpCGQMC507687Ev88N7D9iXnJHld1QWzXm6SYkp287zKd7q2RqkT8F3iHN7+Y7P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DL74aWbk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DL74aWbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D0F1F000E9;
	Tue, 21 Jul 2026 20:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667310;
	bh=wVtM4/IJqyM4Ix6lYwULLfQcobiIHrF2rIsLzfUO4ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DL74aWbkSAEUSNAiqWQmOnt87+FBj9Z5lmWysqmMWL4Y4TZl4iTXq0SiJoje/EpSh
	 0+H6QRtshFW49cKq64Ep79zDVLgvCtBWSJl5nz5VzaL9Sp1kNQTq2ErW2vZ7oWtRfu
	 OZa7n+SYpybqg5V16tSpYkSLbM38Ijpnlr+dP+Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.6 1011/1266] fpga: microchip-spi: fix zero header_size OOB read in mpf_ops_parse_header()
Date: Tue, 21 Jul 2026 17:24:08 +0200
Message-ID: <20260721152504.449593346@linuxfoundation.org>
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

From: Sebastian Alba Vives <sebasjosue84@gmail.com>

commit 43a1974da6bc7ce8f4d1dc1d03d56997428c29c3 upstream.

mpf_ops_parse_header() reads header_size from the bitstream at
MPF_HEADER_SIZE_OFFSET (24). When header_size is zero, the expression
*(buf + header_size - 1) reads one byte before the buffer start.

Since initial_header_size is set to 71 in mpf_ops, the fpga-mgr core
guarantees the buffer is large enough to reach MPF_HEADER_SIZE_OFFSET.
The only real gap is the zero header_size case, which cannot be
resolved by providing a larger buffer, so return -EINVAL.

Fixes: 5f8d4a900830 ("fpga: microchip-spi: add Microchip MPF FPGA manager")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Alba Vives <sebasjosue84@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260518190742.61426-4-sebasjosue84@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/microchip-spi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/fpga/microchip-spi.c
+++ b/drivers/fpga/microchip-spi.c
@@ -116,6 +116,9 @@ static int mpf_ops_parse_header(struct f
 	}
 
 	header_size = *(buf + MPF_HEADER_SIZE_OFFSET);
+	if (!header_size)
+		return -EINVAL;
+
 	if (header_size > count) {
 		info->header_size = header_size;
 		return -EAGAIN;


