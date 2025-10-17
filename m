Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F146330B30;
	Fri, 17 Oct 2025 15:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715307; cv=none; b=UmaGyzcRShYAivFHrJtyf80XKOEIF+qCB+ZnueIrvPf+3Ne03JssKHNWDPqeRZ8WE82igUbHeXv4Y+lmbdv0xB3cWACPN9ox4MzkVjW3XG3MwFx9ZL4MbWGahWqDCYYLwd7Hs0qMod+mPnPaEJfqp6DQYkiTXRGLPcmJsOd9eaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715307; c=relaxed/simple;
	bh=zodVfU+5g3TwMxNecgi0re7ukiyja68iO/NfD3ZOWBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K033qWWM3SyMkmTEW1kaCcgS2zRnyER4KfCuzIgoUUp1zQrAAikFPAYkvcm/aEhcmEjtKPU9xb6v9a5dSpe8UBI6VWX/rck5Kiy6mNQcQafpBMUM2PelNWd0q31Fi4jVG/G58fQYHGZnVvdeDcf/iReTBQnLP66fZ8fiRkTeNJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+1UZpS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+1UZpS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1E9C4CEE7;
	Fri, 17 Oct 2025 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715307;
	bh=zodVfU+5g3TwMxNecgi0re7ukiyja68iO/NfD3ZOWBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+1UZpS9az+soWSYZeiCL0jpFhtjABzdy/5GIXHO85a3MnSk9r9UdOvlJER1fXoSq
	 mAY3lXzraKjH7SNhNybce3sfZha7jCpO0A1jsUKITqzKGbwnrlTeY1r8FqbuUEfxbF
	 1oxKOjLr1wPQb1KZCrlh1AyzxOiVyUmilmwsMU3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 171/371] media: i2c: mt9v111: fix incorrect type for ret
Date: Fri, 17 Oct 2025 16:52:26 +0200
Message-ID: <20251017145208.116381926@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


