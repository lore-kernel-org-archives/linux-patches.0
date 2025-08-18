Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CDC31B13A;
	Mon, 18 Aug 2025 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522091; cv=none; b=HxEuDjYxneN73jHvSxXitZH/oITSYSHstjGc5aSDAzbCvlqkzIQue5SyAr7xwuFJBqqeS1Z9B8f+mNl+itbTEvN5ytA/qBgrbehtc1BI90oGA0oXSNJ8BnmBRYoC7qeOCYCtG/b4cs8DJ3Zgx+SQ64g+vZHeFYnf+23bTzS7o/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522091; c=relaxed/simple;
	bh=ALrXtLm1kCcMgm/jA+oJToYSkYN8zkaWQfc2hiQINmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Po9EErpXKvaXSBwshUNq293c0rWjtrhyjQ0eZiHSXFt6BXwcATbViets1R8jGPiTrdqfzzMvMtOJkWt36WfG1QHL0qeqYNiDqptyOtHxwAWliP1TpzY8oORWKOqDTb4vgsk+nBLIIaHNajbEEF0/440dk5i1q9AY2AYHBjf4FLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwO2cyTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwO2cyTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327FAC4CEEB;
	Mon, 18 Aug 2025 13:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522091;
	bh=ALrXtLm1kCcMgm/jA+oJToYSkYN8zkaWQfc2hiQINmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwO2cyTUE2PcyzsU+AW3dtihqxGcPKw8iW5kzKRr3LePe5XQv75xAtRyXNi5F09IT
	 beYxj4Zv0XTA7uO70ebL8a4NSGTgAYGWOpRtkYxXBHxKaQDVqk70aLvJVkM0Ew+UJK
	 qipObrEroKR3js083i6Xmzj3cf0ggMPyng/2UgoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/444] drm/msm: Add error handling for krealloc in metadata setup
Date: Mon, 18 Aug 2025 14:43:57 +0200
Message-ID: <20250818124456.761793135@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 1c8c354098ea9d4376a58c96ae6b65288a6f15d8 ]

Function msm_ioctl_gem_info_set_metadata() now checks for krealloc
failure and returns -ENOMEM, avoiding potential NULL pointer dereference.
Explicitly avoids __GFP_NOFAIL due to deadlock risks and allocation constraints.

Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Patchwork: https://patchwork.freedesktop.org/patch/661235/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 8c13b08708d2..197d8d9a421d 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -550,6 +550,7 @@ static int msm_ioctl_gem_info_set_metadata(struct drm_gem_object *obj,
 					   u32 metadata_size)
 {
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
+	void *new_metadata;
 	void *buf;
 	int ret;
 
@@ -567,8 +568,14 @@ static int msm_ioctl_gem_info_set_metadata(struct drm_gem_object *obj,
 	if (ret)
 		goto out;
 
-	msm_obj->metadata =
+	new_metadata =
 		krealloc(msm_obj->metadata, metadata_size, GFP_KERNEL);
+	if (!new_metadata) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	msm_obj->metadata = new_metadata;
 	msm_obj->metadata_size = metadata_size;
 	memcpy(msm_obj->metadata, buf, metadata_size);
 
-- 
2.39.5



