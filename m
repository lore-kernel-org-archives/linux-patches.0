Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A77430CDD;
	Thu, 30 Jul 2026 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421479; cv=none; b=NADxhPW+IHxgKDHJ365EkuyT0erImgGgt3vRenUj0NNH+V+PSTobMV5376mbqp2S4/YSfFLqQ3t99nuIRAbILGntdpiXN7ds8JxuCHioMQ2Kuyd4uTTySNesfRte9v/pe5TKdu2iUJgk3sH4EaAkXEPXdmRyyk63xzhl1uueMLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421479; c=relaxed/simple;
	bh=e98oI2XXQAGgQvS1ExUYJ3wUFKkhdXT0PGuM/MEIit8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6rHqo5WeUONCPdUNt4K/gShGK4oyflf32h4e/mYUuCE0JSCXOa8KsEKPNm1J2zxLCtbd0DFnSKBpHy9+IYe1hjgYR/qiKZU3CxfZSp5fmePIvzasi6sAhoLBEh5W6MiAVdGzMSXfRBJuTDX+iaAwdou0doeP2PvakA5+sd6taY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eirt5rjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eirt5rjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F2F1F00A3A;
	Thu, 30 Jul 2026 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421477;
	bh=m4ok9/2bpCgMmkLROnENvzhOtOkv0pevCZ8ub9L5YKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eirt5rjjgB6S6q0HAOs2dDbEIFw3Llbkv0yeOeb9TriH0ttkTOWwenP4+pwzfKtYP
	 XOdSlrl9nB5NQSrKlzCXbAC117e3YGRqVXpCA4Vq11nQJAeXqdGwo8gij36jorptT5
	 EotUMpqv5RdWH0FyBoc50T6zWxWcZorhIQkdXLuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 116/744] drm/panthor: Check debugfs GEM lock initialization
Date: Thu, 30 Jul 2026 16:06:29 +0200
Message-ID: <20260730141446.744724793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 022e901333c3054656a640794e842bab7af5a75c ]

drmm_mutex_init() can fail while registering the managed cleanup action.
When that happens, drmm_add_action_or_reset() destroys the mutex before
returning the error. Continuing initialization would therefore leave the
debugfs GEM object list with an unusable lock.

Propagate the error as is already done for the other managed mutexes in
panthor_device_init().

Fixes: a3707f53eb3f ("drm/panthor: show device-wide list of DRM GEM objects over DebugFS")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260713082912.321021-1-lilinmao@kylinos.cn
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index 4f522a912d8968..48bb33bac36631 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -207,7 +207,10 @@ int panthor_device_init(struct panthor_device *ptdev)
 		return ret;
 
 #ifdef CONFIG_DEBUG_FS
-	drmm_mutex_init(&ptdev->base, &ptdev->gems.lock);
+	ret = drmm_mutex_init(&ptdev->base, &ptdev->gems.lock);
+	if (ret)
+		return ret;
+
 	INIT_LIST_HEAD(&ptdev->gems.node);
 #endif
 
-- 
2.53.0



