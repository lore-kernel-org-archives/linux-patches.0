Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E5D26ED46;
	Sat, 12 Sep 2026 19:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242530; cv=none; b=uOtWwnzuJfDOCnf4V7cEYqmECyS/VH8xAEdvnWsQ5jiKnhoa5/GgKxadzX5QNYNFZyMMdncrs6/Q0dc0oHrHBiOXRX4M0yYeOazCy0xuHN6mRojV+Va8DJso2L4St7/MFMcBP8JNm+5+rpjKOYcpm6w2f0oFei9zfiRquMa2mDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242530; c=relaxed/simple;
	bh=KAwT9JXBVJo+fQDxhRWyNDuSQ1nZlJaSdPzZY83tMnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuzsUOsRGy/JWUCSlEAR3NyVcSHkwFj8sV1CpT8PoZs+t/2a+ijEBw6IyoOU08FeR+Yptmtos2dltcO5UDZY9VZlwUQ1JMLIw46NLIwkLCE0pD0MXyoZawtHVZAeLgQryP1ep3TxOagtZlTIYh6Eb+Oi3fZQRYG1LkFWSsf5LKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwefo3Re; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwefo3Re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A671F000FF;
	Sat, 12 Sep 2026 19:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242529;
	bh=VJL5if1kq8AU3qA+yXDWQeu6binTSulSuwm/HwL7/zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwefo3Reg/TFpIbQc0BGqQ4/R11gB12dUo2OXYduyP1riKhQtHTfmqr/E575qBcx7
	 6PehR90LCJTFqpVnTzZj3Ants1DqIb84AT0pmmLSvoTNeKzkohudbC70sPogrz3upN
	 OW9gdEbW4b4UBYWQBzOAVBsi/DJiJjb18jwwND7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deesin@codeaurora.org>,
	Arun Kumar Neelakantam <aneela@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/798] rpmsg: glink: Remove the rpmsg dev in close_ack
Date: Sat, 12 Sep 2026 09:01:05 +0200
Message-ID: <20260912065527.157645548@linuxfoundation.org>
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

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

[ Upstream commit c7c182d4447e172f87e37d6c04879b94b8635b37 ]

Un-register and register of rpmsg driver is sending invalid open_ack
on closed channel.

To avoid sending invalid open_ack case unregister the rpmsg device
after receiving the local_close_ack from remote side.

Signed-off-by: Deepak Kumar Singh <deesin@codeaurora.org>
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
[bjorn: s/strlcpy/strscpy/]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1596086296-28529-5-git-send-email-deesin@codeaurora.org
Stable-dep-of: 5a5a48e788e0 ("rpmsg: glink: fix deadlock in endpoint destroy during driver detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index e5e0924935b9b..02e0f09e7d787 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1555,6 +1555,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 
 		rpmsg_unregister_device(glink->dev, &chinfo);
 	}
+	channel->rpdev = NULL;
 
 	qcom_glink_send_close_ack(glink, channel->rcid);
 
@@ -1568,6 +1569,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 
 static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
 {
+	struct rpmsg_channel_info chinfo;
 	struct glink_channel *channel;
 	unsigned long flags;
 
@@ -1585,6 +1587,16 @@ static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
 	channel->lcid = 0;
 	spin_unlock_irqrestore(&glink->idr_lock, flags);
 
+	/* Decouple the potential rpdev from the channel */
+	if (channel->rpdev) {
+		strscpy(chinfo.name, channel->name, sizeof(chinfo.name));
+		chinfo.src = RPMSG_ADDR_ANY;
+		chinfo.dst = RPMSG_ADDR_ANY;
+
+		rpmsg_unregister_device(glink->dev, &chinfo);
+	}
+	channel->rpdev = NULL;
+
 	kref_put(&channel->refcount, qcom_glink_channel_release);
 }
 
-- 
2.53.0



