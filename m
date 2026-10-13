Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2E53FD955;
	Tue, 13 Oct 2026 12:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895977; cv=none; b=Y1HjQSgFFPZaFs7+s1lfn2tN9JCA8Eh2X/lw4hk8lkx/CJZ+07tDsXkZlwIlua9gqPmXpYrAlo5zY6wxBY7FHx7chYQ9wZHxvaSaXRzch+YkaijX7tYYktE1p3OL3red+Mu/9ZhpSvAfpAcv+AsB2r3Pn0UZElipf5vTL5+MiVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895977; c=relaxed/simple;
	bh=DFKwEafQmtIRJIpjKcyHpXeOAI+9Z8LhIJky3PzYWAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwbHxqCIIz7cy8H3QQt13DZSzFyTxARu0QV4EnGJZY56a22Jz/E1OfeljfcqL8TRiwUYJpfx77xlQtvGVtTyhzUnPkjYE3OvTPoa7eIJaurvOq6EYXVW4fgv9Grw/nt6tn7wWDhbBhXTZ+tt7yTo/W9YGOg7iVGPBiDdz1WOmBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzlWPQwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzlWPQwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B551E1F00893;
	Tue, 13 Oct 2026 12:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895976;
	bh=oXWB7crWbAZpfFZvpKaeeU0ujzBy7Vv2R86z/C+0ZGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzlWPQwtjsc7WZLQL90RpCADQQCbnsmTo8f9HAhy0QTfaC1GuPcOY61bHQG6mlCyJ
	 9T/ag0XH/+/1tddVgFrLjC+I1or5SiCP6ari4Fruii1CgH8q6aH9XmqsSlmmsVyXD1
	 wfSD98Sdd9ivO/7GdOHyrlia1TTR2+P6TstC+pg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 454/497] drm/vc4: Free the BO cache size list on teardown
Date: Tue, 13 Oct 2026 13:40:21 +0200
Message-ID: <20261013112918.657789752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit b41ff8b529278216cba22a5dcdc93fea2a3a9619 ]

vc4_bo_cache_destroy() purges the cached BOs but never frees the size
list, leaking it on every unbind.

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Assisted-by: LLM
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20260930190721.1897264-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index e49a4950b416d..af443c98cd701 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1054,6 +1054,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
+	kfree(vc4->bo_cache.size_list);
 
 	for (i = 0; i < vc4->num_labels; i++) {
 		if (vc4->bo_labels[i].num_allocated) {
-- 
2.53.0



