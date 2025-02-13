Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB5281360;
	Thu, 13 Feb 2025 14:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457240; cv=none; b=kwN09utVahnYYLj4GIWLUpDNRaFgcxaf8DScLJ4NeVXM164oa2ZlQZ3FHKMfNtMt8JC9IFLwldkegJIj3VVmZs34lYGKMzg+lAt+l7wq9lnUmnLWUg7dNncDxetnmHfv1MqXR+sljEPIz2B+9iI94xj2FEZ8fZuqYdsh4gzR9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457240; c=relaxed/simple;
	bh=l2qZ1K+P7tgw3hjfKJ5Uw4jCNtL0AEK9yIK1k31EJc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCoL+AolzOatF6uwpXQiRIiLtwASi7smnCa6zNd5lRE2StA2ZrCjLGfstORgqet3ejAEtUKlEa7HeviXKiCKhDOUIWWMEXJ6oEh/jFFeoasqw7uHZXcJP+QzsEXpoH0d3ErppxJe0aXZX5wJYAoiGjp6T3OAr3N+JDX+AKnysrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdJI2UbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdJI2UbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43E3C4CED1;
	Thu, 13 Feb 2025 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457240;
	bh=l2qZ1K+P7tgw3hjfKJ5Uw4jCNtL0AEK9yIK1k31EJc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdJI2UbPu56eaEj5M3jPFFUXR5NW2Q5YmceeH1s6E34eAQ1hWiTvEg6b6gz40I0DT
	 j1226oXFCKXmMGQ6h/iqq30Q+f85o+eBQSDDPuTMWg+3wr6QcxCZjGUDbVYfd6IZKU
	 18qjKmGFlUdwchSGgMLmTOOlnhTeZ584ITLPsUZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/422] drm/tests: hdmi: handle empty modes in find_preferred_mode()
Date: Thu, 13 Feb 2025 15:22:52 +0100
Message-ID: <20250213142437.450507500@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d3314efd6ebf335a3682b1d6b1b81cdab3d8254a ]

If the connector->modes list is empty, then list_first_entry() returns a
bogus entry. Change that to use list_first_entry_or_null().

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241130-hdmi-mode-valid-v5-1-742644ec3b1f@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
index 294773342e710..1e77689af6549 100644
--- a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
@@ -46,7 +46,7 @@ static struct drm_display_mode *find_preferred_mode(struct drm_connector *connec
 	struct drm_display_mode *mode, *preferred;
 
 	mutex_lock(&drm->mode_config.mutex);
-	preferred = list_first_entry(&connector->modes, struct drm_display_mode, head);
+	preferred = list_first_entry_or_null(&connector->modes, struct drm_display_mode, head);
 	list_for_each_entry(mode, &connector->modes, head)
 		if (mode->type & DRM_MODE_TYPE_PREFERRED)
 			preferred = mode;
-- 
2.39.5



