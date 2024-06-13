Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053B7143892;
	Thu, 13 Jun 2024 12:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281081; cv=none; b=MWNL1MeWHhcAMo65n3fCtJD8NL0dC8sJ0opz6gARoU+Ua+EQAr4a79pVfdrAbQ8i15y+XLWIiE4M+1F5MCWwo7h8wU5onVeJlq7/QV6l/+ANFsfV1f5dRjdSgr58NQdxkEZR6UtakjgMZVirhpX4pDUOAtodvDv3E9vRYBw8yrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281081; c=relaxed/simple;
	bh=DfIUhgP4CrLlpewFo7kd6oNmIGGX9FJvyVr7wRmosJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqMORnYI21YGsZf/26SudDykkp6CX+PNdS+uQHymsfeG97rFgCafmetJU2Jqx3agH9DL7xioKiw6rBcccmCCm97KXm4xHmpt4g43LVJSuKVJEJkGIHnKgJIsLkek1WWX5/ngDjwW6WbySuiJ9KzvUxOav6mPahqhPC1c/5lpv1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbQdP5m/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbQdP5m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7418BC2BBFC;
	Thu, 13 Jun 2024 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281080;
	bh=DfIUhgP4CrLlpewFo7kd6oNmIGGX9FJvyVr7wRmosJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbQdP5m/Ddehv6WDRXTDYjPBDLofwDXV7qspxUX+iezo3gCAKJxaO7KXI0pMm7Us9
	 WgbTkizgDfEmlj87rcr+tiugOJidFLv4XmUdSdHfOTZmoO74NP4VzrO80X75XXZjQn
	 srrGwfqD4BwL0CSyTsj78Lfnm21OPcHvyfIKIT3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/317] drm/arm/malidp: fix a possible null pointer dereference
Date: Thu, 13 Jun 2024 13:32:02 +0200
Message-ID: <20240613113251.575239165@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



