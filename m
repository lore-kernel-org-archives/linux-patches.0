Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A6C2206AF;
	Mon, 18 Aug 2025 13:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523752; cv=none; b=cgfyI8uxOhMwyhZpyMd5nhjQY8LEOACLt94SySiDUfKt5ODqLdl5eG+FMuACeZhqIBS8BQ8jpCfWBOEzSW5HxajXArMdfov9sqx7aDDuO40tl1jFuXJyZwC5iivMzjE1s+IkTS9U7EPO+gqDSrco0RTcg9RBBk+q5AZKO/8WRNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523752; c=relaxed/simple;
	bh=Pce3GuXBZKwKLdSjyb3JdKp3s32c6lAPlL13nfkiBFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqLE9rRMC0IPD40qzumW1V3UeXusEdZXPe1m3KWlREDUdYGuEjBTvnv/LXC7XuSqshivRpQKN2gjMFLRAKFe7agwJeOoaNNjm9u3VaSFZPwmou76MKrpLMTdNzs56TgjLb51wgvkQEBx2EllkB+1rx9BvK+nXUnDI015EtKrAKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WN5cCNW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WN5cCNW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22549C113D0;
	Mon, 18 Aug 2025 13:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523752;
	bh=Pce3GuXBZKwKLdSjyb3JdKp3s32c6lAPlL13nfkiBFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WN5cCNW+viKrRd7vMdurr6Lm5qmJ+C8wTwajCfxJ1I1r8ZjJiGCCr9xiOJC+8oRRt
	 fcOzPJqgR/ALKJht/hBkntt4OrD9W6pWt9n1RrxAkx5v7zFL4LZ5qGo218FcT5jM2X
	 7zlhADKSge+yKl91SoZllkedWg9CPaJlKVybz/CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 255/515] drm/msm: Add error handling for krealloc in metadata setup
Date: Mon, 18 Aug 2025 14:44:01 +0200
Message-ID: <20250818124508.229865486@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c3588dc9e537..b4e73b015d02 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -551,6 +551,7 @@ static int msm_ioctl_gem_info_set_metadata(struct drm_gem_object *obj,
 					   u32 metadata_size)
 {
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
+	void *new_metadata;
 	void *buf;
 	int ret;
 
@@ -568,8 +569,14 @@ static int msm_ioctl_gem_info_set_metadata(struct drm_gem_object *obj,
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



