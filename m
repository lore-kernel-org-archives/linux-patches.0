Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4F577658;
	Mon, 15 Apr 2024 14:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191089; cv=none; b=WVLsMMuYjtJoX0r5Xueb+UgY8iymkOqLxme8+Pz5Ql4B+h3oyD3D4rw9eSfLcNwGrbBDcda/zjTMVarY9G8zBSzTrmeeUOfb5XcwCu9mq14wSL1gIS1TnNJJU5qmFP4gu31SgbxTL2FKxuxRitySl+hprZwTjNed/lqbpByDgbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191089; c=relaxed/simple;
	bh=c+/xEKMENRKbEFDOiVze9Wmt3fI/D3M8d8h3Nbd5Gl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeF5tSdTZyXXufPup5aZ6yaXxrFrqw5HZsmKKfTzV2FGy6knWsO94hSPTrQu2yZHRoFESow1vmO/N6oafda0LpAwqsf8OUMUGKqpvVwF3Kd8mQ9+n922GE5BIlvZFuPp8JMc0iOM+FAg67A2MEIfUgSTs6vDWO1DW+dgRkslb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=me/KKj/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="me/KKj/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2B8C113CC;
	Mon, 15 Apr 2024 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191088;
	bh=c+/xEKMENRKbEFDOiVze9Wmt3fI/D3M8d8h3Nbd5Gl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=me/KKj/7hfUFAeMvgW6uWaKyOnp+jYH9330VYTINabyONNl8Te2vBKBR+x879ogVj
	 Y7dDnT9C2TrXZPZ12Hz7+GS2ZTV0mOrDP9F9pUn7pyk3CNtmNEtoasxVQe8S4OFLDZ
	 DDSuLpTKEWC6GoB8zPFakRZ+3xOuvQ+rZPkKsgQE=
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
Subject: [PATCH 6.8 028/172] cxl/mem: Fix for the index of Clear Event Record Handle
Date: Mon, 15 Apr 2024 16:18:47 +0200
Message-ID: <20240415142001.201790112@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9adda4795eb78..50146161887d5 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -915,7 +915,7 @@ static int cxl_clear_event_record(struct cxl_memdev_state *mds,
 
 		payload->handles[i++] = gen->hdr.handle;
 		dev_dbg(mds->cxlds.dev, "Event log '%d': Clearing %u\n", log,
-			le16_to_cpu(payload->handles[i]));
+			le16_to_cpu(payload->handles[i - 1]));
 
 		if (i == max_handles) {
 			payload->nr_recs = i;
-- 
2.43.0



