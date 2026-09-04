Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBCD35B632;
	Fri,  4 Sep 2026 05:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500871; cv=none; b=eh1vlljUdck/eznAI0EsJmGuf7Fd2X/rHAxbJ71kgwvPgUaagexsZBgRwSCQxh9qqR/BkT7rszOR6/DbSBoNX5s4MiR7oqmRHap3fjw0UsgFl6CeZmhpLh2DN6sU0pWV5CCGtPTcXf+eU9pkRhwRXdB8v6p+nnPGN5hYwmpY6O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500871; c=relaxed/simple;
	bh=ozcY+dKkq3Iy3y3mBSOlETmYZSvJDlOAB7Qr3U6+Qhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8XwF9/7paK0Z7vpBPPLH5a8qgXV7e2o/0M2SnfDIqq5ep5ReWuhSrflF1sH8BUA/otVdsT3MkzY4YzG/ijAgcQnNcSXJqAak1pTsWqBR3pgMq06vUGIKxLzrDLbMY6YkzfMePbO57Epppll9PvUg3y28v2jy8fLd079QlpYGEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKcyF4T5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKcyF4T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B771F00A3D;
	Fri,  4 Sep 2026 05:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500870;
	bh=YdgB9D1rAU5betbIH2smCdY35BH1kT39TOYET2ob8Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKcyF4T59OnjrCcDmMFpoyfxXjEBYtIelMZwr1kITC8nzkOlncb8K3pzXdIOGK7kD
	 I/JsdO+k5DDUMeoIbzeSpfPHS0DhnRV9GPkOtihYkvwMf0Xu6Z+GnrSwep3qter2W4
	 WRzCFaFNBjhUxLJWrf0qyDu1z4J9gPoCX9BqNWc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tien Sung Ang <tien.sung.ang@altera.com>,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.18 207/552] fpga: stratix10-soc: Fix SVC mailbox handling during reconfiguration
Date: Fri,  4 Sep 2026 06:56:04 +0200
Message-ID: <20260904045753.988588388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -195,20 +195,18 @@ static int s10_ops_write_init(struct fpg
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
@@ -217,14 +215,16 @@ static int s10_ops_write_init(struct fpg
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
@@ -342,6 +342,9 @@ static int s10_ops_write(struct fpga_man
 	if (!s10_free_buffers(mgr))
 		dev_err(dev, "%s not all buffers were freed\n", __func__);
 
+	if (ret < 0)
+		stratix10_svc_done(priv->chan);
+
 	return ret;
 }
 


