Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D043F26B0B4;
	Thu, 13 Feb 2025 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460518; cv=none; b=uDwzfKYkMhEQN1t35JWpVcvLgBGdqqAPEA/r5ae8VL+o6q+eO7LrAwDF0qvF+U0BLg9tMGeU6ErAiKlh6B2TqXPs7DhyxP5GhHlIcrriUzT3QTVgkABWr3M/pQZDi3vzEOcP8iyJSDwZgzJHnCYvwoWalohHZuaQYEqSrVRTsoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460518; c=relaxed/simple;
	bh=Wne0UUeZOzmx3LAORvz+c0bZfqLeIQvdX+wxjk1O5KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uw7O8dIYFlgslssjDcXZPFDQWTE3sAMRQV2H+CradGfr4ToOQMkVgyL6Ex0tFnfLEvE6l23X71SMnUlShwA8ddPRd12lffOgpIrrO21wxlE/9KvYwIQBao0nFg83x5yIgTqc+2xRzNOZvXi26+/MAch45wejr5uRZU7xDoKuBE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAC6gLUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAC6gLUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5D7C4CEE5;
	Thu, 13 Feb 2025 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460518;
	bh=Wne0UUeZOzmx3LAORvz+c0bZfqLeIQvdX+wxjk1O5KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAC6gLUBooAC/kNHxfbL0+zQOZQPh4GbHlKSct5ozYIVf2S2CquCMrTUYqddVoqId
	 szlC/RTSB2TWKoL6JAcJMiEVsQkV6n88IKUjBvwCEL6GYpIMY86C9gjcaup2087Mr8
	 bM3QYNkyAH6R8QgHgpgPEKyb34t6a7YYz9K7zHfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.6 102/273] drm/komeda: Add check for komeda_get_layer_fourcc_list()
Date: Thu, 13 Feb 2025 15:27:54 +0100
Message-ID: <20250213142411.380126122@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -160,6 +160,10 @@ static int komeda_wb_connector_add(struc
 	formats = komeda_get_layer_fourcc_list(&mdev->fmt_tbl,
 					       kwb_conn->wb_layer->layer_type,
 					       &n_formats);
+	if (!formats) {
+		kfree(kwb_conn);
+		return -ENOMEM;
+	}
 
 	err = drm_writeback_connector_init(&kms->base, wb_conn,
 					   &komeda_wb_connector_funcs,


