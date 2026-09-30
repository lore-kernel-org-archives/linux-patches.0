Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A945A51E433;
	Wed, 30 Sep 2026 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789474; cv=none; b=N4gWjHzuEFgZ04ZG4Wh9baoAh1M/091lQh4fzVwvwKp/7rD70doAChJW0FR2J3juzNvpHouHJHZlJicwtywEVzWIFQajRXu1gbvdo7Sy9bYVeU9Pxl3sbKWuP577AP8QjD9MQrpApUCZKB8Ik8/m8vieP2CXS7bEkZgdKrjdBAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789474; c=relaxed/simple;
	bh=5YwLLTa0dstsY8AAmMpRXeJ+UWA1Z5tv3qApDmPYR8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7BB40Ov9w9ghWS2NAc6Qe4FPhkzFgKBW35haNrDC5QpLHCp7GIqkuUkkAC4Bhq6tEqctBaAigaCfbLEhmgNtsgonWQhsSGkLsoLx7hkoYxD7GuV7hutTmKCrZvMU/Nkd9TJ1kscKlfvT3oBRgBA4ygZI+I7WDB2Ctk+CCdUSZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1qsOtHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1qsOtHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4DF1F000FF;
	Wed, 30 Sep 2026 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789473;
	bh=bvt2+r2V4nhBy/qA/U/Tha6JoS4moPiCl3MTEEnmrv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1qsOtHc3GljHT1S/T0SNXzDX2oqKuSqX/ZyvZ5ZHCbQL10e4HmETTAJKD1g1i3At
	 hWAG+eYURMSbVNAq+ANsdO3sODvaqn75Ull3xi3S6tOhpYHR/3WWFW1bjIdyy7FA2p
	 4S0KVBKvfNdpeMPIHW4woSu0O4ks74XqZ0PINRzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.12 488/877] drm/nouveau: fix autosuspend cleanup during teardown
Date: Wed, 30 Sep 2026 17:23:19 +0200
Message-ID: <20260930152425.192564225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -563,6 +563,7 @@ nouveau_drm_device_fini(struct nouveau_d
 	if (nouveau_pmops_runtime()) {
 		pm_runtime_get_sync(dev->dev);
 		pm_runtime_forbid(dev->dev);
+		pm_runtime_dont_use_autosuspend(dev->dev);
 	}
 
 	nouveau_led_fini(dev);


