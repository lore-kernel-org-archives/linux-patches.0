Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDDA50094F;
	Fri,  9 Jan 2026 12:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960454; cv=none; b=VAf8GMPo5xyWCYYvljO196wYyj3t/LpZbZ2YLc7Sc+qYaHeA/VyzPItxuXKUWILUhwK9O/F/vCBj6Fn6JMadEYVmlJ915j81qWnpvxssKId+KqK+XUeODDzQKuLJ51L8j/zjdWStxroeagJ/1SIWYLu1pihR2JskSLbGFedPl78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960454; c=relaxed/simple;
	bh=wd79A7SiHCs7iXBMP449YGGJJjraxghwpoPYDHxxh1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjbeHwG3Hqvg2ogqYFnuEutVvN0T0Foz3NUgo53BlvyM0+9GtOvWq1edWiC7l5ALomTaCXv3lCsA7kNE8/MGoZ/6brXZLIS076kniE5734yAL5iqYSwGr+zb6hJ1/JgDXFu64mEdEg4120ZyluQaLWfhPOF2/KGtcxR/Jfz/GBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsSoOr+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsSoOr+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8538C4CEF1;
	Fri,  9 Jan 2026 12:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960454;
	bh=wd79A7SiHCs7iXBMP449YGGJJjraxghwpoPYDHxxh1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsSoOr+8r9A6GPxZOfVv5CzM4xDHFh5/Le72pDVctRaOMtKLKRferWi6FrXjHoN/7
	 mMbVvzTPz5EnOC9cLPWO1VrMLpjuzQZpNmp0cA6a4ycmWpFiI3eI/e05l7rph5vjow
	 zFwiVdRaGwpnWQnKH46Npx8eqwOUSE0agXLMmvNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 409/737] block: rnbd-clt: Fix signedness bug in init_dev()
Date: Fri,  9 Jan 2026 12:39:08 +0100
Message-ID: <20260109112149.382994672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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



