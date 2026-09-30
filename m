Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733FC503BE7;
	Wed, 30 Sep 2026 17:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788706; cv=none; b=sLOJN4P3TZl8vUnfOEPDFqyPJU0pASsfu1gbBYjanNx5CQrFlnVKIcjyfoX1dDXpl/oUSWICNUTdw2MT7WJNq8wm95XQcvzecK0WBuxcu0pvuscCbSWpB0SzziNC4O0oRhuzpjMpDPwyk71K1VDczfjGO/s1XIgwN4HyFaFCyzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788706; c=relaxed/simple;
	bh=+GXHrA8GjJRG4KEKXH0tCrnUmZIqTBN5ykjfUo3NoXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuhtS1hDUoTmn99dU2nUH+J2oa9ZGeUJ/L7gY0EdiVsRm6jFnJruDDzzMtI10Y9Ye3grGjbGQq7W74Y9OWQ7fkBtz5kMsB8oZgH66c56NWPl27LTIKfhz9DdO+1mpq2tZEX0wwSOoEwxRt5xhtm+z7FrHtnxIv/7bztBSpTZ4Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvSng5zv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvSng5zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839961F000FF;
	Wed, 30 Sep 2026 17:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788705;
	bh=1iKP+oQB0ZrES45slpkxATM2khktVe5V9uhcn/AsfR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvSng5zvlt6x5ct/hPFHTQu0EP0QK8wzK481krBJQKvwAQWROrwzCJEU+9J8YOVhB
	 oau7Mq6/U1hAIaLRNZNEEq1Zc1ZcFg6LqeJnlvVHlM2rGRMbXwN3xohIAyphImUeH6
	 xU05qlHC7rVBQ+0ygS2QsOybcT/GI28Bjh91P6GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 220/877] power: sequencing: fix NULL-pointer dereference in pwrseq_device_register()
Date: Wed, 30 Sep 2026 17:18:51 +0200
Message-ID: <20260930152419.475134074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
 drivers/power/sequencing/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/sequencing/core.c b/drivers/power/sequencing/core.c
index 7751ce8cd8f5..392d72537485 100644
--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -505,10 +505,6 @@ pwrseq_device_register(const struct pwrseq_config *config)
 	 */
 	device_initialize(&pwrseq->dev);
 
-	ret = dev_set_name(&pwrseq->dev, "pwrseq.%d", pwrseq->id);
-	if (ret)
-		goto err_put_pwrseq;
-
 	pwrseq->owner = config->owner ?: THIS_MODULE;
 	pwrseq->match = config->match;
 
@@ -517,6 +513,10 @@ pwrseq_device_register(const struct pwrseq_config *config)
 	INIT_LIST_HEAD(&pwrseq->targets);
 	INIT_LIST_HEAD(&pwrseq->units);
 
+	ret = dev_set_name(&pwrseq->dev, "pwrseq.%d", pwrseq->id);
+	if (ret)
+		goto err_put_pwrseq;
+
 	ret = pwrseq_setup_targets(config->targets, pwrseq);
 	if (ret)
 		goto err_put_pwrseq;
-- 
2.55.0



