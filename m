Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35071478E47;
	Fri,  7 Aug 2026 15:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117582; cv=none; b=Lsp03tDcGrxKqEsBmtL9w2iOUygeE9uZiO7VSNw0qOtfRf2MZOAXtI+CW4yT5MK86nnBmscCV3CwVei3/ra+seBCyk8pBLGpR75J11qZ8k6E2eVW+zYb8/t1uEcwQwB8Yn3l45O9VH2/qPBkhp4ObhLiAIUFTkxfbATJk1HU+3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117582; c=relaxed/simple;
	bh=/sA6uDIqUzFsmnoa/hXAvlbdholKthJHTQCtw+JH/Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaxEOyEkMPAtQ7XdhUmUjtrtO8pUI4FmwBWOzPor/4J2O/KB5p4IxOnVNO02VL5O6WHHDu++i9mWTvqWwEWQ4Yv4iV29VgCw2jtHvYvp7Z8KNysN8cx7QuKnIf6Xk9ZY7/qSLv8awx6tTNyJqw3L+5DeahKaY/uQIdKeBTAcFiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ue4NJPwy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ue4NJPwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5441F000E9;
	Fri,  7 Aug 2026 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117581;
	bh=cVLbAtvbUegLu5h34aZlrvITcDFWaet5vjtWj4tYjho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ue4NJPwyX3jprLu2kwUs/FJ/uP2tlwN5Zotnys/vZkTezrtptv6P/sgXrbb1EcXvH
	 z0f/PZtE12sS0Q1Um8cd7s3Yy4Cn0vOzxqUzis3MtVbhoUxU6SZ/Ax63xH/8z7BULL
	 o3wdzJWN7bvfcb+KTro0n45NKH5c3uSSNWhkfLDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 370/438] can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()
Date: Fri,  7 Aug 2026 16:39:26 +0200
Message-ID: <20260807143435.859572631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 941eaf9a6d3b33dea49f2c0a1da7546a03b6ff71 upstream.

The memory allocated for cmd is not freed after the call to
kvaser_usb_send_cmd() in both the normal and error paths.
Fix that by adding a kfree() immediately after the call.

Fixes: 39d3df6b0ea8 ("can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260722103906.108571-1-nihaal@cse.iitm.ac.in
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1626,6 +1626,7 @@ static int kvaser_usb_hydra_get_busparam
 	reinit_completion(&priv->get_busparams_comp);
 
 	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
+	kfree(cmd);
 	if (err)
 		return err;
 


