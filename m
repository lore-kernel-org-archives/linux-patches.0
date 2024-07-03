Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3014A17279B;
	Wed,  3 Jul 2024 10:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003926; cv=none; b=at+GVjWEDLVXseuGpiArYDEde7sxb7HE5GpMpDxk5gYKYVj7vYLJwNBjoV2pPrd400eWoAqpvhv55bQsoxrIh74MlH5fCiN/1BXKzAaQcUz+0o/fggCBaujxg4g09UvxHlmYKlcp7fRAXNPEdjay+IsN0mj1dKW9gj00kZ+1NLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003926; c=relaxed/simple;
	bh=2cN6raZijs+7Qr6em/UXjBUEZ7Jmf4nvArlVBjvq73g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEIlaaaAkchAUIG1odjjNnG9pwvzxHdL+hX9FaZKP0Lj4FVpPysjs7z7jAhkf1b80Frb+UPE6fIRKEEOsiKcl7KN37DNVfDF6Zaibl5kI+mrMUVg04VaS9tbkJ783mmreL/7iNBnttA5zFqDppOLHQC+tFP9OJBfGDHYTtIEqKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9eaDuUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9eaDuUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A94C2BD10;
	Wed,  3 Jul 2024 10:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003926;
	bh=2cN6raZijs+7Qr6em/UXjBUEZ7Jmf4nvArlVBjvq73g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9eaDuUTPV+8WRAmiQMyBvQ/dIQz6oY0YwlydjDOFiufH1aqs8zvRXW9RUAfYEBFD
	 0ELiZffy6ODiIgAbWdKCSmYl4GbPH5w9iWF4xbH72JZWciAaswjXYxwD3eMSsVjF5G
	 7b3kmxrnfWCDvEDBX5z0yMUTsMtHXZmnA1sfcyCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 5.4 067/189] drm/exynos/vidi: fix memory leak in .get_modes()
Date: Wed,  3 Jul 2024 12:38:48 +0200
Message-ID: <20240703102844.036535207@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -301,6 +301,7 @@ static int vidi_get_modes(struct drm_con
 	struct vidi_context *ctx = ctx_from_connector(connector);
 	struct edid *edid;
 	int edid_len;
+	int count;
 
 	/*
 	 * the edid data comes from user side and it would be set
@@ -320,7 +321,11 @@ static int vidi_get_modes(struct drm_con
 
 	drm_connector_update_edid_property(connector, edid);
 
-	return drm_add_edid_modes(connector, edid);
+	count = drm_add_edid_modes(connector, edid);
+
+	kfree(edid);
+
+	return count;
 }
 
 static const struct drm_connector_helper_funcs vidi_connector_helper_funcs = {


