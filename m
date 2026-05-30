Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116842628D;
	Sat, 30 May 2026 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163756; cv=none; b=k34QswT7wii1Xs8KRO94H6Pw0/6oi1IS72rcej1feZbRRFjns444uNbEkdLEtVj9rZE3OA6ARQwQ7IWxU1rlRRWeHvu27fbk/DFML3/8KOWNcedsITjdAPe5NduhPtnIow9oMo3aslbCqpECETxvDnHgG9SPWY5DkPVDACplslI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163756; c=relaxed/simple;
	bh=XXxrP6RKuwLGu3c/o7ZZKdhMtMQoJfDQhNfhyjsygTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR/hDf7dHmhXaw/e2sPUSL4/epc/+4xdYZckJ9lL5PgH2GMxYe8/tQ8uQQ2PNyBxwKZuxLHWI7brp9UESu4OOpnWsaSLgX4EKHsHxc8J84uh0XjHlfDd6pejHarXPW8n8rMJSp0NcSkhmA0V+uwYg9Em2RQ1gtXhFRnyFMxldjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ0+CX5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ0+CX5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556B51F00893;
	Sat, 30 May 2026 17:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163755;
	bh=096cl68fWOV5x1GLy9xwO/uKYPxL9wd1C/GdvXSgl0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQ0+CX5ZhiJl7SNeP3eMfM5MGmAEP3H16EgowYusnRa/t9nHdcYhOn8VXcrAVIPyC
	 elU2N/c1HgojmGPugmRAxCQZDa42itT6gIlJIm5pQ0yeB9nIwPqUvHVunKwvFhKWLA
	 TO/YkE+XWrkKRYoIWr6hPONDQmmjb4VGUTx1V/eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 352/776] media: i2c: ov8856: free control handler on error in ov8856_init_controls()
Date: Sat, 30 May 2026 18:01:06 +0200
Message-ID: <20260530160249.678806183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <akoskovich@pm.me>

commit f75e160745663ce9b13362ae6e90bd439c58df69 upstream.

The control handler wasn't freed if adding controls failed, add an error
exit label and convert the existing error return to use it.

Fixes: 879347f0c258 ("media: ov8856: Add support for OV8856 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov8856.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -1896,12 +1896,18 @@ static int ov8856_init_controls(struct o
 			  V4L2_CID_HFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(ctrl_hdlr, &ov8856_ctrl_ops,
 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
-	if (ctrl_hdlr->error)
-		return ctrl_hdlr->error;
+	if (ctrl_hdlr->error) {
+		ret = ctrl_hdlr->error;
+		goto err_ctrl_handler_free;
+	}
 
 	ov8856->sd.ctrl_handler = ctrl_hdlr;
 
 	return 0;
+
+err_ctrl_handler_free:
+	v4l2_ctrl_handler_free(ctrl_hdlr);
+	return ret;
 }
 
 static void ov8856_update_pad_format(const struct ov8856_mode *mode,


