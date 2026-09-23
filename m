Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB36032B125;
	Wed, 23 Sep 2026 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173023; cv=none; b=LFXcTZlVUYVljjERAzJDLAUMMQTqxorCUq1ost7s4o6CWeOSQpnl6/qg6UB7KR7+D4/T50J344c8wCLYeLJmPqPrPf5XDT1vkGoMBT7+Q99326nSV0Jc202dlWZwxXcLSwer2pIlLc8GFzlQLJgLTy5WKmHOntqENM/RsmtJBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173023; c=relaxed/simple;
	bh=FvAv5z4xiqGKmNM61iTf8ICT3UzmbmXD14IRulfqFUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYxQ5Yw9cJHKbLXc56wXeRRv+TL6SCEXZl/ELhQgx1djboZgfYcV6vXZApucHR5vUg2Wh0D43q0XgC8BKAE2Xi+k7GCnWsc9PJdQg8EKSb2fO8fgDgr45EcXPtTzYHEi0BDOw+pgN7olLXuwlnVAvUzqF0DYMmJ1K6gkqwOdqv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOIcIv/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOIcIv/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105141F000FF;
	Wed, 23 Sep 2026 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173022;
	bh=zZgS8Ypbbv0HDUVmEpN3cKpOwOzwaULs1JHNrzuExT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOIcIv/GXo9tqOjDRwA3QmyoSyHhucir/B4FmRqcFrP1ip8DPlZlw+wKSKKkG7JLi
	 RyjqPfSWFFPw6982TekB1oktjDAfR5Yf23fFoN8VbVWuCxvLbxW2/6kH5wZ2XWtc+w
	 MIPWIngv7MxLvfiGQg6lu3jeEP7J641rsCU4pj2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Casco <jesse.casco@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 129/438] drm/msm/dp: skip PUSH_IDLE when the link was never enabled
Date: Wed, 23 Sep 2026 16:02:30 +0200
Message-ID: <20260923140648.124893627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Casco <jesse.casco@gmail.com>

[ Upstream commit e249a6e2a130c08bb4d8b0a55cbe29754307e5c9 ]

msm_dp_display_atomic_enable() returns early when link training fails,
leaving ->power_on false and the main link down.
msm_dp_display_atomic_disable() nevertheless writes DP_STATE_CTRL_PUSH_IDLE
and waits for an idle-pattern completion that cannot arrive, so every failed
enable is followed by "PUSH_IDLE pattern timedout".

Every other step of the teardown is already gated on that flag:
msm_dp_display_disable(), called from .atomic_post_disable(), returns early
on !power_on. The PUSH_IDLE write is the only one that is not, so the
controller's runtime-PM reference is then dropped without the link having
been taken down.

On glymur (Snapdragon X2 Elite) the consequence is not a warning. The SoC
does not survive it: TrustZone force-stops the SOCCP and ADSP remote
processors and the machine resets silently about 50 ms later, with no oops
and no panic. On an ASUS Zenbook A16 (UX3607OA), whose eDP panel does not
currently train, this reproduces without any compositor or GPU involvement:

  # eDP enable has already failed with "Failed link training (rc=-104)"
  echo 1 > /sys/class/graphics/fb0/blank

  [535.645455] === marker ===
  [535.694833] qcom_q6v5_pas d00000.remoteproc: fatal error received: \
                 sys_m_smsm.c:512:TZ force stop
  [535.694875] remoteproc remoteproc0: crash detected in soccp: type fatal error
  [535.728857] qcom_q6v5_pas 6800000.remoteproc: fatal error received: \
                 sys_m_smsm.c:783:err fatal notification received from TZ
  <SoC reset>

Gate the PUSH_IDLE write on ->power_on so the disable path is consistent
with the rest of the teardown. With this applied the same sequence is
harmless and the machine stays up; without it, it resets every time.

The unconditional write dates back to the original DP driver
(c943b4948b58 ("drm/msm/dp: add displayPort driver support")), but the
surrounding code has been restructured several times since, so no Fixes:
tag is offered.

Note that the eDP link-training failure that exposes this on the A16 is a
separate problem in the glymur eDP PHY and is reported separately; this
change is about not damaging the machine when training fails, for whatever
reason.

Tested on ASUS Zenbook A16 (UX3607OA), Snapdragon X2 Elite Extreme, on
linux-next next-20260803 and next-20260807. The machine has since been
running next-20260807 with this patch as its daily driver.

Assisted-by: Anthropic:Claude-Opus-5
Signed-off-by: Jesse Casco <jesse.casco@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/745167/
Link: https://lore.kernel.org/r/20260808171325.133041-1-jesse.casco@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 79e2b171e269a..a2f799cf50f63 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1412,6 +1412,20 @@ void msm_dp_bridge_atomic_disable(struct drm_bridge *drm_bridge,
 
 	msm_dp_display = container_of(dp, struct msm_dp_display_private, msm_dp_display);
 
+	/*
+	 * If .atomic_enable() bailed out - link training failure is the common
+	 * case - the mainlink was never brought up and ->power_on stayed false.
+	 * Driving the PUSH_IDLE pattern into a controller that was never
+	 * enabled times out, and .atomic_post_disable() then drops the
+	 * controller's runtime-PM reference without tearing the PHY back down,
+	 * because msm_dp_display_disable() returns early on !power_on.  On
+	 * glymur (Snapdragon X2 Elite) that combination is answered by a
+	 * TrustZone-level SOCCP/ADSP force-stop and a silent SoC reset.
+	 * There is nothing to push idle, so leave it alone.
+	 */
+	if (!dp->power_on)
+		return;
+
 	msm_dp_ctrl_push_idle(msm_dp_display->ctrl);
 }
 
-- 
2.53.0



