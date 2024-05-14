Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC882B9AD;
	Tue, 14 May 2024 11:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687752; cv=none; b=ncD0GBNwNNCXehdZK3C9G0cPWE8GWOip4ji5mq40ptzLCsBSG1wQeONOF8yrV6upL0TakIHzRMAlS50aFPdkALB3w5L3foYEyppX9C0ai2b0wSGdXNJr2r2a0sinc7xm4MewZNjvYTipJdFfgvHY67Q2Fj6d4fwNdC6zf6AK0wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687752; c=relaxed/simple;
	bh=3bi4A6U0RfV2K6QdRkkw/Eq2ekM153hRPben7N8u5Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id8fX3yROq7gGRCDRlYES4QOow5JwelWkRxXRVKwMtJuuh8FBIJ9ugexJZzBEMyWmV+hZwYz+jSFtJ4DAX2T+ylZvhprlHmFBNYk2JnBs/MXYc3SCVGWaoQikquDJLt3pKkvgBaav8FMwsB+SytDm2Lmjx4gO/+8DSrTAFC3eDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwaiTFbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwaiTFbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D0FC2BD10;
	Tue, 14 May 2024 11:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687752;
	bh=3bi4A6U0RfV2K6QdRkkw/Eq2ekM153hRPben7N8u5Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwaiTFbXHT8Ds2r5Pm6cPKWgGAFZa0j2cf5bNKJkPjg8xZML64/X2WqxxEtbg0/0c
	 f6S61m79JbnT4quGXGBxvpYWpzLInRTisiIIfuSk25g0qU+KJ0xnLH9GuOKjohK32C
	 kJbD0+2U1fn5Mx7SU7m/XeG9X3PzMeozEO01d2p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/168] drm/nouveau/dp: Dont probe eDP ports twice harder
Date: Tue, 14 May 2024 12:19:51 +0200
Message-ID: <20240514101010.200714969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit bf52d7f9b2067f02efe7e32697479097aba4a055 ]

I didn't pay close enough attention the last time I tried to fix this
problem - while we currently do correctly take care to make sure we don't
probe a connected eDP port more then once, we don't do the same thing for
eDP ports we found to be disconnected.

So, fix this and make sure we only ever probe eDP ports once and then leave
them at that connector state forever (since without HPD, it's not going to
change on its own anyway). This should get rid of the last few GSP errors
getting spit out during runtime suspend and resume on some machines, as we
tried to reprobe eDP ports in response to ACPI hotplug probe events.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404233736.7946-3-lyude@redhat.com
(cherry picked from commit fe6660b661c3397af0867d5d098f5b26581f1290)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_dp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 447b7594b35ae..0107a21dc9f9b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -109,12 +109,15 @@ nouveau_dp_detect(struct nouveau_connector *nv_connector,
 	u8 *dpcd = nv_encoder->dp.dpcd;
 	int ret = NOUVEAU_DP_NONE;
 
-	/* If we've already read the DPCD on an eDP device, we don't need to
-	 * reread it as it won't change
+	/* eDP ports don't support hotplugging - so there's no point in probing eDP ports unless we
+	 * haven't probed them once before.
 	 */
-	if (connector->connector_type == DRM_MODE_CONNECTOR_eDP &&
-	    dpcd[DP_DPCD_REV] != 0)
-		return NOUVEAU_DP_SST;
+	if (connector->connector_type == DRM_MODE_CONNECTOR_eDP) {
+		if (connector->status == connector_status_connected)
+			return NOUVEAU_DP_SST;
+		else if (connector->status == connector_status_disconnected)
+			return NOUVEAU_DP_NONE;
+	}
 
 	mutex_lock(&nv_encoder->dp.hpd_irq_lock);
 	if (mstm) {
-- 
2.43.0



