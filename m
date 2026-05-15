Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162D33CB2FD;
	Fri, 15 May 2026 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862359; cv=none; b=Ol0U1O5gXHtH5wYvYTq9qo7vZc0kxrrIhMmwuEpO32IU8imGpykXXChpEYJ7tvlZpxlo28SSStQq5wL9dcw9lZBLnzo+VjQzcVd1qphvW+D6VpmoACt0lizeSUXa2jeeGkEsV2O7XEmKRHapbcAkQYKg5xk49R5O3NCRR6Dk1iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862359; c=relaxed/simple;
	bh=hVK0OAfE5kTK1tyayH4x/RU1kLYkVX+fYVkJajAaWag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYPjqbeo1adSf45mWU+0VqaAFreyal0godkrsnVmS+poVxJVaJ60BrzR0KUjo5YTZOqGWPeVhhADvrIiN1H3XzxGMr2SEhkMmKoylq0mAnEQ+wID11KK09Q5LIihl2MLK1QOa6/jWSfC9ANz2m02HmRPwqCMjgto/oA0P5nGDQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBSYmSES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBSYmSES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9B1C2BCB0;
	Fri, 15 May 2026 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862359;
	bh=hVK0OAfE5kTK1tyayH4x/RU1kLYkVX+fYVkJajAaWag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBSYmSESO11Edaa9Q2QrWaeGtDYe9Ajgnh3IAoGpK/UaXins1VSgGOhIv7EVa7Msl
	 3flClupA3ievDl/mvfrA+VJTeFBd7iJxO5ChwtjMkK5O6qQTOOkiAHpTelM3WsW8Bl
	 zjeete5R26qrZpjyqZc2ejQBJOouVptxkzoXWscc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 019/201] media: i2c: ov8856: free control handler on error in ov8856_init_controls()
Date: Fri, 15 May 2026 17:47:17 +0200
Message-ID: <20260515154658.950333270@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1951,12 +1951,18 @@ static int ov8856_init_controls(struct o
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
 
 static void ov8856_update_pad_format(struct ov8856 *ov8856,


