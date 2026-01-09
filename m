Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D05735B133;
	Fri,  9 Jan 2026 12:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962391; cv=none; b=XKoybqurRYuytmmq1IFfoxNqP7ammg756u50sByVTdOB8U/0Lr4kQaDVcg2p/t8uuF89Xm33cMYzqgqn15pdX+3VfApQBGPC2AyKSXcn/aPp4aTZjmUaMa6GVLxXXnNRSe3E1ondVl+unAM3FhKwVjSVPm7tzI/mGNNus+iT/H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962391; c=relaxed/simple;
	bh=Gy+cdAF8JJsfAUMxBt0eBnFLXyz29Ssdcf6xl7MgcZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fL+d7NWpHR3O8F8aXJOHRHhCdyHrv28en2ijdQr2O6ZJLRLMNluiShBU5Bc8XITHUJbS4+5XevEewpIQbX3HTrpxANCk0M4dNfQZaLv8fbqO9Dyu8sf2/xkf6PkSiCDGXPGgrE1ApPDIfMENxAMRjzdwJOZ3Hg5fcwE4Wc7X46w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FesiIQBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FesiIQBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3854C4CEF1;
	Fri,  9 Jan 2026 12:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962391;
	bh=Gy+cdAF8JJsfAUMxBt0eBnFLXyz29Ssdcf6xl7MgcZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FesiIQBNs85KzFjHSDu8jJlMXko2dqvBtJw4YrI/m3RHX3hRRDz6At/NHSEq7cJ9c
	 mzYxjNlr6egTt3qxCgr+eQbOnAWjdwHE1eYznNJNmaMY3KsTtgxp8eMqYHnGhApCNm
	 pq/SnYNOdw+HGTyhJkUhMhQmL0dwsqMInhwpJ+2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 316/634] block: rnbd-clt: Fix signedness bug in init_dev()
Date: Fri,  9 Jan 2026 12:39:54 +0100
Message-ID: <20260109112129.422379579@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1ddb815fdfd45613c32e9bd1f7137428f298e541 ]

The "dev->clt_device_id" variable is set using ida_alloc_max() which
returns an int and in particular it returns negative error codes.
Change the type from u32 to int to fix the error checking.

Fixes: c9b5645fd8ca ("block: rnbd-clt: Fix leaked ID in init_dev()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-clt.h b/drivers/block/rnbd/rnbd-clt.h
index a48e040abe63..fbc1ed766025 100644
--- a/drivers/block/rnbd/rnbd-clt.h
+++ b/drivers/block/rnbd/rnbd-clt.h
@@ -112,7 +112,7 @@ struct rnbd_clt_dev {
 	struct rnbd_queue	*hw_queues;
 	u32			device_id;
 	/* local Idr index - used to track minor number allocations. */
-	u32			clt_device_id;
+	int			clt_device_id;
 	struct mutex		lock;
 	enum rnbd_clt_dev_state	dev_state;
 	refcount_t		refcount;
-- 
2.51.0



