Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3651A1DDC5;
	Thu, 13 Jun 2024 12:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282039; cv=none; b=nWzsOmzQkLwMHHhIsxIf/A6oNrrBCDUGsPGppSO0fhzBw3ZqG0BsFzFMBo6uRKUFbTUmdmXUqxmfOEfITXGLs7/mjHN1ZGEAYRWYAOYrPiwCphC1jODnAM2a6chzkyUCAAhzhbG+PI4b2Je8NetSu3ok2FSeIu+iv8Y509NTRmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282039; c=relaxed/simple;
	bh=lhBEEWuRZ13mk1ESigstEKzxSYk3IezflIieUivJY2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAzea+uachFEB08PG68PE+7IMrhpSv9sRU99O5d9pighTFpBNzqOt4sgVjpr2Aukebc2wM58AIIM++Khy1O4R1mwiLB61Q1FzzdTPAwGdds9DcLaQbY6ecdjNEhy8L/vyCXQiwEr5F8Wrq6NK/Y20Gxmi8wUhsf/Z79o6mk4ztQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5eqBFGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5eqBFGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573C6C2BBFC;
	Thu, 13 Jun 2024 12:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282038;
	bh=lhBEEWuRZ13mk1ESigstEKzxSYk3IezflIieUivJY2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5eqBFGiPaMvvz7FAP3Vm1z6jKrphStglxl8I3b9XussbcSnXL48mIQHxf/TdyujW
	 exfWtkciyPaAn+V6JMSnDxsx0E0Vc2yHb9FezEYZD4AFscYK6Hvt/nIl6cYDBtf0NO
	 eOYHj2+igTAoBxfKBUsFuVB+gUiNfw3aeogup4/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/402] drm/arm/malidp: fix a possible null pointer dereference
Date: Thu, 13 Jun 2024 13:31:38 +0200
Message-ID: <20240613113307.636025334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f5847a79dd7e8..0720b2197c4e7 100644
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



