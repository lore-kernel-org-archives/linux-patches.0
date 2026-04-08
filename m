Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D619347517;
	Wed,  8 Apr 2026 18:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671887; cv=none; b=hoy752azLxdr8Trs8YsGsTf4ososZN9PIAh6TI8kx3/fO5Sg7KWbZUrdFR9znhJXL8vqPBFVIUEMhKQ/nNKlQKw3XxPsdkszqF+qSRk4XONSCJzwDlpSj7eLb/IKfQNFrYUf650lDNzPZYBC/WDlNgWSTPwgjfpRUgCWGjYkfNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671887; c=relaxed/simple;
	bh=qjTMk/3X/qu0GFRlz5B4DM+nfLB20UYpeaPCpWQfQhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cutDbOw6pfIGy90vY1SYszf8mqG2qf26TUruFrizwV48uG1mSfX0UelVSB2mxKW1t5qpfdvbNpBPUoYvLhldDKAHArFwcqBjVyySzJ1jssfEbIcILMvhr2wstg2nCUmFW+oQaWOWL5fZqAG9yz0hsKY9sqtLj+xKB5bpC8HeaIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/+mv/44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/+mv/44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8303C19421;
	Wed,  8 Apr 2026 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671887;
	bh=qjTMk/3X/qu0GFRlz5B4DM+nfLB20UYpeaPCpWQfQhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/+mv/44WSQsoL/BHa7G5Co1B/Xi8zn/vfMciStet3TujbMGclGFaFmnFuqq6ziao
	 7y0vE80GnsPZksNZLMCQN7s29R3g0E6JBL/LEMZMg2g8pQIIWFDZhw2/6GpWb6eFqg
	 EXb3iKwEvTsZOhK9p+oYYlupDyspvwRZMf5KvmE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.1 106/312] irqchip/qcom-mpm: Add missing mailbox TX done acknowledgment
Date: Wed,  8 Apr 2026 20:00:23 +0200
Message-ID: <20260408175937.721627250@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


