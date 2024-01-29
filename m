Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155CD157E6B;
	Mon, 29 Jan 2024 17:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548313; cv=none; b=UJwkso1V80R1BWYFFQ/XVuVVDdr1tJUWuG7tKkO2zVHMx0ItpY0Pr1shfRmIshMhK7CkOH1njAm75py5nFkKCPNVm07O9cBVugssUvqAjKt0iI17m4WjbbrC/AoG/O+k0loR2tmUpfe2fExefU5G0tMFAREJ7SP3xYA9h1JsVWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548313; c=relaxed/simple;
	bh=aXu/egLYB1smXwl2ocIQ6VhdEfnRsZV+8Knbf7q8zV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM1KHx6fH8iEAEbiIvTUE4E6aFNnKp/pe72D5g6R1an8kY7zjyhbwl+s9hGqz5aksfBapq5I7EVnxNpA7hGR9lOhJz0YVqlZwO8bl8JAoYYgllAfIDNVJQKZhPtN+M/5qZKjx6mvmMonHC4jXKcojNliqKLNp6GD9eaUlRpbMD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUBSbPgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUBSbPgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE12C43399;
	Mon, 29 Jan 2024 17:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548312;
	bh=aXu/egLYB1smXwl2ocIQ6VhdEfnRsZV+8Knbf7q8zV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUBSbPgMgWg80v1a+eLk+LYJ4ncgnkM5DSCQKZWhKHt8bFXr2wp+pktGCO2BhxiFX
	 3Jn4v+T/yEVKabyTIM3eycduHlhyFtq7em9pBSWgW7jgfzCUjw4kwKdr87bFJtCizn
	 y8qiU9UPFeBaxb5LUEDjrhyn4eYfxzUKTbQFiRsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 313/346] drm/bridge: parade-ps8640: Make sure we drop the AUX mutex in the error case
Date: Mon, 29 Jan 2024 09:05:44 -0800
Message-ID: <20240129170025.682428730@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 166bfc725ef4..14d4dcf239da 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -351,11 +351,13 @@ static ssize_t ps8640_aux_transfer(struct drm_dp_aux *aux,
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



