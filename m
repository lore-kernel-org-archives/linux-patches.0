Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE8B15442C;
	Thu,  3 Jul 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555156; cv=none; b=ldN74p6O3LUY7tHFKPgw8EFlrs5dqzHMK2lvdwum1Bx40TO8NSLTJqestL1V/T1ygAPU1sCG4Cyaum6o9outvOC0bGCOFk5ihZimu+eo6kSfOjmLXCAuNU5p4xD+k35MPw8UlTzZl7FMYLyRIzVM7ySuYNAEopMDbpKK6D+iIvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555156; c=relaxed/simple;
	bh=V+ty9Lv6qW92+wcxNcjYOaaRia7WjKJ0XzFGBD4h22A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSv/t1khVCRwxaoGuFcw2BE/0IJ6XBXAbtP5AKstUnaCp00imFIWnC7oQUlmZlwi7NtAGORivys5J0h+PE0Y4q1k5jym7F2Bw+6+gJDuGLAIjT/yzj/PguoWnLpx66YAhepch6u6f3nf3kd+JOaYwUWinZXEuZKk9jis/YRcQEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2ROFHB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2ROFHB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCB5C4CEE3;
	Thu,  3 Jul 2025 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555155;
	bh=V+ty9Lv6qW92+wcxNcjYOaaRia7WjKJ0XzFGBD4h22A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2ROFHB2rAu+VzE1uyNF9jeADgNYo71GlwJFhS6ODSTLsxGtXfBlwZEkS1mR54uJl
	 x3qLc79QWtggQz8NrNI6gHLfsMor6wXju8JTjfoCfMas9jGZg0OX+qeCNn1Fq3OtDz
	 CMSaJOxjHpF7MAddAkOQFGRScPsQbZLzhnvR/u8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Yacoub <markyacoub@google.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 163/263] drm: writeback: Fix drm_writeback_connector_cleanup signature
Date: Thu,  3 Jul 2025 16:41:23 +0200
Message-ID: <20250703144010.899615408@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Chauvet <louis.chauvet@bootlin.com>

[ Upstream commit fb721b2c35b1829b8ecf62e3adb41cf30260316a ]

The drm_writeback_connector_cleanup have the signature:

     static void drm_writeback_connector_cleanup(
		struct drm_device *dev,
		struct drm_writeback_connector *wb_connector)

But it is stored and used as a drmres_release_t

    typedef void (*drmres_release_t)(struct drm_device *dev, void *res);

While the current code is valid and does not produce any warning, the
CFI runtime check (CONFIG_CFI_CLANG) can fail because the function
signature is not the same as drmres_release_t.

In order to fix this, change the function signature to match what is
expected by drmres_release_t.

Fixes: 1914ba2b91ea ("drm: writeback: Create drmm variants for drm_writeback_connector initialization")

Suggested-by: Mark Yacoub <markyacoub@google.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://lore.kernel.org/r/20250429-drm-fix-writeback-cleanup-v2-1-548ff3a4e284@bootlin.com
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_writeback.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
index edbeab88ff2b6..d983ee85cf134 100644
--- a/drivers/gpu/drm/drm_writeback.c
+++ b/drivers/gpu/drm/drm_writeback.c
@@ -343,17 +343,18 @@ EXPORT_SYMBOL(drm_writeback_connector_init_with_encoder);
 /**
  * drm_writeback_connector_cleanup - Cleanup the writeback connector
  * @dev: DRM device
- * @wb_connector: Pointer to the writeback connector to clean up
+ * @data: Pointer to the writeback connector to clean up
  *
  * This will decrement the reference counter of blobs and destroy properties. It
  * will also clean the remaining jobs in this writeback connector. Caution: This helper will not
  * clean up the attached encoder and the drm_connector.
  */
 static void drm_writeback_connector_cleanup(struct drm_device *dev,
-					    struct drm_writeback_connector *wb_connector)
+					    void *data)
 {
 	unsigned long flags;
 	struct drm_writeback_job *pos, *n;
+	struct drm_writeback_connector *wb_connector = data;
 
 	delete_writeback_properties(dev);
 	drm_property_blob_put(wb_connector->pixel_formats_blob_ptr);
@@ -405,7 +406,7 @@ int drmm_writeback_connector_init(struct drm_device *dev,
 	if (ret)
 		return ret;
 
-	ret = drmm_add_action_or_reset(dev, (void *)drm_writeback_connector_cleanup,
+	ret = drmm_add_action_or_reset(dev, drm_writeback_connector_cleanup,
 				       wb_connector);
 	if (ret)
 		return ret;
-- 
2.39.5



