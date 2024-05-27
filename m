Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B97717E90E;
	Mon, 27 May 2024 19:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837142; cv=none; b=ZYNifocTmytcZjy2LcnBgDDhhxhy8WffrC8fp192Ngzoq838uTyo2sh+qHrvgll11/xCWRSEZyP7HnPoukP+RQ13+Cm/fnw/B4fY9ZDNRFAO6RQv/CvB8blBhNeTxA/ekl3AUjVnocq1glinGzhmwnX6p3Ia7Jmsu9wajPD508c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837142; c=relaxed/simple;
	bh=upod/bHbKVLjnwoAyzeFYKOeRxhB80u7Y5/pItAeg0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdtUG9HmOVBKzR5EPOOhBO0xuPy8HqW3J94lAb3/fGprogNq/5gnB8MprxzyqbWKPwDA8j7tOmhW0vEGQR2g8Ob+5Zd59YI8yWIV9wVEhyckwLrz6LKBBH4yDURR3bRGhabuNC+YXrWHHjuAV85NNn+Wj8YNgp9Iv5YUQFWAykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a691Pwup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a691Pwup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A2CC2BBFC;
	Mon, 27 May 2024 19:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837142;
	bh=upod/bHbKVLjnwoAyzeFYKOeRxhB80u7Y5/pItAeg0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a691Pwupzq+00AGVu4MwpoSrugtvdRtk5XLXhXtLoNfFc9C8csoo+6oeGpyVWID2W
	 ggrbfsU5EU0VFBE+r6XblD9bPbE3dGTnmx2r0o4dAOfFu/5cR+k2oAo47UZFsjfPqT
	 zVvVPzAWe1i7ONNq8RlZV5+sfdHQ6v6mmILBmjaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 327/427] drm/arm/malidp: fix a possible null pointer dereference
Date: Mon, 27 May 2024 20:56:14 +0200
Message-ID: <20240527185632.005534707@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 626709bec6f5f..2577f0cef8fcd 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -72,7 +72,10 @@ static void malidp_mw_connector_reset(struct drm_connector *connector)
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



