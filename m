Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E047576C75;
	Mon, 29 Jan 2024 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548651; cv=none; b=E5voJHy425opoNrSlzZBMKeGeWFHPK188Mx6ZvC9Vwx+OrDdGYnEGRMv7OfuA2laxmmXwv+zBoe+76JhDQC7n08zeZru7t2EXyfm+cXpzZCvHuB9uaoDP++z4JYArcRnRl1+6wiO8A+4JxeCSmrAQvTQT0ObbKeHK93vK1kOC/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548651; c=relaxed/simple;
	bh=4Ts5iF+LfaIHVzxL75odvJ/amyWtjbw0bHsvdPdJwNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpzSJaWLPVav4eAMOg2smPQMTegolnFdc0xs8KTE/Vrh5xkujszzzGW5ZdeTadxmnJ4Xh2g9DVewMyz5q0H+bFNUnAd+fG4wGEEo4acoVwMdqlmPbih/NH8ozIiDjBUbuL+L0ESG0kGv16J7oIctaBOVEZnwtzmbNmJHZmn9u1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V01h8PFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V01h8PFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7502C433F1;
	Mon, 29 Jan 2024 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548650;
	bh=4Ts5iF+LfaIHVzxL75odvJ/amyWtjbw0bHsvdPdJwNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V01h8PFwuhonyTiVIXgaCeenFQtdl52Rtk7s4VN0MCWcm2+Q2xDaSlMNkU60LpQYs
	 YhrPpohh/5kJTDuyutWXmPDI0dX9rA1wQiSb/GV3Xtkd0U5LtvSbtyUvB56jAdzn6g
	 g8SGTIZKmtygRUBpJhrh3JyfFuLz8kzxD50mipHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/331] drm/bridge: parade-ps8640: Make sure we drop the AUX mutex in the error case
Date: Mon, 29 Jan 2024 09:06:10 -0800
Message-ID: <20240129170023.836847913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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



