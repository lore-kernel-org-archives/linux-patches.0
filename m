Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FBD3B19BA;
	Sat, 17 Oct 2026 17:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259052; cv=none; b=or9dSGCmHD+enEEOIi9G1ZM0R0PkDoLdHTsUO16vVeuA8/K74ghbKQ9I4Ux6HSG3fcDn6YOMHyCnE2PmTPGbOxBKoW6DFym461PCedzE2BXEOS8bIZUc1n00Q6KYfbc5uhF1RxMzrRP6Gn+tfRaplUn2t4Rs6/QvzCatOpLTdAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259052; c=relaxed/simple;
	bh=LoYvWOLrXzz5hd89o54zW2N4Q4cK/pqcbvkb6c4s5Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+pji2u2z20Z80T+mn1Mb6ShC+5MajSLqvy9n6Q3GkvYEN5V8oXCPiH1YOh516/6kYR5ugXeUC/FifAhQTz2s0+k1JAu95tFgidfL9AW1Is7bV3fqBFVf0YDr6i7WMYKkbTFJQklG6bA7wSGXDRITJQnlr6lBmKxRO42OuKBe3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FA02mM1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FA02mM1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8F11F000C4;
	Sat, 17 Oct 2026 17:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259051;
	bh=YdjFM7gBW7/sE14PktFKZXzi6jTM8q9bg4QlH5qs/lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FA02mM1n/LWymAYEca3D1zTnp37IZxm8iVdvbD3HpqSVKEH5H9VaCVDjNJcbmTaHF
	 AawYXJ9UZ1rtojpOuaqnscP7IwDxyYAeidjGWAU4Q4Q2Vu5YC8TkokImiIzJWWq8hv
	 1ee44zftMmZWyT0VR7zGVNBxcBSrGvU4l7QmXNlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1086/1674] drm/vc4: hvs/v3d: Fix null dereference in unbind
Date: Sat, 17 Oct 2026 17:55:58 +0200
Message-ID: <20261017160459.004938906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bea1b3d35cdd3..4e74617e493e0 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -1045,7 +1045,7 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 static void vc4_hvs_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_mm_node *node, *next;
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index 12d091ae07d67..39f37b921ae5f 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -505,7 +505,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 static void vc4_v3d_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 
 	/* A straggler vc4_reset() re-enables the interrupt. */
-- 
2.53.0



