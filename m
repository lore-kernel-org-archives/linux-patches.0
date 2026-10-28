Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215350;
	b=EnGQ21SwAlwIErJ9DKU4qVQ11+jYKVTOSO4HYHPOoRmQLaoMyT8NZaufXw2j2TbFpU+d
	 yd2aozN8UYLKSnb78n3RQik9EZ5MK6bniBlXn/tOe4irOIu5tVE6fejf6o1FK1rkMOHhL
	 AFynPSUvByq0dC06IvuYbqyqjHYuuRQBPQ33znNB1i/gQASwUkdKPbEAIVBt3ieA52zCw
	 drIA0oKBLsUkvV/j1pSWYVCtiT7TmxV9Bag9CAKqySTvryiWZ58yuFFSYZDgap2y43cNZ
	 EVUEdE9YnB3ldSlPY/NXzuF5JAq5oWpyishImY+BzLCoosFD77H0OUrjclVSyB/ku4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vFo10uttcdAU2Ry5Td/zyDAT9YiluGyrDbEVEdydnac=;
	b=wbNndtb8cSgo4An12PNy9mMCvRmFyM6rgiq+jGRVWevvAcRoS4w/dAzLgu1DI6jtXy6M
	 yMu9nxbWorvBxj+pcrPlPIdkuBF8BUaJxpB5uBRGlegwKTJz0lkfsi0uTOB6bN1YknFE6
	 8yxlzatQCE17FaW9lEG63CRiXmgXMxtVStskoyuxQ3zzB0yQmHRtbMSuDcUMTt/8Jqj9B
	 o4IajfiIZAkvDOeNLzJC+fRw8LvkU87di764S4uM9F9bj3Tu03OabeX7xX88uGLVmb7lM
	 ZvjoOU+Jb0QRRYB6qxTx6QhL96MrHzknFQm+98EfVZvws+XpNYj7wLfmJ5Eoke+ClTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pIg6DNj3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF78B606A31A;
	Wed, 28 Oct 2026 19:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pIg6DNj3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54C81F01828;
	Wed, 28 Oct 2026 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215349;
	bh=vFo10uttcdAU2Ry5Td/zyDAT9YiluGyrDbEVEdydnac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pIg6DNj3SRYnEXtopbrocKmo2hEnFjEvMwbuXbJZP7dSlvlO2t7KOOOR4C0AntQTr
	 yVWSpBD/KGcrzNN9J8BmO4GCoNIbidrJhyAYDgu9SBlcXLzmSTu3YhWNOOL9A2GIVi
	 DlbGGmbMiCJK/a/aJsNCu8j1DlaXXb5/q+i1jl9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1178/1887] drm/vc4: hvs/v3d: Fix null dereference in unbind
Date: Wed, 28 Oct 2026 17:54:34 +0100
Message-ID: <20261028170526.213766945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregor Herburger <gregor.herburger@linutronix.de>

[ Upstream commit 7dc3680b7ffe01add3e9299fde8471d2dd53a8ae ]

The hvs and v3d drivers use dev_get_drvdata(master) in their unbind
functions. Since the vc4-drm gets removed before its dependent drivers
(vc4_hvs/vc4_v3d) the vc4_hvs_unbind/vc4_v3d_unbind functions try to
get drvdata of its master and fails with a null dereference error.

Use the data pointer passed to the unbind functions directly instead of
dev_get_drvdata(master). This avoids using potentially freed memory.

Fixes: d3f5168a0810 ("drm/vc4: Bind and initialize the V3D engine.")
Fixes: c8b75bca92cb ("drm/vc4: Add KMS support for Raspberry Pi.")
Signed-off-by: Gregor Herburger <gregor.herburger@linutronix.de>
Link: https://patch.msgid.link/20260721-rpi-vc4-fix-v2-1-b813dcd01dc7@linutronix.de
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 88442cb65915f..289485b25ffde 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -945,7 +945,7 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 static void vc4_hvs_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_mm_node *node, *next;
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index 0396de846dffb..1dd41e2855d11 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -511,7 +511,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 static void vc4_v3d_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 
 	/* A straggler vc4_reset() re-enables the interrupt. */
-- 
2.53.0



