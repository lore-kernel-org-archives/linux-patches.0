Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D6E1641A7;
	Mon, 29 Jan 2024 17:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548411; cv=none; b=ud5kMfSwfGKxUdorPCGRGdzHlyRJ825vtX889yyEsZllGKZVenf9Gq2woIiU4j5lZmHsvsKKgv9rTY9J8XNfyToE6bK/0vTifiQ5uUExp0Bu4im0P3edkGBtGl3rWs9H+GUB97ss7KljL2tysRjsgIt+Xw352O22Jj03fH0Xhbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548411; c=relaxed/simple;
	bh=DynzoE6KElPavMrOoZyVs9oOLpFOZjnbnzi1GP0Xqlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Me12OB4bDXZTcWUNlSkdqezReceWzWHGmfmU+APZKXjsFjzMrDEwJitudYkk/PTxbzvACHVG9WpQOfqmRX8v9h5e1QbTYwgPAcmQqB8/jULq96gKEKUUpXjnSdUqDmT1uBoDEv7vP5Hs4aBHBUqKBdn2dvZkSxyXw2zZ9+yqcPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duyrBQDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duyrBQDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FF7C43399;
	Mon, 29 Jan 2024 17:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548411;
	bh=DynzoE6KElPavMrOoZyVs9oOLpFOZjnbnzi1GP0Xqlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duyrBQDbvRCTrN7R1wCkFjsl+ed606lkJNIDxURQkCVTmkKA6i50OFAqyH6xF7s84
	 sKheyFXrnMLSheNbZ5RXWgqm2zQbHjRIDO6q/oziU6ZN9WPkhB7/K2zoZfkgHvg4cT
	 n3w82nO+cwhUY2LzTQ1MIrc/we4FieEJFJCgyVFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/185] drm/bridge: parade-ps8640: Make sure we drop the AUX mutex in the error case
Date: Mon, 29 Jan 2024 09:06:12 -0800
Message-ID: <20240129170004.114835848@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit a20f1b02bafcbf5a32d96a1d4185d6981cf7d016 ]

After commit 26db46bc9c67 ("drm/bridge: parade-ps8640: Ensure bridge
is suspended in .post_disable()"), if we hit the error case in
ps8640_aux_transfer() then we return without dropping the mutex. Fix
this oversight.

Fixes: 26db46bc9c67 ("drm/bridge: parade-ps8640: Ensure bridge is suspended in .post_disable()")
Reviewed-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240117103502.1.Ib726a0184913925efc7e99c4d4fc801982e1bc24@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/parade-ps8640.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c b/drivers/gpu/drm/bridge/parade-ps8640.c
index 3982568bd093..09737acc2cf4 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -359,11 +359,13 @@ static ssize_t ps8640_aux_transfer(struct drm_dp_aux *aux,
 	ret = _ps8640_wait_hpd_asserted(ps_bridge, 200 * 1000);
 	if (ret) {
 		pm_runtime_put_sync_suspend(dev);
-		return ret;
+		goto exit;
 	}
 	ret = ps8640_aux_transfer_msg(aux, msg);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
+
+exit:
 	mutex_unlock(&ps_bridge->aux_lock);
 
 	return ret;
-- 
2.43.0



