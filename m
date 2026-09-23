Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3265B36212E;
	Wed, 23 Sep 2026 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174988; cv=none; b=Pv4af7MzRW9qUy+krEb9flAsMv08JDQjxbk4GxZ6AnSLUa/IuA34q6CSxlePLffJWGVWfNRAQawMskOFhKUpB3bdsUFYlyf7Wh/QcNdUxsX1zTWX1jYzDavbsIzlQr/y0vWmUPvRF55cRCF+FWbRvQ7ZfdrhZr14h5OnaWZmwZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174988; c=relaxed/simple;
	bh=0RZ7jAB8FofaqRJeHBDEEOOZ9Ps2rr4DrYGXojcQ9Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUdchjgsYCiUMNwlA0H0TZ6yWCAQ8wDa2S/Fd/JpKw563fyK8iThpqC3FTpYypMHcwhKGimeSjluittCmHQQIpHUtI58Bi/+qcqpFuIOyx1gChuPteQ+a47liNXh0+mAWswon5+mVcK28Lv/10tHndl1sptS6PC4JlL1anczZPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJ4zss2L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJ4zss2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196471F000FF;
	Wed, 23 Sep 2026 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174987;
	bh=DXhYWl2SSw4mcXwTpNp7ygkgK5dzDAlkTiwwhDo7rfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJ4zss2LzZ20E9+s4AdAs6F1PXKNmUDnMySWoewj5yYBwYjORp75rRRKgZgqXpyaq
	 TeERVWNbzMqiAPd6XPmuxUmi2x9faZFF5fp0ZfvI83UGS/23dNXPa+Gt2g00JEwoJB
	 FC1JaoSCniUxAk+kWarKqzC9JRSYyCPi4U9tw8kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 279/398] power: sequencing: fix NULL-pointer dereference in pwrseq_device_register()
Date: Wed, 23 Sep 2026 16:05:53 +0200
Message-ID: <20260923140650.649727268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 242da4318d97380741516b595af3920207b2f0f1 upstream.

If dev_set_name() fails in pwrseq_device_register(), we jump to the
err_put_pwrseq label before initializing pwrseq->targets.
pwrseq_release() will try to iterate over targets unconditionally and
subsequently dereference an invalid pointer. Move the call to
dev_set_name() after the list head is initialized.

Fixes: 249ebf3f65f8 ("power: sequencing: implement the pwrseq core")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260903-pwrseq-kunit-v1-0-1f893d2cabc2%40oss.qualcomm.com?part=2
Link: https://patch.msgid.link/20260909-pwrseq-kunit-v2-3-ef496afc89d2@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -505,10 +505,6 @@ pwrseq_device_register(const struct pwrs
 	 */
 	device_initialize(&pwrseq->dev);
 
-	ret = dev_set_name(&pwrseq->dev, "pwrseq.%d", pwrseq->id);
-	if (ret)
-		goto err_put_pwrseq;
-
 	pwrseq->owner = config->owner ?: THIS_MODULE;
 	pwrseq->match = config->match;
 
@@ -517,6 +513,10 @@ pwrseq_device_register(const struct pwrs
 	INIT_LIST_HEAD(&pwrseq->targets);
 	INIT_LIST_HEAD(&pwrseq->units);
 
+	ret = dev_set_name(&pwrseq->dev, "pwrseq.%d", pwrseq->id);
+	if (ret)
+		goto err_put_pwrseq;
+
 	ret = pwrseq_setup_targets(config->targets, pwrseq);
 	if (ret)
 		goto err_put_pwrseq;


