Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7AF26F454;
	Tue,  8 Apr 2025 12:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116997; cv=none; b=LzoK1ZI310P19mpOg3UYpJPpue7iNToQMz5NnL3QhNc2MMg2s0RBMRdEB5yBURTLUuO4De/KSDdm/e+qpyeQn8ja/gk8VQmp/UptrX4/545XlsyVCcoJ3IKsYuk6xdY7MooAZaz5uOy53MNt2kLsKiKUJhPybhwzMFR1sf1Dl50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116997; c=relaxed/simple;
	bh=73F3K2M83698mdmbDRdlXAjg38TELpgfIRdltUagG4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lX8p0TQmFfaWF9+fwub6GA2r3BvIghuncWTFOyoBrXaMADp4Mune0DwwPK2LmwaGqfGYbEobP5ABBDeyG6+Jdiq6HpPA3N/9BhYwEZ+fv+fy3WothpYUI73cJIVSiNQDFNu5ia5NnkU0Uio49SRjVNnFKQJJscnrwce4M+o+Hp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujJC3XNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujJC3XNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FF9C4CEE5;
	Tue,  8 Apr 2025 12:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116996;
	bh=73F3K2M83698mdmbDRdlXAjg38TELpgfIRdltUagG4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujJC3XNjMoqG8iimeT5zk3YSFqOjc4Xu+MTtX9v4qFWSES7Xq/sfcU/WIec17TcZw
	 U5xHkK9XZncRpdEIpO7GOyKASOn00CVZ9fLnH/brbPqJm/ZsYgdfEOL8VsG0xePxQQ
	 I8BcMB3x7qLAjAO/tlutyY560IHAnjdMi0M13SNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/423] ntb_hw_switchtec: Fix shift-out-of-bounds in switchtec_ntb_mw_set_trans
Date: Tue,  8 Apr 2025 12:50:32 +0200
Message-ID: <20250408104852.925066863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit de203da734fae00e75be50220ba5391e7beecdf9 ]

There is a kernel API ntb_mw_clear_trans() would pass 0 to both addr and
size. This would make xlate_pos negative.

[   23.734156] switchtec switchtec0: MW 0: part 0 addr 0x0000000000000000 size 0x0000000000000000
[   23.734158] ================================================================================
[   23.734172] UBSAN: shift-out-of-bounds in drivers/ntb/hw/mscc/ntb_hw_switchtec.c:293:7
[   23.734418] shift exponent -1 is negative

Ensuring xlate_pos is a positive or zero before BIT.

Fixes: 1e2fd202f859 ("ntb_hw_switchtec: Check for alignment of the buffer in mw_set_trans()")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index ad1786be2554b..f851397b65d6e 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -288,7 +288,7 @@ static int switchtec_ntb_mw_set_trans(struct ntb_dev *ntb, int pidx, int widx,
 	if (size != 0 && xlate_pos < 12)
 		return -EINVAL;
 
-	if (!IS_ALIGNED(addr, BIT_ULL(xlate_pos))) {
+	if (xlate_pos >= 0 && !IS_ALIGNED(addr, BIT_ULL(xlate_pos))) {
 		/*
 		 * In certain circumstances we can get a buffer that is
 		 * not aligned to its size. (Most of the time
-- 
2.39.5



