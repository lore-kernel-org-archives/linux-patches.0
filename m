Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE874F4CFB;
	Wed, 30 Sep 2026 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783915; cv=none; b=lXFuiueUYQNGA6o9WT1gT/jjMebNKHuhZ6ogUZ0W4/nRi4VnST/cnL0YhTboa0/QcyE+Uz8LmFijpMpfFLRNfuuYhLdPYmvGGSUmdInkKzuAmZYxh1NZnNkiHD8pwcVoHFohdFT8quT6pM9YdcCOV4OOd4q8FMSN16nya0zt6ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783915; c=relaxed/simple;
	bh=/SqYDEsf+PoVRSKkeZe5s8Nn1MD0b69KmVL+w3j7sck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu8Z+YoovS5KwWRUPz9BGj7+Hzrc/GAf0RoHJDPEoFSuBG9TL3jEvezbtaaS5KvIjDDaZ474Nx3s87k0tsfhAu8+cyEimj4sT61CVJnc/ChzCzX6nwZaBFkJVIb0/fzpIjMvMewjUwy61/G+WibYkPmAjykzVXHfRyVS8aHggPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMHPFpa5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMHPFpa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106261F00893;
	Wed, 30 Sep 2026 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783906;
	bh=+QVDx23MAwUaWaj2iB6lzC0zyCmZlAIGV1dfki8++H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMHPFpa5VeKIt6HGbSoxBVP0jiTItm4KMzdE8FIj4+Fja592jUVOoEqRw4bPPXV/o
	 6uF2q+enCqkhm0pyHdPGwSp1uKHk/nlpgMxa9Nb5ocE/RyllBnPskPGqVhroaAAvfc
	 SDWoARupGOVJtfQjXR/wplxg8cvhZ297WULwkgGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 564/595] drm/nouveau: fix autosuspend cleanup during teardown
Date: Wed, 30 Sep 2026 17:27:37 +0200
Message-ID: <20260930152359.854462144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -640,6 +640,7 @@ nouveau_drm_device_fini(struct drm_devic
 	if (nouveau_pmops_runtime()) {
 		pm_runtime_get_sync(dev->dev);
 		pm_runtime_forbid(dev->dev);
+		pm_runtime_dont_use_autosuspend(dev->dev);
 	}
 
 	nouveau_led_fini(dev);


