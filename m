Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAB735294E;
	Tue,  6 Jan 2026 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720152; cv=none; b=Qtdk6aMxENHPBBmDMK99FKDeVqQ0/Oh/iMwJ6MLwbRhvBFhtEMV9GiXpyQFkCuOdlx2ygIjFSzzkG6nwvm1hVf3OQePN6nNUR22vie9ABhxWmz7l5T6DPrekGl+2COBnYns65q1/yVCilehRrvikC5I2rfsSirG3ISStxy0AAzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720152; c=relaxed/simple;
	bh=3mLt6X7/OZLuJWOs4po0sajLREm7Cdd8UT9bFuVDYsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hmae7c6d4TV2+G0i2156EswGW7yHZHTjhCSDHgj3Nbk7Pco3sNyNyeP4LHnHXB/fqqrI4DQF6x7xZyxBV73AHXnFNfJ8CZPD1jf8SBCYDiMy+3h8Sk3erxX5tmhjuyVgOQzAXbnTV6hel+3MN5ZKjOa8pONmtfk2nqHfsq6K/vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfCbazbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfCbazbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A26C116C6;
	Tue,  6 Jan 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720152;
	bh=3mLt6X7/OZLuJWOs4po0sajLREm7Cdd8UT9bFuVDYsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfCbazbel1x3HwE4nnAhxeBaqya/+jPpA4GIHCJr4/pzAe1FjwmoopA0IV+SIzyG+
	 vmsrNTGvQo0HBAQdcUYGVRr2bdt62degX3+yRa0AIXxuD5rnbcagfgseqbdisD/TMa
	 xi2CmyCnOuEK53okwoshulKD3C43uSZkY96oKtrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/567] block: rnbd-clt: Fix signedness bug in init_dev()
Date: Tue,  6 Jan 2026 17:58:52 +0100
Message-ID: <20260106170456.873692755@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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



