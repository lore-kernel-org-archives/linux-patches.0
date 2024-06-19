Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401BE1E492;
	Wed, 19 Jun 2024 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803974; cv=none; b=dzYavC9t9oAMRLcaFkV6IXuP99MPb4j0w/8pwrmTtkJNeW+1f9VsESdNgv2YRB3j1c9nduG940hM8m+xNZJH7d0ypc3XPC6aW5msMPxxyL0IgW51jMGsoFuY6VqKFixeVqsF9CMfHP4HB2b5+Uad0YtwEWMVdpuHdo2lfRZLMiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803974; c=relaxed/simple;
	bh=b9liyIzBL6NLJJpWeqHppTCDmuWePQBeG4Syoo3pP24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQrOwpBYtTuElugyXeJGDVzpMS3mAhdmDJ8rFMub31CSLULnR6iUHa9cHfn+xswkuAzrQQHWr+aJNkHhSn5ve9yzulP8c9wxiC1aBBLipp8ptA1/PDaoPemSfOEmQRM2hkUcJ2u/6xw7kfftWbMMCiVpPQy+ekL7+kFSCN6QeYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiYt0sux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiYt0sux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB71DC2BBFC;
	Wed, 19 Jun 2024 13:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803974;
	bh=b9liyIzBL6NLJJpWeqHppTCDmuWePQBeG4Syoo3pP24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiYt0suxIuSc6phxX7siRM7cvjvLH6oij7r5Zpgo23Ouwrka/15UT7iTD5vr10J/S
	 z2In4f9JFrDq/eSP5JjB7QEs3L3wAsvWyJv9ZNZAl3KMD1lbdMOr3l+eHoHCjJa+Bw
	 ojM+sYdvo+B5nYrPIrw57jZg8XZt/IhC1aojX/ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 6.1 165/217] drm/exynos/vidi: fix memory leak in .get_modes()
Date: Wed, 19 Jun 2024 14:56:48 +0200
Message-ID: <20240619125603.057263738@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


