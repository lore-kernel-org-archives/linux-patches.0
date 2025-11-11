Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C00346A14;
	Tue, 11 Nov 2025 01:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823657; cv=none; b=kwhQNnWZH1mVYvwK7BLjMbWAbvo7J8gG8r2kDpnWDdpHkUDJXyejCH0q4h+wMwLoeMEWtyuFX8Qm284QeajmpqZVvScn5PcH2bkcUWMme9AAvNGj1VWo+AJswyYwH2q24zPFyZStRgvL8vsf/H1FZ5mi5B4uX8tXQ9NDErMT2IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823657; c=relaxed/simple;
	bh=nHGQn38TqpZt6Xw4mni11NNiRty+eVdyeRQ5wiVuUaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exKoananr7Z/5Vi/MA8RSN2xYkJZ2hwquhy75LHG7zTXXJoxbZsvtQYWUaoP/xSG1tfwFvKcuiN146lpDG10vkuMjnrHf4UvJN7P2kykiSHUN0iNva94lsXKM+iISvRzDaTf/IYtdrOyJ/XPnGQ5baZbgt713oWulRJ0RTSCEHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoCBWv/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoCBWv/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8733C116B1;
	Tue, 11 Nov 2025 01:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823657;
	bh=nHGQn38TqpZt6Xw4mni11NNiRty+eVdyeRQ5wiVuUaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoCBWv/ujFsU/oSKG1bvLoYn9FtIyvhD6eYSDbNY6HJpnVDJEBvMp8TlCqUASZfvB
	 REYk+Jr9dHR19JIpbr3gmeJFm+g+iu8enZzOH3We0IJtfDNVo62GNmtim2PNVZ19kW
	 ssvGTeijQxLKlvtqp516cIdExY3+ciwLkkxIldjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/565] crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()
Date: Tue, 11 Nov 2025 09:42:13 +0900
Message-ID: <20251111004533.113987767@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 4c634b6b3c77bba237ee64bca172e73f9cee0cb2 ]

As noted in the kernel documentation [1], open-coded multiplication in
allocator arguments is discouraged because it can lead to integer overflow.

Use kcalloc() to gain built-in overflow protection, making memory
allocation safer when calculating allocation size compared to explicit
multiplication.  Similarly, use size_add() instead of explicit addition
for 'uobj_chunk_num + sobj_chunk_num'.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 7ea40b4f6e5b4..1bde198c0bc07 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1746,7 +1746,7 @@ static int qat_uclo_map_objs_from_mof(struct icp_qat_mof_handle *mobj_handle)
 	if (sobj_hdr)
 		sobj_chunk_num = sobj_hdr->num_chunks;
 
-	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
+	mobj_hdr = kcalloc(size_add(uobj_chunk_num, sobj_chunk_num),
 			   sizeof(*mobj_hdr), GFP_KERNEL);
 	if (!mobj_hdr)
 		return -ENOMEM;
-- 
2.51.0



