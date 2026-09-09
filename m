Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861453A8A1;
	Wed,  9 Sep 2026 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962374; cv=none; b=mTzCCcqghGbHwLMNDSNBF+lvW0q240ygYNW16hYSIcb7CDKyTXYb7NKqcehdAedvl1cK9aM2OgOpUzsClOz4xZbujSuQpvuqJRYpZ/81q5IBQwCLwoZ/L7XPkY6mIrckdKR0BsSM7Q+M4TIDKP4brlW1yepFPcZBdK3kNkaY/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962374; c=relaxed/simple;
	bh=g6oDS6RsF+x0W48L9P6nI7I9HooJjJ+dVoHaekBlHJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0kgMUzTQmSIUGO7wfsana/IOk2Cv9x+pAw09gNi3iIchMq7XqQlZwm2zhgXaG/P/BiAM6+6TaY+A3RiPrK1FpYcER5hPKZPMt58kTR+iADBlZq05uj1s0F4NUWO74lhacxjJYWXrbw5MKHh7r6PkJZO/8skQfbVL7tGBfYr1/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFPqbLYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFPqbLYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2D61F00A3D;
	Wed,  9 Sep 2026 13:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962372;
	bh=VejE07RVJPGH5q44/3tTBJdsiIzlFc19z2S5dAtb3QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFPqbLYkeuBre8NzPyyb/Hc6OFdA9NT+UclFupmWR6Ow1FTm47cQs7DpPJPhYZDMc
	 jDQkfelnDwYRpNObkDdsBj/9gQ0dNq8U78qjDmOXpjrevUayTDCqLP/CjcCMa1c27n
	 wSeT9izCmRmS6D2Ziv1MughU9T9lT1X9SqineQi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 269/556] iio: chemical: sgp30: Handle IAQ thread creation failure
Date: Wed,  9 Sep 2026 15:39:09 +0200
Message-ID: <20260909134240.057139549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 1135d6875d2dbda3f6ec718f3421a6ce4378bd63 upstream.

kthread_run() can fail and return an error pointer, but sgp_probe() stores
it and returns success, so the device is registered without its IAQ thread
and sgp_remove() later passes the error pointer to kthread_stop(). Return
the error from probe instead.

Fixes: ce514124161a ("iio: chemical: sgp30: Support Sensirion SGP30/SGPC3 sensors")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sgp30.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/chemical/sgp30.c
+++ b/drivers/iio/chemical/sgp30.c
@@ -548,6 +548,9 @@ static int sgp_probe(struct i2c_client *
 
 	data->iaq_thread = kthread_run(sgp_iaq_threadfn, data,
 				       "%s-iaq", data->client->name);
+	if (IS_ERR(data->iaq_thread))
+		return dev_err_probe(dev, PTR_ERR(data->iaq_thread),
+				     "failed to start IAQ thread\n");
 
 	return 0;
 }


