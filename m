Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9BA384232;
	Sat, 12 Sep 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232956; cv=none; b=S/wb6Bny7S3MaK7bMPHmvCjMQfOLQBaBK9x2SvnWu2IhojugN8m5T8dhkyBsQrJzm8bJ9DEBOnrEB/tbuystvl4Y4x6RFjb4F/ClDkc/6WYicrFVKA75S7SDLWKN6JNMSkixbLUQgt71RwZctY81RfhtRKVckIQTvStaGLGar4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232956; c=relaxed/simple;
	bh=f9WpneddE4NIJ1+Ulnjtut9p2pnMesjPmnrJXdcrEds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXtdnnkshjiV31y9bwJCcJEJKMh39DydLwhdoOfLMMJ/w7YhRLLo4HRrdyXLCoAxHYhn4/gNBAnS+MqkC2Z/oaCAn1wSUclfLtH/z72FcCGs6YQvufQLVg1wNPChiqBZ5P5Vrq/kWKwj2Kn8e/OyU4flZ0ase/2u9yEyOD11cqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDaK8Vwr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDaK8Vwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E291F000FF;
	Sat, 12 Sep 2026 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232954;
	bh=lojH26vp04LRtCcb7B4mT7oUwnlcU1nW5MxoeXYbBF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDaK8VwriMNWip8Y6hikmUSw+rLShzg/CoaoyRQZQfU3C5SS4HijC8vo7WdEIjHqE
	 laYOtRyQPa6hnQQjc6Jc0LEhm8WY1ULI6E45AtIM+FSU5M++WmM/ED1UpA+HVw+Y0F
	 WtmR/T9gn8aAru7rSywMy0AZaE8J83s2HOTcakHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tien Sung Ang <tien.sung.ang@altera.com>,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 5.15 079/935] fpga: stratix10-soc: Fix SVC mailbox handling during reconfiguration
Date: Sat, 12 Sep 2026 08:51:49 +0200
Message-ID: <20260912065528.643628011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Tien Sung Ang <tien.sung.ang@altera.com>

commit c14a8b15c87b49efc3ef898cec8ac7c30336a080 upstream.

Fix incorrect stratix10_svc_done() usage during FPGA reconfiguration.

Do not call stratix10_svc_done() at the end of write_init() on success, so
the SVC session remains active through write() and write_complete(). Call
stratix10_svc_done() on failure in write_init() and write() so the shared
SVC mailbox is released when reconfiguration aborts, allowing coexistence
with other SVC clients such as soc64-hwmon.

Fixes: e7eef1d7633a ("fpga: add intel stratix10 soc fpga manager driver")
Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Tien Sung Ang <tien.sung.ang@altera.com>
Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/8768ce3260489c9febdfce08e27d03f5f5ed9c33.1782801986.git.tze.yee.ng@altera.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/stratix10-soc.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/fpga/stratix10-soc.c
+++ b/drivers/fpga/stratix10-soc.c
@@ -194,20 +194,18 @@ static int s10_ops_write_init(struct fpg
 	ret = s10_svc_send_msg(priv, COMMAND_RECONFIG,
 			       &ctype, sizeof(ctype));
 	if (ret < 0)
-		goto init_done;
+		goto init_error;
 
-	ret = wait_for_completion_timeout(
-		&priv->status_return_completion, S10_RECONFIG_TIMEOUT);
-	if (!ret) {
+	if (!wait_for_completion_timeout(&priv->status_return_completion,
+					 S10_RECONFIG_TIMEOUT)) {
 		dev_err(dev, "timeout waiting for RECONFIG_REQUEST\n");
 		ret = -ETIMEDOUT;
-		goto init_done;
+		goto init_error;
 	}
 
-	ret = 0;
 	if (!test_and_clear_bit(SVC_STATUS_OK, &priv->status)) {
 		ret = -ETIMEDOUT;
-		goto init_done;
+		goto init_error;
 	}
 
 	/* Allocate buffers from the service layer's pool. */
@@ -216,14 +214,16 @@ static int s10_ops_write_init(struct fpg
 		if (IS_ERR(kbuf)) {
 			s10_free_buffers(mgr);
 			ret = PTR_ERR(kbuf);
-			goto init_done;
+			goto init_error;
 		}
 
 		priv->svc_bufs[i].buf = kbuf;
 		priv->svc_bufs[i].lock = 0;
 	}
 
-init_done:
+	return 0;
+
+init_error:
 	stratix10_svc_done(priv->chan);
 	return ret;
 }
@@ -341,6 +341,9 @@ static int s10_ops_write(struct fpga_man
 	if (!s10_free_buffers(mgr))
 		dev_err(dev, "%s not all buffers were freed\n", __func__);
 
+	if (ret < 0)
+		stratix10_svc_done(priv->chan);
+
 	return ret;
 }
 


