Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0BA2C80;
	Tue,  3 Dec 2024 15:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240962; cv=none; b=TvRQbKs6kDncRjdZewUchSa/ZMKPSwLjFXTW66rINkb2zhykjJU7SpIRS/4jq0Qm2FbBI5jDOvgcjHrrUG9BaMspdYYZanO8svGOKfHlU+6w8vW/skLodLzMF0+WcPC35qOZnE2XcGoVBrXqWnetSDRB+G7VsFs8BWF/DL+N1Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240962; c=relaxed/simple;
	bh=4psw16yif1wqH/Gz3LMW7z5uEgO+JbwEBPb5tBGNKZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZIZRChZnTsHuMDfRlwUJf4jB57IsChCAEtLEuIObSx6zimC3oRzZP2MqmgCsoJQjo6hxwnXAWu3QzRcNQA3hoPEgShXO4wV474YMyMqEYnascD33ZM2dQClhjAH6W9KyXGT4FZw9yqsVLLyTn3sowoN2Z5V9fdwVGJrXPCbHyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MR04oNsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MR04oNsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E00C4CED8;
	Tue,  3 Dec 2024 15:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240962;
	bh=4psw16yif1wqH/Gz3LMW7z5uEgO+JbwEBPb5tBGNKZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MR04oNsQBYCZJ2sUVy3YCl+8yTtj4jSjyyVYGoFZ2mcdKJUCWGhBuQhPlfLsVmjqi
	 j2YDHud7NsCPvXHG/GWTJm8cTU/0Mz0Rij6dsNLIvfThJOgCSx8jmFQNiE+JE0QFfM
	 hA5f8OK9PH2BzPmR3/srhCG+CWF95RDNv/+0SYWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 287/826] drm: xlnx: zynqmp_disp: layer may be null while releasing
Date: Tue,  3 Dec 2024 15:40:14 +0100
Message-ID: <20241203144754.966424975@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>

[ Upstream commit 223842c7702b52846b1c5aef8aca7474ec1fd29b ]

layer->info can be null if we have an error on the first layer in
zynqmp_disp_create_layers

Fixes: 1836fd5ed98d ("drm: xlnx: zynqmp_dpsub: Minimize usage of global flag")
Signed-off-by: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241028133941.54264-1-lists@steffen.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_disp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_disp.c b/drivers/gpu/drm/xlnx/zynqmp_disp.c
index 9368acf56eaf7..e4e0e299e8a7d 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_disp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_disp.c
@@ -1200,6 +1200,9 @@ static void zynqmp_disp_layer_release_dma(struct zynqmp_disp *disp,
 {
 	unsigned int i;
 
+	if (!layer->info)
+		return;
+
 	for (i = 0; i < layer->info->num_channels; i++) {
 		struct zynqmp_disp_layer_dma *dma = &layer->dmas[i];
 
-- 
2.43.0



