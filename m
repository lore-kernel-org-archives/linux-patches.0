Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D02F36828B;
	Sat, 12 Sep 2026 19:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241113; cv=none; b=G7eoIcJ3BQ0GTRipv1l89cQ0BDyyce8He277t6MJjXhkHTMrNTt1pYCu143iXHRBC7J7pxh65l/4aJgH6HhqwpjvtZF69XQdrWRaXEc0oNkTz60dO6cb0PfSVYFaq2zFtpGbgL6KlIruz6QHFKeDngj25BTcOt3mmkAOooRtP7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241113; c=relaxed/simple;
	bh=D/l4R2AqBlmTSGjBOxXOKk0CDbAJZXdzJgJV97WQPXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcYJL2/q99BdvboQbtfSAshLylDFiXw0xeWehJusrkzA2NR9br3Yx47VD497u5h3beMotlenX1Zn5xEFl/xeP7aHc7VUv7TbiewqnYCGlB8Y3KQszQZkBhk5/BJUWG86a+ru59hAtSAp8tCj0DNG5qLa6xJfRye4u6JqjPkxaEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lez+FNvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lez+FNvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266B01F000FF;
	Sat, 12 Sep 2026 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241112;
	bh=8EEc3edEK4wxVL+pXN9lwz/SKPrMl4lKwwtKuE4wmEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lez+FNvN9iepwvF5MqJzgyYiHMs3Tnxax9HOw3E2r4fEf4xcED5kPHM8UDnWJPB+o
	 mGOyzTbTBTDtdTpWDLFs5kEqutYnT5mz9mXbiiWECTsEFMRluiABSxM6vZvXBay/Ej
	 78Ezzf220CA6u0Z0WyeGSUfZHzfQ4ve83Ldtoe5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tien Sung Ang <tien.sung.ang@altera.com>,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 5.10 070/798] fpga: stratix10-soc: Fix SVC mailbox handling during reconfiguration
Date: Sat, 12 Sep 2026 08:54:58 +0200
Message-ID: <20260912065518.568871767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


