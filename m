Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A061F7594;
	Tue,  3 Dec 2024 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242170; cv=none; b=g/gAyqPQtuxSftlmUaZeoxl4D/XcW0TilQImM0xs64C6h7GEjD7Em0HCtGPPOq8kKN0wCz30ZuCfuQLrs4JDkhKM3tpBTyzFToYQNpcGd++tTiuH3Fj1n1UwMH6ABbYpa3hKK+SYq8LJsOvuWxLsalxGP1znHGgGUwRLvtgVMu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242170; c=relaxed/simple;
	bh=umbg/WYitkCWXtcv3QZnQiPAnM+PiqIva8r5JhrENyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWQ5uvhvIrG4YQX7Ya5P+gutAJbdGTNsYc4a8xIt1NNhaBuhUoHilM/JY7He/WvPJzRWRmInsiLsL08fdL0X1eENc80iQUQZYOjCO3iM6z6zUwkdjtjSRaIohK0k9HiBOrJH8pE9TLQe1r/hjl3FX8tlc75iwdORVde9TvybD14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxJ68xa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxJ68xa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE33C4CECF;
	Tue,  3 Dec 2024 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242169;
	bh=umbg/WYitkCWXtcv3QZnQiPAnM+PiqIva8r5JhrENyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxJ68xa5BFys13Jb7cxtG/QIz/9gLAtklH6Q5S6vNdgprGu8K5gxfyccP4oskyJaZ
	 xjkHOTHq8znuIg8qQOfbS3bC7ZeCgWkkNJIX7u/C/xPMFD+opxVea1iCBaX/IJ/s3r
	 V+mA3MsjJXgMt99xFj7fbGfwz5OIsQUf+hv6DNQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.12 628/826] usb: typec: ucsi: glink: fix off-by-one in connector_status
Date: Tue,  3 Dec 2024 15:45:55 +0100
Message-ID: <20241203144808.250181705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 4a22918810980897393fa1776ea3877e4baf8cca upstream.

UCSI connector's indices start from 1 up to 3, PMIC_GLINK_MAX_PORTS.
Correct the condition in the pmic_glink_ucsi_connector_status()
callback, fixing Type-C orientation reporting for the third USB-C
connector.

Fixes: 76716fd5bf09 ("usb: typec: ucsi: glink: move GPIO reading into connector_status callback")
Cc: stable@vger.kernel.org
Reported-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241109-ucsi-glue-fixes-v2-1-8b21ff4f9fbe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -185,7 +185,7 @@ static void pmic_glink_ucsi_connector_st
 	struct pmic_glink_ucsi *ucsi = ucsi_get_drvdata(con->ucsi);
 	int orientation;
 
-	if (con->num >= PMIC_GLINK_MAX_PORTS ||
+	if (con->num > PMIC_GLINK_MAX_PORTS ||
 	    !ucsi->port_orientation[con->num - 1])
 		return;
 


