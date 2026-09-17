Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23904D957E;
	Thu, 17 Sep 2026 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668607; cv=none; b=IXmceOhWnoEAgY5nDMnzpJPWoLIEWy7kPEjRlHq6C2TCmXpvrjqtlpDRhgErPIz2gFq5XRTTl8y9w6OL4V7oQOa6nFynz+66GEidPDnIBX7La95v5jGhqkxxHm1eQ4y/RZsMNzJBfjb48875HkBU2MD/ox9PfswDmazHqz9r/Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668607; c=relaxed/simple;
	bh=tdXhTyxtZYhV235986F+ZjgNDzOfiuuwo464G3cyfLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nhjz9fm5w3q0C/ydFg4NYCGbNCGO1gEJ4m1F0JCWlApPYpPH576/G2+MaDkp8lj+8Ua9gfK0XUqA9RzJJbsvU+N3ejcXdfqrL/9WKG6XfYvPV/8dZhH1V3XNBFO0c9xvJtqWPOEpU5YxRvLVIW45z6aWe9PqWHotUnJHXfLVhfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBspJYIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBspJYIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0F71F000FF;
	Thu, 17 Sep 2026 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668606;
	bh=K8/fHSe7z7svSdXySLjDNc2YqXePHGMN8AFFM2slpcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBspJYIjOa8uAP+J0is+RtI6LCDbOmZ7kMRfrXQXPklLokhRcAMCrrshJzKuhnbue
	 bpCSHh6H+JAaCsvocx4i06zdi38O+hSKui0q33sc4/x0p9prDwAb/pTPkjL41VmztO
	 z9lqCV0DuoqaGSqRinoJO4166AedoL/K42rgHM10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0481/1102] drm/vc4: hvs/v3d: Fix null dereference in unbind
Date: Thu, 17 Sep 2026 16:07:04 +0100
Message-ID: <20260917151551.773259457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index c389e82463bfd..a52c4843a9929 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -1052,7 +1052,7 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 static void vc4_hvs_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_mm_node *node, *next;
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index 334d2cfe3433b..a9a57a9c6f63d 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -492,7 +492,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 static void vc4_v3d_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct drm_device *drm = dev_get_drvdata(master);
+	struct drm_device *drm = data;
 	struct vc4_dev *vc4 = to_vc4_dev(drm);
 
 	vc4_irq_uninstall(drm);
-- 
2.53.0



