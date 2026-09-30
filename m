Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8295C389104;
	Wed, 30 Sep 2026 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787682; cv=none; b=B87yoetYEcWgQTnaNsB4S38koXZiPIgz5xGjXtSu4p8+V4hrbJ9WhZ/Cc+S95RQhCg4ogCebNjNALwenwjxOepU7xiB4EYU5V8KV/no08dJkHLjr8AZEhJrtBNS7HwFq7piiHJi9r1QWZrb7PdDqKOvhdwlCtEMheYXZe9KynHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787682; c=relaxed/simple;
	bh=ez2y8BMW1/pURIgwLW8rBUCVwUxxHt9iB0ULZYj9sD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBIx+6Rjo/IkaIYq0wtc75zTyoqlm0S4Tmo1KXG9u2pcAeRlPBMWNcWe/ZZ66HObOXNLj3zwqW51/RN1nlfIq6N/iRg9lrln9inXju2mNhtuH/3hAaFkNrV8gsIeVpmU+4RwflLJHlre5InUcn9a/L3GjyqD1xLv7PwbgoOupL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONgpWOVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONgpWOVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E090E1F000FF;
	Wed, 30 Sep 2026 17:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787681;
	bh=owL9aUoNkY+Ju5+dXOQePliGl1sn6y1icChCMy+tVzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONgpWOVDjcqEPko0GAI8UOBnHoTdYbxZ4AkFAM0rvMJaiu0dlTiO8iSdv0BccP1/b
	 /xkPp2VuPGDzxyiGrPPR3fYMbaM/9IyhuS8Tee4qRJDdy0zVCxavHMvrKcmD7m3poc
	 OdrcHoGmBkZfHeU80SzPnEZ3beiswdzYpKiMKCnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.2 299/457] drm/nouveau: Fix runtime PM leak in nouveau_connector_detect()
Date: Wed, 30 Sep 2026 17:26:44 +0200
Message-ID: <20260930152352.485151882@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 1e04611d3735543bd80a67d9d13dc13f503746fb upstream.

If nvif_outp_edid_get() fails, nouveau_connector_detect() returns
early without dropping the runtime PM reference taken at the start
of the function, keeping the device powered on until the next
successful detect.

Balance the reference on the error path like the other exit paths
do.

Fixes: 0cd7e0718139 ("drm/nouveau/disp: add output method to fetch edid")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260916180342.2090360-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -600,8 +600,11 @@ nouveau_connector_detect(struct drm_conn
 				new_edid = drm_get_edid(connector, nv_encoder->i2c);
 		} else {
 			ret = nvif_outp_edid_get(&nv_encoder->outp, (u8 **)&new_edid);
-			if (ret < 0)
+			if (ret < 0) {
+				pm_runtime_mark_last_busy(dev->dev);
+				pm_runtime_put_autosuspend(dev->dev);
 				return connector_status_disconnected;
+			}
 		}
 
 		nouveau_connector_set_edid(nv_connector, new_edid);


