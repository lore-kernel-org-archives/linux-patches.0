Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC74196C9B;
	Thu,  6 Jun 2024 14:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682899; cv=none; b=nkr6wGlOpgaIGD2c0rUcdUWkybNQTPVhbfmOpj+eluu6MSlsj21Tppfkyu8saak+3UJ46iLk1a0lNubW5eaLV4uVhdzzkVaEuNH5/tJ61c4Ck5JyK7a7MbJ99G+uYwKOR2CO21ck3PmWyqbOVJk8OU4HTcJw3226ygYjSt3CwJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682899; c=relaxed/simple;
	bh=/qlWaS/edFAAiAonkzcf52ycEaqJ10W3lVmVeLaCx+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bxed4wUkzyyw5FGaf1n/ycL9e5HK6fBu8+Gn4IcUFT6iOkYLQ5ZUgWB4JFN6V6nEjDNsRDda7n4HPYHT79v1+ARlIiSFAsoZnPeEbM7P+93iolNVCoCUNc0AU4b5w6I85RMAxx0+d1zeTTi1KlTUV7lnUiLiuSG1MHkuWj15mCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUjr5H0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUjr5H0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E29CC32781;
	Thu,  6 Jun 2024 14:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682899;
	bh=/qlWaS/edFAAiAonkzcf52ycEaqJ10W3lVmVeLaCx+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUjr5H0Wcs+Llt5qloRqGVWyReKwXwobcRP1wLnqcglbOsnuHq2Ur+lElqO7UhZ5u
	 v8ju3jlUcPRQ+k/9qPIFMVTN+geq1oQok3sy+NX9s7HiLJajRnfJMsXKyiy2d6tAf5
	 YAIlI/5U6MG/a11DRKzU69wkn6ZEyICCuOvHU/8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 017/374] usb: typec: ucsi: simplify partners PD caps registration
Date: Thu,  6 Jun 2024 15:59:56 +0200
Message-ID: <20240606131652.349035981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 41e1cd1401fcd1f1ae9e47574af2d9fc44a870b3 ]

In a way similar to the previous commit, move
typec_partner_set_usb_power_delivery() to be called after reading the PD
caps. This also removes calls to
usb_power_delivery_unregister_capabilities() from the error path. Keep
all capabilities registered until they are cleared by
ucsi_unregister_partner_pdos().

Fixes: b04e1747fbcc ("usb: typec: ucsi: Register USB Power Delivery Capabilities")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240329-qcom-ucsi-fixes-v2-5-0f5d37ed04db@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 7a427c8e92e29..7801501837b69 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -824,12 +824,6 @@ static int ucsi_register_partner_pdos(struct ucsi_connector *con)
 			return PTR_ERR(cap);
 
 		con->partner_source_caps = cap;
-
-		ret = typec_partner_set_usb_power_delivery(con->partner, con->partner_pd);
-		if (ret) {
-			usb_power_delivery_unregister_capabilities(con->partner_source_caps);
-			return ret;
-		}
 	}
 
 	ret = ucsi_get_pdos(con, TYPEC_SINK, 1, caps.pdo);
@@ -844,15 +838,9 @@ static int ucsi_register_partner_pdos(struct ucsi_connector *con)
 			return PTR_ERR(cap);
 
 		con->partner_sink_caps = cap;
-
-		ret = typec_partner_set_usb_power_delivery(con->partner, con->partner_pd);
-		if (ret) {
-			usb_power_delivery_unregister_capabilities(con->partner_sink_caps);
-			return ret;
-		}
 	}
 
-	return 0;
+	return typec_partner_set_usb_power_delivery(con->partner, con->partner_pd);
 }
 
 static void ucsi_unregister_partner_pdos(struct ucsi_connector *con)
-- 
2.43.0



