Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7215E15AAD4;
	Mon, 29 Jan 2024 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548407; cv=none; b=Ua59Fin+wcQGkLCa0kHDQ0kVdPdaUwrBXIB1p5Dp6KGHoDVTbMtvKLxlCAa06zPVR2GEnQjD2Z28yxDl/Md098owKGlQb89pMUToXhsU0S9O2g9R8MKOc86aeh9GY6hidN+tsT/XCVZoHYF0n+SQx/vZfIV+Y7r7R0nJI4kksGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548407; c=relaxed/simple;
	bh=p4iMLZti5xz54qVS9Nb3HBGYTaXkPP+VAUjJkfqTKs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbiF9Dp6mbcEqBoVjggxbEPF8PLwFeZBsq1oDAwW1PcSDZQ2TkUbPg36aQs5NX2qwRCQP7CgzauxsgSGo+wJn4FLqc2yqd3rye8Gt+sM6bGeTZTS4c7UhnY6QkHG3PaWTO4pLO0UV4zwFlAHkcnr2oHgKFIW9aQ05uEFDzjCcEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=An48pbiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="An48pbiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C56C433C7;
	Mon, 29 Jan 2024 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548406;
	bh=p4iMLZti5xz54qVS9Nb3HBGYTaXkPP+VAUjJkfqTKs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=An48pbiEbfCRyZmWs3+m7bcSosrrNGVVhTNU00mf3KXjUzFo8wTSh9qw/2wn3wTso
	 fp++SfOqxtxIIZw/iBVlIIwzOEtYpBJkHgo4v7Dl8tRQd9ekaFsofPC9prGGmQNwpP
	 JwH9xuI1K7WkPFOqc3oUBAfHOLOjWXtHLA2DubiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/185] drm/bridge: parade-ps8640: Wait for HPD when doing an AUX transfer
Date: Mon, 29 Jan 2024 09:06:06 -0800
Message-ID: <20240129170003.925820990@linuxfoundation.org>
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

[ Upstream commit 024b32db43a359e0ded3fcc6cd86247cbbed4224 ]

Unlike what is claimed in commit f5aa7d46b0ee ("drm/bridge:
parade-ps8640: Provide wait_hpd_asserted() in struct drm_dp_aux"), if
someone manually tries to do an AUX transfer (like via `i2cdump ${bus}
0x50 i`) while the panel is off we don't just get a simple transfer
error. Instead, the whole ps8640 gets thrown for a loop and goes into
a bad state.

Let's put the function to wait for the HPD (and the magical 50 ms
after first reset) back in when we're doing an AUX transfer. This
shouldn't actually make things much slower (assuming the panel is on)
because we should immediately poll and see the HPD high. Mostly this
is just an extra i2c transfer to the bridge.

Fixes: f5aa7d46b0ee ("drm/bridge: parade-ps8640: Provide wait_hpd_asserted() in struct drm_dp_aux")
Tested-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231221135548.1.I10f326a9305d57ad32cee7f8d9c60518c8be20fb@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/parade-ps8640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c b/drivers/gpu/drm/bridge/parade-ps8640.c
index 083337a27966..146e1ad76223 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -354,6 +354,11 @@ static ssize_t ps8640_aux_transfer(struct drm_dp_aux *aux,
 	int ret;
 
 	pm_runtime_get_sync(dev);
+	ret = _ps8640_wait_hpd_asserted(ps_bridge, 200 * 1000);
+	if (ret) {
+		pm_runtime_put_sync_suspend(dev);
+		return ret;
+	}
 	ret = ps8640_aux_transfer_msg(aux, msg);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
-- 
2.43.0



