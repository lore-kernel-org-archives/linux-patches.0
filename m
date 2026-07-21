Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD0A3E49F0;
	Tue, 21 Jul 2026 17:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655575; cv=none; b=lT3bnff8aOi4xtu6sb04NenlEuISqVdliEKdNEGCjrlHH40Z/asZYYI5S68yq4SekYvEsSTkGRux8BQFbdO8hp8m4VzSYcpYqkL1q1BmloIJ1QBneuG2WgwQH1PzGmuDmMKTpaRQv/X97nYsMvLGfGOf4vT5N67LNlSEjrJn1vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655575; c=relaxed/simple;
	bh=TPjbTAJlGbMbob4MBIjSa+N55C/ZjJMLJ4/1dlnRDJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvvyloip3cJYZ7CL+g++WKL+VL7zrzRRaltbhwMNxDNn/3Gun7dIA9wCKh/ZqE7Sz7+jAHx85dC061NojiLWkamJZM11BsUYSxKa36ZgddHs6kVNG1SRtsPjvmhwUHywTiD7D/2FdSo0BJ605a6TeWeDOrFsPyL9HTshTIxDYiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up0yNbN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up0yNbN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8003A1F000E9;
	Tue, 21 Jul 2026 17:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655573;
	bh=yee+Vc2gGc2WyolSrHwI7XhUj+JeFV/Ruu8/gFPKm5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Up0yNbN0xw3pzSq+AmYJ7ntpAd1Iq9O+7UGkSnSTFjWJkcZQWqtZtMLy1V973A3XH
	 TZeeK9PQWfuwzKcaQpM6SBzMeuYDJdgX8H/bqIOxyWYrtUE5b0XNlntluDSCxfKabu
	 W0yrdEiSmNBAB1yQlnoVVY2UprNJqe/UqVjLz/Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0061/1611] drm/rockchip: dw_dp: Fix null-ptr-deref in dw_dp_remove()
Date: Tue, 21 Jul 2026 17:02:57 +0200
Message-ID: <20260721152516.203476711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9456381d8b60bb7dd42f2f04afe5ee4ce6e0bc12 ]

Attempting to access driver data in the platform driver ->remove()
callback may lead to a null pointer dereference since there is no
guaranty that the component ->bind() callback invoking
platform_set_drvdata() was executed.

A common scenario is when Rockchip DRM driver didn't manage to run
component_bind_all() because of an (unrelated) error causing early
return from rockchip_drm_bind().

Drop the unnecessary call to platform_get_drvdata() and, instead,
reference the target device structure via platform_device.

Fixes: d68ba7bac955 ("drm/rockchip: Add RK3588 DPTX output support")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260310-drm-rk-fixes-v2-3-645ecfb43f49@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
index 98d97e0f3cf4fe..6d57e1c7462732 100644
--- a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
@@ -130,9 +130,7 @@ static int dw_dp_probe(struct platform_device *pdev)
 
 static void dw_dp_remove(struct platform_device *pdev)
 {
-	struct rockchip_dw_dp *dp = platform_get_drvdata(pdev);
-
-	component_del(dp->dev, &dw_dp_rockchip_component_ops);
+	component_del(&pdev->dev, &dw_dp_rockchip_component_ops);
 }
 
 static const struct of_device_id dw_dp_of_match[] = {
-- 
2.53.0



