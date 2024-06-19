Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C613A12FB31;
	Wed, 19 Jun 2024 13:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802520; cv=none; b=uwe7oMOpbJB5lUu4E27MrvwKYdthzQQvvpobxVjyFNhCN1ZipO9dPz1CrwZUFXDUNDRx5ayuUpSPYzyxqhQ/Gw1qDfeAgV0clQPzXjaBZgnfNqkRFr9QmnDXOXmP0/hARDe8AaLy/sHutT/a4ywfO6xBGRwA2TolE6J+LfiXD84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802520; c=relaxed/simple;
	bh=4Vuuo1qnUA9FpzO6ILhLsulxJGGc60b1DjBmtxdBEhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WozBUBR1hStARY0M6RzzrMS5zsFsofQ7RxzcYAYfFw1QQuH0oH2biMI24DqLTXsKWV5GoERzVOg2EOEklRos8LFpq/tdEd6UHeQZVxOXEllLamnBFFB+XQXFtNLgK++LZOc2QRv3lQkt442mCyBgoRbkFLTVhGTA++GN66ajL3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8Kl0tf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8Kl0tf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4991EC4AF4D;
	Wed, 19 Jun 2024 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802520;
	bh=4Vuuo1qnUA9FpzO6ILhLsulxJGGc60b1DjBmtxdBEhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8Kl0tf/TZfpqCLE8PNFQvnFMovv0IRv9ucYZ2AIBv+4zP/dAVUxaacv0+TPMqxUO
	 kt+KeAKF3Jg3NCdECigIL6uccSgzw5fiSfhc8owTafMa+o5kfn5YZZJvAmk4pwyICd
	 J1hS87+rVYyf/vNUVLCOPDsEOJFLRunAJyuQkhgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 6.6 183/267] drm/exynos/vidi: fix memory leak in .get_modes()
Date: Wed, 19 Jun 2024 14:55:34 +0200
Message-ID: <20240619125613.367369869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 38e3825631b1f314b21e3ade00b5a4d737eb054e upstream.

The duplicated EDID is never freed. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -309,6 +309,7 @@ static int vidi_get_modes(struct drm_con
 	struct vidi_context *ctx = ctx_from_connector(connector);
 	struct edid *edid;
 	int edid_len;
+	int count;
 
 	/*
 	 * the edid data comes from user side and it would be set
@@ -328,7 +329,11 @@ static int vidi_get_modes(struct drm_con
 
 	drm_connector_update_edid_property(connector, edid);
 
-	return drm_add_edid_modes(connector, edid);
+	count = drm_add_edid_modes(connector, edid);
+
+	kfree(edid);
+
+	return count;
 }
 
 static const struct drm_connector_helper_funcs vidi_connector_helper_funcs = {


