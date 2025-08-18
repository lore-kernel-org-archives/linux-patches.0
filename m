Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D5B322752;
	Mon, 18 Aug 2025 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525563; cv=none; b=BLPT9dtobK9l+PQxAi0FqDCHVql93zG/pVPwUvVWeq0icY8kFfoZLuUX9nqiF/0jtergTi8H59UskaeFGFUYivh6BUqjiHSNqBtfxXNk+hlSzWHhsz70FgJBxnZYoz1zAahMURoZoq/r96BnQ5upZcHJS99rBawH7n2sixRAkIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525563; c=relaxed/simple;
	bh=2Il0yDzCdapbQSepjeowdw+XmfHKvvU0jtmqEsxxde0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COwpo9Q3LvO9NSmX/Uj29w9b5ShHjDUW1PRBMtfTEWc/UYDVMipjjCI3g6x8ymHTJFzAEPvgigUw1MmfT4JP94RNgI7S53bWXCMAR0LLZG1bRN0eqvn4/lZ46Qkedl11csXcTqwMEf3lIENtA6JXNxDDQN1eaAPz4l9FHNZ/BUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z043ZTb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z043ZTb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB526C4CEEB;
	Mon, 18 Aug 2025 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525563;
	bh=2Il0yDzCdapbQSepjeowdw+XmfHKvvU0jtmqEsxxde0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z043ZTb+BA9ybiP4WHUG5NBDZ8BrbW8UuPWy1BYvHVyk3xebhKY9scEXISxydh8En
	 ttcv0JKVJEB5B9ZeCNjBMfonQ3FUpEPAYykifemMaIoME117J2mXN2ZgFWA5NvC+PM
	 Rh5qbN4OXQp7PVExzAD2iYx+TQFrv8wSQD9hFxVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 273/570] drm/msm: Add error handling for krealloc in metadata setup
Date: Mon, 18 Aug 2025 14:44:20 +0200
Message-ID: <20250818124516.372583979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d007687c2446..f0d016ce8e11 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -555,6 +555,7 @@ static int msm_ioctl_gem_info_set_metadata(struct drm_gem_object *obj,
 					   u32 metadata_size)
 {
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
+	void *new_metadata;
 	void *buf;
 	int ret;
 
@@ -572,8 +573,14 @@ static int msm_ioctl_gem_info_set_metadata(struct drm_gem_object *obj,
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



