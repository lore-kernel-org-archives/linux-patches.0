Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7FF2F617C;
	Sat, 12 Sep 2026 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238700; cv=none; b=S6t8OzJWznv2mUztk1caEok83YMae5cRqPpaW/EkFeco8/q+25imWEv6ZtGkZDaJntWPTY0RmNI6l/ICjKeuU/QAhDa6mUJ0OoaLNUSqd4EXGFpc6FBWZk+hSGE+jlc02xRxuWV50597LG3ovK6AWeOHtbgO9K5pQBUnBrFbG7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238700; c=relaxed/simple;
	bh=UjXI1HQecAbajo4kW0IX5s2Tm7XA7FDFj6tG2vmG8Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3VniUcPw993FI1TilHK9HXf9awXSizoFkTw+hPzj4P3M+EuKW6Itou1CmFUbKZ1xrNHkgiQAUIoTc7EdrxmLevsrwjZIxd2eZ0HQ7nARID1dUg2aEJXHSJcj9uR38ySyehU+xQ8tIovjVujQUZNFzqZIMfacQDXuzOu+0ZASbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFzpo9zL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFzpo9zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1251F00893;
	Sat, 12 Sep 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238699;
	bh=aHqkWK9XYj9qzpcPE+drwpIvLvvVIPhiatyv6GkRsUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFzpo9zLVEn7j3X5+b2+JgoQ1eHrK9+N/ZtcfMFcKrrb1wGbjgaa6W0WpoMRFZsPs
	 MApL6banOjAHDpMcOTfbDhr8pnG58AaN27FEJ4ZVIZcpqwStu9imD703CHIoZqjG9b
	 FNRxW053vWclHKnhW+76laT3PCLRhdPlEtsK19bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deesin@codeaurora.org>,
	Arun Kumar Neelakantam <aneela@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 515/935] rpmsg: glink: Remove the rpmsg dev in close_ack
Date: Sat, 12 Sep 2026 08:59:05 +0200
Message-ID: <20260912065538.634948988@linuxfoundation.org>
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
index 3c803fade07db..8719790eefcd9 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1571,6 +1571,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 
 		rpmsg_unregister_device(glink->dev, &chinfo);
 	}
+	channel->rpdev = NULL;
 
 	qcom_glink_send_close_ack(glink, channel->rcid);
 
@@ -1584,6 +1585,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 
 static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
 {
+	struct rpmsg_channel_info chinfo;
 	struct glink_channel *channel;
 	unsigned long flags;
 
@@ -1601,6 +1603,16 @@ static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
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



