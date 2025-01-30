Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2481DDC22;
	Thu, 30 Jan 2025 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247130; cv=none; b=bbHIww8kbJP/PNAr6YBozlSy4im12qOUJWp4szQ5jAPtUvjmPgIQ6vm927qNs02gahdKrQv3lHkGPXptLxXuPQw2JCyAqMujYKS5z5DmIYYeORncMSTgy4VInF8GFBx8r02+3YIw5QeDBEx6DukeUdftOvv/GKO0RcwtvnWkS90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247130; c=relaxed/simple;
	bh=0DZCFOhy77OC9MaoJwRQu/aKwpvNz/lnY6cOlTdQB2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QcfOHpoX5o55Y4+8daXPMKh/+OF61QYHsNRPjMrkdXFkY1QYsQG1yi+Kp59zyCNygLP5dxUE6a3eiwzH/M4XECmwA2DQJVPyO1v5FLO/jL8gGGX8kPI21Vfia0ZBFbLGG1B4fAs4Riu5Fbl+uu6sdotWlGkw6vYuEnTFmfFAh9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=argv7UDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="argv7UDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11C7C4CED2;
	Thu, 30 Jan 2025 14:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247130;
	bh=0DZCFOhy77OC9MaoJwRQu/aKwpvNz/lnY6cOlTdQB2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=argv7UDbnpX/fw72z2pPujXeOWMU0tLqWRM1SHwEJuQvVcJLeZUOcXf7mfbmTqX8I
	 vbnLyfFL8St7uqKjQwl7M2sTzju4ecycM2YLDwzZNDO/LE+L7Kq9VliL/DB4cc4/Kz
	 k5r6gzzD9NmqVF6716Vp6rdDyMXhrvAZE6S9b9ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
	Robert Foss <robert.foss@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/133] drm: bridge: adv7511: unregister cec i2c device after cec adapter
Date: Thu, 30 Jan 2025 15:00:54 +0100
Message-ID: <20250130140145.134729345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 40cdb02cb9f965732eb543d47f15bef8d10f0f5f ]

cec_unregister_adapter() assumes that the underlying adapter ops are
callable. For example, if the CEC adapter currently has a valid physical
address, then the unregistration procedure will invalidate the physical
address by setting it to f.f.f.f. Whence the following kernel oops
observed after removing the adv7511 module:

    Unable to handle kernel execution of user memory at virtual address 0000000000000000
    Internal error: Oops: 86000004 [#1] PREEMPT_RT SMP
    Call trace:
     0x0
     adv7511_cec_adap_log_addr+0x1ac/0x1c8 [adv7511]
     cec_adap_unconfigure+0x44/0x90 [cec]
     __cec_s_phys_addr.part.0+0x68/0x230 [cec]
     __cec_s_phys_addr+0x40/0x50 [cec]
     cec_unregister_adapter+0xb4/0x118 [cec]
     adv7511_remove+0x60/0x90 [adv7511]
     i2c_device_remove+0x34/0xe0
     device_release_driver_internal+0x114/0x1f0
     driver_detach+0x54/0xe0
     bus_remove_driver+0x60/0xd8
     driver_unregister+0x34/0x60
     i2c_del_driver+0x2c/0x68
     adv7511_exit+0x1c/0x67c [adv7511]
     __arm64_sys_delete_module+0x154/0x288
     invoke_syscall+0x48/0x100
     el0_svc_common.constprop.0+0x48/0xe8
     do_el0_svc+0x28/0x88
     el0_svc+0x1c/0x50
     el0t_64_sync_handler+0xa8/0xb0
     el0t_64_sync+0x15c/0x160
    Code: bad PC value
    ---[ end trace 0000000000000000 ]---

Protect against this scenario by unregistering i2c_cec after
unregistering the CEC adapter. Duly disable the CEC clock afterwards
too.

Fixes: 3b1b975003e4 ("drm: adv7511/33: add HDMI CEC support")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220612144854.2223873-3-alvin@pqrs.dk
Stable-dep-of: 81adbd3ff21c ("drm: adv7511: Fix use-after-free in adv7533_attach_dsi()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 42d93f314699..9e8f45fa5c5e 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1339,9 +1339,6 @@ static int adv7511_remove(struct i2c_client *i2c)
 {
 	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
 
-	i2c_unregister_device(adv7511->i2c_cec);
-	clk_disable_unprepare(adv7511->cec_clk);
-
 	adv7511_uninit_regulators(adv7511);
 
 	drm_bridge_remove(&adv7511->bridge);
@@ -1349,6 +1346,8 @@ static int adv7511_remove(struct i2c_client *i2c)
 	adv7511_audio_exit(adv7511);
 
 	cec_unregister_adapter(adv7511->cec_adap);
+	i2c_unregister_device(adv7511->i2c_cec);
+	clk_disable_unprepare(adv7511->cec_clk);
 
 	i2c_unregister_device(adv7511->i2c_packet);
 	i2c_unregister_device(adv7511->i2c_edid);
-- 
2.39.5



