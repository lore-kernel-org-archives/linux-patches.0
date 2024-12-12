Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524BC215777;
	Thu, 12 Dec 2024 15:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017528; cv=none; b=FUqCbUR7mGw3tA7SfutZZCyTDg66YuGWCHoxszz/g5bTRESpdHaLHJOCJu/AcG+GOoSKe0Uafc/wbjNqWtMuIG+loww90keCF37Bg1zuNqs9Hmv3s0r3SrkyuNc/sQjwFW4ehzMr0Q4v1yGImt0WFfh33B0C/E8dUOgGXwdlljA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017528; c=relaxed/simple;
	bh=HZagMqy40atOC7zuZrPeMmQkN1hTf/dxx6hKx6Ajt4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STNf8VK3Wiv4Edy7W/Lzjv4SCDnieXUoSbOvFnwer2o2fPXCecE5CAfsbNnro0BmUoRus2BenDLf7Q+wJ/sZg+6HKMHzUEb6L14zKCItJPDJZTeimTm52QzlD+BY4I37Or+7fZ8vDxpLkczV1N7+yRRX48Ttqayc7rnqdtJxzpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEYAT7Z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEYAT7Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA5AC4CECE;
	Thu, 12 Dec 2024 15:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017527;
	bh=HZagMqy40atOC7zuZrPeMmQkN1hTf/dxx6hKx6Ajt4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEYAT7Z+IqOPWfqoPJZBa7j3jh8lJhY16utM37K1aMGl3enIkmYGHklZG2huyNPKi
	 OhXPdpFMA3iQIjfZn23UUos+mS3iw7/8KkeMEiomKxtww3V5mmEnVybLki1arytdwh
	 u1xw2v1t/3KeAhWDVAvyvpHRBcXX0qSZjwkS7UWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Jan Karcher <jaka@linux.ibm.com>
Subject: [PATCH 6.6 039/356] net/smc: mark optional smcd_ops and check for support when called
Date: Thu, 12 Dec 2024 15:55:58 +0100
Message-ID: <20241212144246.173452379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit d1d8d0b6c7c68b0665456831fa779174ebd78f90 ]

Some operations are not supported by new introduced Emulated-ISM, so
mark them as optional and check if the device supports them when called.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-and-tested-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 0541db8ee32c ("net/smc: initialize close_work early to avoid warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/smc.h | 14 ++++++++------
 net/smc/smc_ism.c |  9 ++++++++-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/net/smc.h b/include/net/smc.h
index a0dc1187e96ed..9dfe57f3e4f0b 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -63,12 +63,6 @@ struct smcd_ops {
 	int (*register_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb,
 			    struct ism_client *client);
 	int (*unregister_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
-	int (*add_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
-	int (*del_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
-	int (*set_vlan_required)(struct smcd_dev *dev);
-	int (*reset_vlan_required)(struct smcd_dev *dev);
-	int (*signal_event)(struct smcd_dev *dev, struct smcd_gid *rgid,
-			    u32 trigger_irq, u32 event_code, u64 info);
 	int (*move_data)(struct smcd_dev *dev, u64 dmb_tok, unsigned int idx,
 			 bool sf, unsigned int offset, void *data,
 			 unsigned int size);
@@ -77,6 +71,14 @@ struct smcd_ops {
 	void (*get_local_gid)(struct smcd_dev *dev, struct smcd_gid *gid);
 	u16 (*get_chid)(struct smcd_dev *dev);
 	struct device* (*get_dev)(struct smcd_dev *dev);
+
+	/* optional operations */
+	int (*add_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
+	int (*del_vlan_id)(struct smcd_dev *dev, u64 vlan_id);
+	int (*set_vlan_required)(struct smcd_dev *dev);
+	int (*reset_vlan_required)(struct smcd_dev *dev);
+	int (*signal_event)(struct smcd_dev *dev, struct smcd_gid *rgid,
+			    u32 trigger_irq, u32 event_code, u64 info);
 };
 
 struct smcd_dev {
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index a33f861cf7c19..3623df320de55 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -105,6 +105,8 @@ int smc_ism_get_vlan(struct smcd_dev *smcd, unsigned short vlanid)
 
 	if (!vlanid)			/* No valid vlan id */
 		return -EINVAL;
+	if (!smcd->ops->add_vlan_id)
+		return -EOPNOTSUPP;
 
 	/* create new vlan entry, in case we need it */
 	new_vlan = kzalloc(sizeof(*new_vlan), GFP_KERNEL);
@@ -150,6 +152,8 @@ int smc_ism_put_vlan(struct smcd_dev *smcd, unsigned short vlanid)
 
 	if (!vlanid)			/* No valid vlan id */
 		return -EINVAL;
+	if (!smcd->ops->del_vlan_id)
+		return -EOPNOTSUPP;
 
 	spin_lock_irqsave(&smcd->lock, flags);
 	list_for_each_entry(vlan, &smcd->vlan, list) {
@@ -351,7 +355,8 @@ static void smcd_handle_sw_event(struct smc_ism_event_work *wrk)
 		smc_smcd_terminate(wrk->smcd, &peer_gid, ev_info.vlan_id);
 		break;
 	case ISM_EVENT_CODE_TESTLINK:	/* Activity timer */
-		if (ev_info.code == ISM_EVENT_REQUEST) {
+		if (ev_info.code == ISM_EVENT_REQUEST &&
+		    wrk->smcd->ops->signal_event) {
 			ev_info.code = ISM_EVENT_RESPONSE;
 			wrk->smcd->ops->signal_event(wrk->smcd,
 						     &peer_gid,
@@ -526,6 +531,8 @@ int smc_ism_signal_shutdown(struct smc_link_group *lgr)
 
 	if (lgr->peer_shutdown)
 		return 0;
+	if (!lgr->smcd->ops->signal_event)
+		return 0;
 
 	memcpy(ev_info.uid, lgr->id, SMC_LGR_ID_SIZE);
 	ev_info.vlan_id = lgr->vlan_id;
-- 
2.43.0



