Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3968420FAAB;
	Thu, 27 Nov 2025 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255659; cv=none; b=MaQj7YmFsT51fn1XpUAaoydvx5zxLvB8Y7+W2nh2wOJ6jJ66F11nN6QAhCPclOnkWOn/E9Qv3AOtpiYVrfNW3MZ5HVv83HP396td7e41EnaBvX5vCq1oSFpnh8wQOSOwFBZNFufrLFjLU8FAXxUKYXgZ1UODlo5QMGVcMdqg4Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255659; c=relaxed/simple;
	bh=4qDj80O4qqVeIcbpg8UgqeTgA0fgg6Ev2gCx5zZFY/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uajI3faS3YHtwJnB4qP9WDMIfrK8egeBpGwEUuT05hP710H0qWkDDpS9c97gFeHR02KDw6q42hbZE8kZOkGsK8P+YSBeW/zmHsbhOddGj+2RBQIvlm39WUrWTVSEi8pam5LnV54tEWczWY/Wqmq19S3RQBUCnXjSK05S2h5ST3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKld0yBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKld0yBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B240CC4CEF8;
	Thu, 27 Nov 2025 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255659;
	bh=4qDj80O4qqVeIcbpg8UgqeTgA0fgg6Ev2gCx5zZFY/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKld0yBk2ytTXs6DtGOBa2vICAZ464rVTAEQ2Vt/vuBmFJ5+mCoWUsQ82I2CviT+y
	 HaqtLF4LPfioII6FLkaIzmo1wMaWGnZOWU46ZKT7AeJrl3SfSeX1wTF3dRXy8qq5ga
	 mJ6kRO2yKbgSrnBOOG//wNxgbzv0lTkyWv5Yzw5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun R Murthy <arun.r.murthy@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 6.17 070/175] drm/plane: Fix create_in_format_blob() return value
Date: Thu, 27 Nov 2025 15:45:23 +0100
Message-ID: <20251127144045.523290439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit cead55e24cf9e092890cf51c0548eccd7569defa upstream.

create_in_format_blob() is either supposed to return a valid
pointer or an error, but never NULL. The caller will dereference
the blob when it is not an error, and thus will oops if NULL
returned. Return proper error values in the failure cases.

Cc: stable@vger.kernel.org
Cc: Arun R Murthy <arun.r.murthy@intel.com>
Fixes: 0d6dcd741c26 ("drm/plane: modify create_in_formats to acommodate async")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20251112233030.24117-2-ville.syrjala@linux.intel.com
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_plane.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
index 38f82391bfda..a30493ed9715 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -210,7 +210,7 @@ static struct drm_property_blob *create_in_format_blob(struct drm_device *dev,
 	formats_size = sizeof(__u32) * plane->format_count;
 	if (WARN_ON(!formats_size)) {
 		/* 0 formats are never expected */
-		return 0;
+		return ERR_PTR(-EINVAL);
 	}
 
 	modifiers_size =
@@ -226,7 +226,7 @@ static struct drm_property_blob *create_in_format_blob(struct drm_device *dev,
 
 	blob = drm_property_create_blob(dev, blob_size, NULL);
 	if (IS_ERR(blob))
-		return NULL;
+		return blob;
 
 	blob_data = blob->data;
 	blob_data->version = FORMAT_BLOB_CURRENT;
-- 
2.52.0



