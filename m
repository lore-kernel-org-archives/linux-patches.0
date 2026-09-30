Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFB223D7FF;
	Wed, 30 Sep 2026 18:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793416; cv=none; b=nhP7SVbuJPaUuk6ViZVhMfxIeyGqVhhap8Gos33s70wuSoyAKb0wAhDGFHMQ12h6Lcvzrkuw02o1o8cVl0CzGwFamu3T/HAB4UaleohPmiPwANLp4cBVlKmVAzX221sifgkxMgcMzNoYhGvQhqKjnkHLK5OtYLfhZQxHoCG7+TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793416; c=relaxed/simple;
	bh=YXGKNlw5Hb4LFeRDDeMYKLE09zWlbcR52O7SWqfkqPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bsa7N7MrIXJMnI5NCOb/2hMOHuWXoCh8YqhiH5KMCx8YeqHTgzF4yXy5gsq07/ZmZwP6MOLXVaFvzJnAPlEezLcAlEhoEkgGCqRl7MXiMXAgvaUSl0MZd1eSHWCBPnRw9pNmcVIy/Fe3yElfG1LWGoyRcHh5F2rL0WjuVnxJHLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qMiXnqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qMiXnqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F0D1F000FF;
	Wed, 30 Sep 2026 18:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793415;
	bh=HfO1F1kN3gFp592MM43anqPHBjuXiBrlP/bWHxf47DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qMiXnqk2vk6x7gRVOv13LCuiZn3YjQcsMbkOdzgfF70vQTpH2xey3wUhNBWH+Fp2
	 gmxqWkcKcnp7rCs2mYyKpsbEvOFbMYRM+9mv4x7eHK9MPhSTp7dsDqLJDf5N+UYtoz
	 Ctunmw+NjyMVe/4da25XvUBtIvBHDL9BPPkFeUvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 247/395] drm/nouveau: fix autosuspend cleanup during teardown
Date: Wed, 30 Sep 2026 17:28:29 +0200
Message-ID: <20260930152346.011480016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit fefd9480ec361969f1a836df46326a1801062c26 upstream.

nouveau_drm_device_init() calls pm_runtime_use_autosuspend(), but
nouveau_drm_device_fini() does not call the matching
pm_runtime_dont_use_autosuspend().

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

The documentation for pm_runtime_use_autosuspend() also notes that it
is important to undo it with pm_runtime_dont_use_autosuspend() at
driver exit time, unless runtime PM was initially enabled with
devm_pm_runtime_enable().

Add the missing pm_runtime_dont_use_autosuspend() call to the common
device teardown path.

This issue was found by manual code inspection.

Fixes: 5addcf0a5f0f ("nouveau: add runtime PM support (v0.9)")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260808134137.2864847-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -584,6 +584,7 @@ nouveau_drm_device_fini(struct nouveau_d
 	if (nouveau_pmops_runtime()) {
 		pm_runtime_get_sync(dev->dev);
 		pm_runtime_forbid(dev->dev);
+		pm_runtime_dont_use_autosuspend(dev->dev);
 	}
 
 	nouveau_led_fini(dev);


