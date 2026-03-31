Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E236F426682;
	Tue, 31 Mar 2026 16:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975332; cv=none; b=Dor1yhMoMW3VqKNhZEeoGBcGnf63jduT9wJYDEdUj0kozcFsR1bBjK/Mt8MuaPTGvAjtk2ZiCSFoWzBxXBR47Vf+v+OZBfUpCJWVQt3eD02JBzc/P4X08JIV8rdhoi57Np+x/i6eIpo4cIUraiEuBlbJmccyDY/PjFs/wrzeRF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975332; c=relaxed/simple;
	bh=Gz+FjxN4acfyPNamPiNA17OYmSCptDcIm5ViQY0t1QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ot/So2nPNQP/XwA+crfhvpYCRdkqKOXtv3JuXU+/ayqtkiyKN0E/dt9dAkDDgeJmFgXRIISzUnQuofZqeaxc4cA4N5fMH2NR93w6+SAzvMQKrPYoTaMiqumo5dUBWjgI2dvjHx7sB7rzea2xg4BnV2MvXfxIuVB6I2CTTGHzYmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlPbnI9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlPbnI9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79093C19423;
	Tue, 31 Mar 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975331;
	bh=Gz+FjxN4acfyPNamPiNA17OYmSCptDcIm5ViQY0t1QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlPbnI9Klrm9MNLSHd8jzwp+7Dhw5FRgOrQzo/1IrmxjjXlc1+FpNRN42DESOZOmd
	 K8ZFh5qDvGdMOqPN20u5smxst+fNVyIihKyH3BdmLAh7yktb24+no0Ikxf2+A9qErL
	 sJ/y08zj8QXpFhksjuxk1CUP/K8MMDPbm/nAgtMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.19 253/342] irqchip/qcom-mpm: Add missing mailbox TX done acknowledgment
Date: Tue, 31 Mar 2026 18:21:26 +0200
Message-ID: <20260331161808.266878398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jassi Brar <jassisinghbrar@gmail.com>

commit cfe02147e86307a17057ee4e3604f5f5919571d2 upstream.

The mbox_client for qcom-mpm sends NULL doorbell messages via
mbox_send_message() but never signals TX completion.

Set knows_txdone=true and call mbox_client_txdone() after a successful
send, matching the pattern used by other Qualcomm mailbox clients (smp2p,
smsm, qcom_aoss etc).

Fixes: a6199bb514d8a6 "irqchip: Add Qualcomm MPM controller driver"
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260322171533.608436-1-jassisinghbrar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-qcom-mpm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/irqchip/irq-qcom-mpm.c
+++ b/drivers/irqchip/irq-qcom-mpm.c
@@ -306,6 +306,8 @@ static int mpm_pd_power_off(struct gener
 	if (ret < 0)
 		return ret;
 
+	mbox_client_txdone(priv->mbox_chan, 0);
+
 	return 0;
 }
 
@@ -434,6 +436,7 @@ static int qcom_mpm_probe(struct platfor
 	}
 
 	priv->mbox_client.dev = dev;
+	priv->mbox_client.knows_txdone = true;
 	priv->mbox_chan = mbox_request_channel(&priv->mbox_client, 0);
 	if (IS_ERR(priv->mbox_chan)) {
 		ret = PTR_ERR(priv->mbox_chan);


