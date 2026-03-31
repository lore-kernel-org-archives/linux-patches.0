Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABF1401A2C;
	Tue, 31 Mar 2026 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974534; cv=none; b=Sbaf5n/NCyTszg54jDxW7cQBFT2NAlq/EEc2spF6G9U0lrCr65o344J6oJkCKgNTXH+jQguFp1+121LbD8/Ra9udvrGr08S1AtLCwDRXN8Mj28Y6IuI+4l2K3IqUj/vN4do61pIB7Oa0k1+EPG1Ss+TryaqKPovoOf2G/tDQSro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974534; c=relaxed/simple;
	bh=CDZevVEZHksHHZ3fA7fnXnQ1fWg/SykH50nQhBp4B58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXDkQrhofjBX5ptQG4q6dNCuXYW71yhToMAfBpqLSgmTggAuIlL47/wmdaQxAH68+kRDrTfbH5RiQF4Qil34a87BfH/tSCuaooDCa9tbg0aaJRNKx0ufMaUo1f0d2tcHZOUNO/0WgkRUMYP8JFkd6Wl4qdNZaRLXl/oT7nKrrYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEEpriFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEEpriFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20252C19423;
	Tue, 31 Mar 2026 16:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974534;
	bh=CDZevVEZHksHHZ3fA7fnXnQ1fWg/SykH50nQhBp4B58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEEpriFzfId4BxSgkQMRo6+4hk7IKHpacmfXV1Uk+qMCrnBaJwqA/zCTMnq4IU7f/
	 MM7N/6NoDGJm2bGeJiucHRyW2QysNcCTE0i9WfzvQ+mrM2hwrDSrl9DczN32/gApns
	 cokxjbYAPKCpUPfiU7VIj7u+24v5TXvzo5ydg0z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.6 123/175] irqchip/qcom-mpm: Add missing mailbox TX done acknowledgment
Date: Tue, 31 Mar 2026 18:21:47 +0200
Message-ID: <20260331161734.299586652@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -305,6 +305,8 @@ static int mpm_pd_power_off(struct gener
 	if (ret < 0)
 		return ret;
 
+	mbox_client_txdone(priv->mbox_chan, 0);
+
 	return 0;
 }
 
@@ -414,6 +416,7 @@ static int qcom_mpm_init(struct device_n
 	}
 
 	priv->mbox_client.dev = dev;
+	priv->mbox_client.knows_txdone = true;
 	priv->mbox_chan = mbox_request_channel(&priv->mbox_client, 0);
 	if (IS_ERR(priv->mbox_chan)) {
 		ret = PTR_ERR(priv->mbox_chan);


