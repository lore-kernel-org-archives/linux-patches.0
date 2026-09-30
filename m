Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271DA50EC11;
	Wed, 30 Sep 2026 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787629; cv=none; b=Oh+d7IK9A4ZFiJmfkKXwBbaiQslZZNjpDVFDrGlZJf0lZJBziPJMuobPyObUtEddd/S1z8jpjoJYAcr072JNgElA7i1zm2oVhz8idUH0yUZ/t0bpZrUOfBGHZ3EYJY9FykTfL6ng9knk45OLaUyg/aTZ/cMXkM9FMmUgZQ3mKOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787629; c=relaxed/simple;
	bh=CO95x8UFT8MlrO9mH3YospsKG4Oodszc7joM64So12M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4HN+sGgfFkVsYUUWbv3+g1Ykjxi91LspBBNX8iUo/skSr4EMMvEHCzdzKK3cj+jTpmJfgHWlUgAXe5UPJj64SUnOMbHOOV0uE2i7X0Gkny7hWlKiyXcdcf0AeBZGsa+A5HYx/Ko9npKpY/P3xGf0BZm5/WYHu+x/OzFFrFjBkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IymOiszv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IymOiszv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFE01F000FF;
	Wed, 30 Sep 2026 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787628;
	bh=3O64tn1nurd5Uxa+gva5vULCk+9ZWKVNc07khWke88s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IymOiszvXP+w1ChufdgFSnRUUAxgcqm/LP8NExxrBfzxRsN1KFml/L7XG5ZtZuUEH
	 GN+hgolPcZUBH22Dv5WX7+94okpWrcScCYxiYH6OmRrjKldQTxOpW/7LjPW58zBQ2i
	 N56T3QzTeJUaSm0VTzKPMyW+zDowuxClG30AYfhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.2 295/457] drm/nouveau: fix autosuspend cleanup during teardown
Date: Wed, 30 Sep 2026 17:26:40 +0200
Message-ID: <20260930152352.399496062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -585,6 +585,7 @@ nouveau_drm_device_fini(struct nouveau_d
 	if (nouveau_pmops_runtime()) {
 		pm_runtime_get_sync(dev->dev);
 		pm_runtime_forbid(dev->dev);
+		pm_runtime_dont_use_autosuspend(dev->dev);
 	}
 
 	nouveau_led_fini(dev);


