Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A570A49218C;
	Sat, 12 Sep 2026 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239696; cv=none; b=NqyCWmNKZW3sf54tHR7m5cykTTGAAZS0YEnKwaVFqCZN2+htZDfWnNNsoyiF5DaMORiW2TsnjsInKzhhQkbDZj1Sf4pQK1OvOjwZ0gfBXEbW+VVQvvo/xaxoWPxFQQe/giWSQ7ej87hAsOagMq8a9CLMOw9cNfCHKpI0a3u541o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239696; c=relaxed/simple;
	bh=23TQm3nhPaRoZ6mXOOcAWum7Ogd1Ahv4l+o1wRDaDTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7HfcqT0OG8OIVNQrGklrD5YqtUln1VSPtJI9BxtvojYrnN9kVfGn3oHbbwfna+XukkYNSnZFo2ZQ5I9CR4TmDEfm+psBJb8WbVZHC/j3ClFT7oD3d9uHgfcvPsu5wWbre9XUe7HSq/AcV/4ofPlmTM3cdIrUjr4rFagQ7jOVRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWkqeekY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWkqeekY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A4D1F000FF;
	Sat, 12 Sep 2026 19:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239692;
	bh=QaSFF8YeExyw7oJ4IeJFly8zPoyhW7/AVQCCF+UKV9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWkqeekYFTACkumx1cB/+PFqtqmTVkX4qOMaKKzehXgbOB645TzSWG4fi0dYamcrb
	 sdu/ivnr7iFiZIXqLdcM0F+TaUHI2c/tZ3Eu7W8aFo05fi+Ekno38fcmsKDfX6n4yi
	 iFvpHO72LDYb/Ze8djq/0xjHUr6vCmT0hrkiJmNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 714/935] drm/sun4i: tcon: Drop remote endpoint reference
Date: Sat, 12 Sep 2026 09:02:24 +0200
Message-ID: <20260912065543.210314600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 3f77e4072630e2301efdbe521e7fca10311043ec ]

sun4i_tcon_of_get_id_from_port() never drops the reference taken by
of_graph_get_remote_endpoint(). The function is not only called during
bind, but also on every mode set through sun8i_r40_tcon_tv_set_mux(),
so the leak accumulates.

Fixes: e8d5bbf7f4c4 ("drm/sun4i: tcon: get TCON ID and matching engine with remote endpoint ID")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/3f5ec952ad80cb51efebf2fe230df50259041a23.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 846085b3ee2dd..b30c6cbb610e7 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -965,6 +965,7 @@ static int sun4i_tcon_of_get_id_from_port(struct device_node *port)
 			continue;
 
 		ret = of_property_read_u32(remote, "reg", &reg);
+		of_node_put(remote);
 		if (ret)
 			continue;
 
-- 
2.53.0



