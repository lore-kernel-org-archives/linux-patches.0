Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C723C693
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61AAC433D9;
	Wed, 20 Sep 2023 12:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213135;
	bh=L+Pr+bDDsC/xSM5gJIiDsudkRdBhE7iUtTtBrYJoHFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwEHwCCBG4ANUg7e2XKXR3jWKlFOmAg4W+ANZsgLwsND1GeMjeb2fwpIX/0OAGxya
	 flPNKbKrC9nmD4qnbf++oc9/kDvfyiNCgh+H41W481LS286Am8mgRZXy/wrcPco/5r
	 Q6lZ1SKd7sN3nqWFtD8jDKyMJ+jP7tTInA0LLcyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Yang <xiangyang3@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/367] IB/uverbs: Fix an potential error pointer dereference
Date: Wed, 20 Sep 2023 13:29:10 +0200
Message-ID: <20230920112903.120163465@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Yang <xiangyang3@huawei.com>

[ Upstream commit 26b7d1a27167e7adf75b150755e05d2bc123ce55 ]

smatch reports the warning below:
drivers/infiniband/core/uverbs_std_types_counters.c:110
ib_uverbs_handler_UVERBS_METHOD_COUNTERS_READ() error: 'uattr'
dereferencing possible ERR_PTR()

The return value of uattr maybe ERR_PTR(-ENOENT), fix this by checking
the value of uattr before using it.

Fixes: ebb6796bd397 ("IB/uverbs: Add read counters support")
Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
Link: https://lore.kernel.org/r/20230804022525.1916766-1-xiangyang3@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_counters.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
index 9f013304e6778..35e41c5ca1bb1 100644
--- a/drivers/infiniband/core/uverbs_std_types_counters.c
+++ b/drivers/infiniband/core/uverbs_std_types_counters.c
@@ -105,6 +105,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COUNTERS_READ)(
 		return ret;
 
 	uattr = uverbs_attr_get(attrs, UVERBS_ATTR_READ_COUNTERS_BUFF);
+	if (IS_ERR(uattr))
+		return PTR_ERR(uattr);
 	read_attr.ncounters = uattr->ptr_attr.len / sizeof(u64);
 	read_attr.counters_buff = uverbs_zalloc(
 		attrs, array_size(read_attr.ncounters, sizeof(u64)));
-- 
2.40.1



