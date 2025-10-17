Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BA95695;
	Fri, 17 Oct 2025 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714418; cv=none; b=HKVt3M0XkvGW2xojuUcQH6D0CWGJDe0FkfvlyKiEpGGshTFJFhWdlkgZAOKI2PZSsZT+CYjnZ2P9xzWupfE6PGdNDurMdslwBMguFLYMuJqkTzgxIwl8idXsg3u+aoXLW0DaV3/CB4MLXy8v4ldSOtQI84GixIvvrBu9hxIOSbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714418; c=relaxed/simple;
	bh=wRfIDixHeSabQnrIzlbOmjhvY9KWQHEiy1u+PvxSWqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMaJgi6C92DXaVlH3RnZsPDCnr02DDRxiWfKJMB622/bJz8aGRzepDEIOei9hqBmuhkq74zGU5qeFDoVylZJ+AkztntQpWy3kjraTDRdr+hDkvz95OBUGkkwQdZ0tDur5Huvp13v1C5YGywjsPZMUNERpPdbvSWcSk+TdK1uNZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/MQnJqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/MQnJqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF04C4CEE7;
	Fri, 17 Oct 2025 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714418;
	bh=wRfIDixHeSabQnrIzlbOmjhvY9KWQHEiy1u+PvxSWqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/MQnJqsxixplbOyZ4QYkyCm5ae6iytTZPBBHuCWj4ACpLRnYFMtsSe2jlfFbYyyf
	 2GvR3Vh9v8J2dbYcYtvPgqrAYhj2ygoCIc3DlhnvNbaf3biIoHi2fbcPn4budYBSOk
	 a+H0J/i5NFJB4QJJakggBWfPcQL+spbnXnhBQbTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 105/277] media: i2c: mt9v111: fix incorrect type for ret
Date: Fri, 17 Oct 2025 16:51:52 +0200
Message-ID: <20251017145150.963898779@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

commit bacd713145443dce7764bb2967d30832a95e5ec8 upstream.

Change "ret" from unsigned int to int type in mt9v111_calc_frame_rate()
to store negative error codes or zero returned by __mt9v111_hw_reset()
and other functions.

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Fixes: aab7ed1c3927 ("media: i2c: Add driver for Aptina MT9V111")
Cc: stable@vger.kernel.org
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/mt9v111.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/mt9v111.c
+++ b/drivers/media/i2c/mt9v111.c
@@ -532,8 +532,8 @@ static int mt9v111_calc_frame_rate(struc
 static int mt9v111_hw_config(struct mt9v111_dev *mt9v111)
 {
 	struct i2c_client *c = mt9v111->client;
-	unsigned int ret;
 	u16 outfmtctrl2;
+	int ret;
 
 	/* Force device reset. */
 	ret = __mt9v111_hw_reset(mt9v111);


