Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CCB298CC4;
	Tue, 21 Jul 2026 22:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671502; cv=none; b=TMRdwP/Hiz/oSbGdstecgJUW1dZxy9gYisV52QME6WncROUdBRzNtvBDGsp6kTC4+e0prWRJXXRL3NhAv16b8iicttOm2GTnxm2nb2RmTl7Z6VyEjwyXhHRjLP3znERsf868jNh9u11nfJXQFsjyI7lPZChk9bF1scMJIyAMmUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671502; c=relaxed/simple;
	bh=NS9Xq6U4ilPny/HXpXi4lFReP3PI5L0aSaKh5tbwNnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WthRubHzhxtHNa+DpehTJJyaoy9LYtOgLJtMzCLtfGXxJ/fs+5uIVSboFtG8LJYOaBA9TSdO3Mp3WEiuY4JHV3JcZLkMVwgATa95qU1Ts5x+n1RwSjqBSBjRKQOvmmcHEEmEMpYDMJ1gXOROgHhSi2ZATNggCGSpO+bUliUwG/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGhCEEZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGhCEEZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1991F000E9;
	Tue, 21 Jul 2026 22:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671501;
	bh=BpV0z5YoO2raHqprHKXjwCSD1nBWWYE0kU+xd+iTSZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGhCEEZ5nXTluc2m6uzRW3Y33PJxuggMsJKwWjBFME+Tr004BhkixF93bQMQsQbfn
	 ptKRYRN9S3JU2E9AcySzERNQ7QQrddAYudMQG0i2wLvbkjZPDWGU6yLZ8U+EmMfMYn
	 tg6e5NOMU6EJxWqrgmC/1BOm0A0lFBVjZ36sWKI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/843] drm/tidss: Drop extra drm_mode_config_reset() call
Date: Tue, 21 Jul 2026 17:17:32 +0200
Message-ID: <20260721152410.898916638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f468fef38716f667e805e0fa2c497c6b9c325bb9 ]

We are calling drm_mode_config_reset() twice at probe time. There's no
reason for this and the second call can be removed, reducing work at
probe time slightly.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260311-tidss-minor-fixes-v2-1-cb4479784458@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_kms.c b/drivers/gpu/drm/tidss/tidss_kms.c
index cb0ab224282f38..06c37386fc9a10 100644
--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -275,8 +275,6 @@ int tidss_modeset_init(struct tidss_device *tidss)
 	if (ret)
 		return ret;
 
-	drm_mode_config_reset(ddev);
-
 	dev_dbg(tidss->dev, "%s done\n", __func__);
 
 	return 0;
-- 
2.53.0



