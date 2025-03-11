Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E879F8632E;
	Tue, 11 Mar 2025 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705752; cv=none; b=VuoAIz8lSc5qMji1a/8Yk4+F7XetaFtl9jGe6AMIlhHDrKdEzxI0pcLdXt5Z31IrnrNFuHCf6YdjBqR6G/z1seBs/LQwL0K/XFjTQbXaBYVZjHOt+4pQoBd3WRkn7QcgJZq1BG/Id7yel5xCPb+c2JuolKkiOEe2oqLRpIMNjTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705752; c=relaxed/simple;
	bh=dB37TrhG258lkjFipD0a5UIGDfwpw84oI6Qav2q/qbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apnfwFyJm0YjEgmthxlsB4vcSb7eZxA0uQR0UPZ7CiObeTms9KoWrBXYHUu0MHnCtAmjSwQ55pKZuYHbamJ6cDOuGzsASl/2EDwn/yC3XK0r5ksAdU5m3j/bCSLsTMNGBpXaO2BIfnrAYvtIa5jJ9QILuTZ1X59xrsshH56pzyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUGqrkqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUGqrkqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F988C4CEE9;
	Tue, 11 Mar 2025 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705751;
	bh=dB37TrhG258lkjFipD0a5UIGDfwpw84oI6Qav2q/qbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUGqrkqL8X6BnKjLDuBGzF8a60xEzytRQVoh994asSDxD7iFp9x6ARHdOQhcBbyvg
	 Loows/ivkXaPxLEutrBBUenaH0HMgb8WyHnyBUQxCtjJ9mzfARJ8wC+FkhknEY4QN0
	 Q6wtUXt4JIdd/BBa0vzPRxHszC2A6GX5je/WyMD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 5.4 125/328] drm/komeda: Add check for komeda_get_layer_fourcc_list()
Date: Tue, 11 Mar 2025 15:58:15 +0100
Message-ID: <20250311145719.867265293@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 79fc672a092d93a7eac24fe20a571d4efd8fa5a4 upstream.

Add check for the return value of komeda_get_layer_fourcc_list()
to catch the potential exception.

Fixes: 5d51f6c0da1b ("drm/komeda: Add writeback support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20241219090256.146424-1-haoxiang_li2024@163.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
@@ -159,6 +159,10 @@ static int komeda_wb_connector_add(struc
 	formats = komeda_get_layer_fourcc_list(&mdev->fmt_tbl,
 					       kwb_conn->wb_layer->layer_type,
 					       &n_formats);
+	if (!formats) {
+		kfree(kwb_conn);
+		return -ENOMEM;
+	}
 
 	err = drm_writeback_connector_init(&kms->base, wb_conn,
 					   &komeda_wb_connector_funcs,


