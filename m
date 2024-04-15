Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822768BF8;
	Mon, 15 Apr 2024 14:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191595; cv=none; b=eXCs/e/0l4C4FCfTQmzJjMz4qxe3WGg+JdErV8ycGl7ZY0Wx3XbQTCN7N5AQu0XjgCRvemXiWfpihrahCsG6h8aT8Jfbye1WAR0SWGIAXOMq3iTGfyMIbqTq/MENu0FRjgki6sF1i5ZV7tbv4XTdOI1EB7udlfDpsN5A+VT4QxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191595; c=relaxed/simple;
	bh=iX0Uvk4vua6w9eH2/S19O4Xzge6O8GuqxHPjv9kS+eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPXn3UYmgA42iT1sla+Gw0M25GuNukojBewzKHXiLL2L4eGflnqmzryd7KIBU0s/cKi9/ttXFwz78aMZh3lZMxZDiSCq5ju2fgjwV96Qc3IBszQzqM3NP44XVnhnTcrMuqFvJ406FMLlE5aNpEcF/XSZLDA5eD+CxfGuaFZKl18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBVzk/0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBVzk/0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2FBC113CC;
	Mon, 15 Apr 2024 14:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191595;
	bh=iX0Uvk4vua6w9eH2/S19O4Xzge6O8GuqxHPjv9kS+eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBVzk/0ablw0156TU5wp5QXR1IZ0vAoeINd7VwsDP5cnRDOZ6HQrPgtQcfMBbkzMv
	 K6MsL/+yim7Z2EsXrzQhlQumqMsowyNfQ7/cwfjSa3JJYwnfQNEHPgrIuEmE1FeXaq
	 WHCu/jOFpdFt97PemawdjW5cSNxr20yhs6gQyMvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuquan Wang <wangyuquan1236@phytium.com.cn>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/122] cxl/mem: Fix for the index of Clear Event Record Handle
Date: Mon, 15 Apr 2024 16:19:47 +0200
Message-ID: <20240415141954.040663562@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuquan Wang <wangyuquan1236@phytium.com.cn>

[ Upstream commit b7c59b038c656214f56432867056997c2e0fc268 ]

The dev_dbg info for Clear Event Records mailbox command would report
the handle of the next record to clear not the current one.

This was because the index 'i' had incremented before printing the
current handle value.

Fixes: 6ebe28f9ec72 ("cxl/mem: Read, trace, and clear events on driver load")
Signed-off-by: Yuquan Wang <wangyuquan1236@phytium.com.cn>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index b12986b968da4..e5f3592e54191 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -928,7 +928,7 @@ static int cxl_clear_event_record(struct cxl_memdev_state *mds,
 	for (cnt = 0; cnt < total; cnt++) {
 		payload->handles[i++] = get_pl->records[cnt].hdr.handle;
 		dev_dbg(mds->cxlds.dev, "Event log '%d': Clearing %u\n", log,
-			le16_to_cpu(payload->handles[i]));
+			le16_to_cpu(payload->handles[i - 1]));
 
 		if (i == max_handles) {
 			payload->nr_recs = i;
-- 
2.43.0



