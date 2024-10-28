Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FECD186E52;
	Mon, 28 Oct 2024 06:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097170; cv=none; b=MlgWtb03AhenLiYw1v27vdky5VoxjtbOZJ21z2ZM1+L9qTbUugslEp4A3Q5wtKIDnsFLeMwdfylBBAkbU7d9YR/dmwFRaA41e1tKmVQELXEFOcXbWvMvS/Dm2p+8eo9y2670ijbRR95D2EGNefSOSgpK/+3xhowyRqwN1mod9dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097170; c=relaxed/simple;
	bh=pBOTlf/fNGZLmz9WXmXirbN+9NxtsujK9WgJYxXwJRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E293Jz5CdiaF7hrdwvT+QjQcXYlcVs7vLgHv4gUnu3tjUfwPT0waCXxPP12/PSc2cPSHShvFVWjunKDGmy9DYcwGziifU714NJa8OBbL9VLv3rSTgTaz9KaITLL2wLsgRs5rCZeT8ZU/KJuxYTP+5y4NdkPb1siXfZVIzSiIWS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxpceRtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxpceRtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6570C4CEC7;
	Mon, 28 Oct 2024 06:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097169;
	bh=pBOTlf/fNGZLmz9WXmXirbN+9NxtsujK9WgJYxXwJRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxpceRtrou34PaMqLgPtz2hoILzNJMvlUCxsMW2ApXaUNEoeVgPCUxV2xb6QIiVsy
	 X80pvCkNqUQAFlAgNGCs2AmHs6z+QErThfbw42pLSwQ0kds0fj/MBx/WI1s2fcYWod
	 nbN6+Lv7zFQOuPwvuSev5o2u6McsgrCgJsVNDwZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/137] drm/vmwgfx: Handle possible ENOMEM in vmw_stdu_connector_atomic_check
Date: Mon, 28 Oct 2024 07:24:11 +0100
Message-ID: <20241028062259.119311896@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e98fde90f4e0c..2f775679a5076 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -1028,6 +1028,10 @@ static int vmw_stdu_connector_atomic_check(struct drm_connector *conn,
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



