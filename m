Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36EE18E35B;
	Mon, 28 Oct 2024 06:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097546; cv=none; b=d1mt48tkZt4qTLMQinw8mUoBtkgISkPpbhxSC5O3dj//Dc3SUYO2agvyMks+7hS8wpjn7xSDGoZRWRbRmQkk0KWJkbtzLeLhyOHNG/luOAQ0075/+AQ/Ma6Wz8tKpqYg7c6M+mh7xcfxfpefEOckATuFy5GvAGf0uS8TyNR1lxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097546; c=relaxed/simple;
	bh=WWqebvW1HvtKaaoHISb1DV77DeTin/xj3r8Eyv1PBlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjKqMu1EucI1LI+b77dUrCFpkHSArNBvmHrzBSqAojrlD0sOM5NPKRNPfNcEuIwsgPhUy0i1MyhffCOc6xoSfXCnl7pBz8kQZI/T8DDI+fEWaKd1Z5oeirkA3Lq9eXaVtm2m9cF96e6GoQ1UEMmLcj9DLXfTAM/x79jKQ/oeyX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7iU+9+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7iU+9+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A73C4CEC3;
	Mon, 28 Oct 2024 06:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097546;
	bh=WWqebvW1HvtKaaoHISb1DV77DeTin/xj3r8Eyv1PBlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7iU+9+p1A2sTrGWt2OHtAgiIzFlIji+8EbhfSH55lZcJTeRRchOtLTjbk+yKUxqH
	 EjC56l2hcobzJsDXr5dVEpsV5VMu0J9l9xz9pNlJCAOLornIcI8wUhwsBmgVzM1Brq
	 RkxlzmGXRDxLmvZ77e+XVq9XXvyT8qJTiq1had48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/208] drm/vmwgfx: Handle possible ENOMEM in vmw_stdu_connector_atomic_check
Date: Mon, 28 Oct 2024 07:23:23 +0100
Message-ID: <20241028062307.227165939@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 4809a017a2bc42ff239d53ade4b2e70f2fe81348 ]

Handle unlikely ENOMEN condition and other errors in
vmw_stdu_connector_atomic_check.

Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 75c3e8a26a35 ("drm/vmwgfx: Trigger a modeset when the screen moves")
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240809183756.27283-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
index b22ae25db4e17..52ea0c50c852c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -881,6 +881,10 @@ static int vmw_stdu_connector_atomic_check(struct drm_connector *conn,
 	struct drm_crtc_state *new_crtc_state;
 
 	conn_state = drm_atomic_get_connector_state(state, conn);
+
+	if (IS_ERR(conn_state))
+		return PTR_ERR(conn_state);
+
 	du = vmw_connector_to_stdu(conn);
 
 	if (!conn_state->crtc)
-- 
2.43.0



