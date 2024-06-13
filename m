Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420A013D635;
	Thu, 13 Jun 2024 11:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279912; cv=none; b=YvmtQ8F/yR+87108Hjy2Uzh3+hQZ7y2JNoKE6TPsYYnk201qt52o0CFSDMrAF+jBewLhEA9ZarDd2YQksaYstTETTGb3cyM0p3s/QEaUDkrKOwJA/dtkq6Zdha6aZ09qo0G/pWsrnXPB20bSNHS+FviKIKdfB0FGn0u1dCRYfjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279912; c=relaxed/simple;
	bh=0CWITQ8WSYj8+PEkQoVf5A25U6E1TnXeJ9CylgdT8TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7GqMYKNCZiGYubnLN2KcK6F/CM91C4K3ifU1fQv/hhqRDBw0gFrJTX7SljX2ctzh1HCRGw2sxoKDWv7R13oDcGgfGnDRQ1ZPIf0ZULFMIsukFu9RJtFrD+qf76zqtoo4v6vRRgQO8t7lIHiW88/jfiw7ceNuOrSu3V5eqyQsSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSEXrCe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSEXrCe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB8FC2BBFC;
	Thu, 13 Jun 2024 11:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279912;
	bh=0CWITQ8WSYj8+PEkQoVf5A25U6E1TnXeJ9CylgdT8TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSEXrCe5qt8kUkzIpo7niHH2EXVK1jDnDzj7c6n/2rWhZa0DHTsYku3dzY3DhdSKO
	 vs3YTLwYz24KihfBM7y9+ZC3NSwASriwWtYRGZ8OV1KtSgkcjWbWC3Po9ZIDXBUQoK
	 9oz+uLBkhu+EPL0vBKxe1kXZjj5s7qS5WHlPOSKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/202] drm/arm/malidp: fix a possible null pointer dereference
Date: Thu, 13 Jun 2024 13:32:56 +0200
Message-ID: <20240613113230.785462693@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Huai-Yuan Liu <qq810974084@gmail.com>

[ Upstream commit a1f95aede6285dba6dd036d907196f35ae3a11ea ]

In malidp_mw_connector_reset, new memory is allocated with kzalloc, but
no check is performed. In order to prevent null pointer dereferencing,
ensure that mw_state is checked before calling
__drm_atomic_helper_connector_reset.

Fixes: 8cbc5caf36ef ("drm: mali-dp: Add writeback connector")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240407063053.5481-1-qq810974084@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_mw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
index 7d0e7b031e447..fa5e77ee3af86 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -70,7 +70,10 @@ static void malidp_mw_connector_reset(struct drm_connector *connector)
 		__drm_atomic_helper_connector_destroy_state(connector->state);
 
 	kfree(connector->state);
-	__drm_atomic_helper_connector_reset(connector, &mw_state->base);
+	connector->state = NULL;
+
+	if (mw_state)
+		__drm_atomic_helper_connector_reset(connector, &mw_state->base);
 }
 
 static enum drm_connector_status
-- 
2.43.0



