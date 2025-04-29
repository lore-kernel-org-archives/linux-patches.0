Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0187621883E;
	Tue, 29 Apr 2025 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947910; cv=none; b=gRRHiKz90F6fP89BJ/1A99lryWI68rOLOqgYjK7Pu7FsqYIEQg+maeGQwxZVnhtSZGkYZm/9Cwhahynymj/cRa63+Ok3eqhA68EqyfclAuV3Mh93Sn5cqJlam7kO3HfUAjATNJwcye4DLJlfczt3dXVYEx5huI/zkxZ6NZ4AZ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947910; c=relaxed/simple;
	bh=VBoBhOAWxnV8xwNa6w+B0YURCCy1m4xCY7Fg55PC+F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuR1v4og4qkeIU9lYTFLlGucRzgKsJjgjiHKGbxJ8hcK9lPLrty5yAAAsTefstsZ9Nycv09pFmcz9bV4AEi5ZeJK39xvx2BGpXIhIH6n9E7uQoid0RpIvnt6MOiUlwvAbSoETv1oiOB7UoLgWqHDLDhbXRqbgXL9k8sbmBBA1iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkL3bjXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkL3bjXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72740C4CEE3;
	Tue, 29 Apr 2025 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947909;
	bh=VBoBhOAWxnV8xwNa6w+B0YURCCy1m4xCY7Fg55PC+F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkL3bjXKSOJ8jnvsXuYnrXdtTcit7Y0YIQCXylgpLJHnP8JqN8N6H8tVHTchDDAuD
	 lHuRx6xbfsFoN/XqOPDPg1DqOiCirs+EJNVa9fYKlzWyUke1kHALHss2eIrSwEDrL5
	 Gg6pFA+AfGyHvwjm/oWFH4F0Yw7i0Yd9eDNrScxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.12 102/280] drm: panel: jd9365da: fix reset signal polarity in unprepare
Date: Tue, 29 Apr 2025 18:40:43 +0200
Message-ID: <20250429161119.284703035@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 095c8e61f4c71cd4630ee11a82e82cc341b38464 upstream.

commit a8972d5a49b4 ("drm: panel: jd9365da-h3: fix reset signal polarity")
fixed reset signal polarity in jadard_dsi_probe() and jadard_prepare().

It was not done in jadard_unprepare() because of an incorrect assumption
about reset line handling in power off mode. After looking into the
datasheet, it now appears that before disabling regulators, the reset line
is deasserted first, and if reset_before_power_off_vcioo is true, then the
reset line is asserted.

Fix reset polarity by inverting gpiod_set_value() second argument in
in jadard_unprepare().

Fixes: 6b818c533dd8 ("drm: panel: Add Jadard JD9365DA-H3 DSI panel")
Fixes: 2b976ad760dc ("drm/panel: jd9365da: Support for kd101ne3-40ti MIPI-DSI panel")
Fixes: a8972d5a49b4 ("drm: panel: jd9365da-h3: fix reset signal polarity")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250417195507.778731-1-hugo@hugovil.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250417195507.778731-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
+++ b/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
@@ -129,11 +129,11 @@ static int jadard_unprepare(struct drm_p
 {
 	struct jadard *jadard = panel_to_jadard(panel);
 
-	gpiod_set_value(jadard->reset, 1);
+	gpiod_set_value(jadard->reset, 0);
 	msleep(120);
 
 	if (jadard->desc->reset_before_power_off_vcioo) {
-		gpiod_set_value(jadard->reset, 0);
+		gpiod_set_value(jadard->reset, 1);
 
 		usleep_range(1000, 2000);
 	}


