Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB333161A2;
	Wed, 23 Sep 2026 14:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173879; cv=none; b=Z06D3mFqFFN84c/A7W/Qdd+GVf6YdoN91gDWPyO9LITNv3uhxXaX/TjoOUATgevVc4WO1aHB6wYLC+hw3Q4LDpJudpRIDQ/V4PqdPCD0/C6JpHoPOKIRkVIeH47ADE7B2Hy/lgfLZxzpy+CRdRpT+MwcLtBeGXhqN5LIBJPhTUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173879; c=relaxed/simple;
	bh=kH9M/8hKoaYw64B1xfpYYG2m/ImWighEppP/xEp/rcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nm7IJN3R04k2T2aWsU1agvHNr6WNRe1gYjcl65GM/+uO04wQTvIonE9fKHKvYar+huQtXBxIJDfXp41PEU3GFI7aOc6ZciqnOWvhZM3Bwm+L2adG1KGXi8whAcgIoLcqbzRMtZDBRqNtbomfszCsiSokZaSRsuJpyyom5IkjTeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNFlRber; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNFlRber"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474161F000FF;
	Wed, 23 Sep 2026 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173876;
	bh=EyVy42DJwbu9ocrIPsUMLg0Ybe400RiSa2VGIMd6s/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNFlRber2KTBcrOuiSLCwsohmz/edIGzHBj2KSNJ7VDO8gvE3NEBqK/lsHD+SJwZd
	 6zGB6ysKnTPTjq56Ktv5msAmten9xLyL2YLVPmjGtJfEgfuudHFlsW5cW3OmDlhYtq
	 tdtTWwuuWs6iraY9fRIqfaZZB+GIzQIZ9tP0N6kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 338/438] power: sequencing: fix NULL-pointer dereference in pwrseq_device_register()
Date: Wed, 23 Sep 2026 16:05:59 +0200
Message-ID: <20260923140653.576890686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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


