Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A85332EAE;
	Sat, 12 Sep 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224844; cv=none; b=a7bKMv+OTgMlcSQkLYSMUAIu6t6t7EccOFQQZvFGbDDPkDvI49usQ9XFYW+PshUM+woasFHQ60k7MxKAVOORCzrJdNzEhnKkQXIJ7ruppPgKr5Cvcr5nkivJXkmhxTbDPPyoq+OuO1Xz8dKPtRFE4dZuT53olAJNa3fKeXN/hFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224844; c=relaxed/simple;
	bh=t4zePGGcPJuHkqcKvwEDbTrNqbyIOOGDwlcQtXX1Wcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTVd8ZMpABqvgUYb6Sj81njZJN3keSrW0jiUpJSqGh7vtMAcZPorwFfb0pE6hsx4bS+riq7+jkJlu9OCD5DfPmmrYft0kMg0KxSGjY3w06aSWzeUmdj1hyan7NZm0IhvBDoqn27jvB2kPZCGgJF3LTb/5CI52Oq+Io5ecHDK9nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSucdJ7s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSucdJ7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF361F000FF;
	Sat, 12 Sep 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224842;
	bh=BM3L66jbtodrCQHIEdUnqftDN8Y252eaSEj/6eVptGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSucdJ7sX9IymuF2YDHkolEfNDvNPhEw77VxSMStSQ0BQgzq/BLiKjvXqpIQOxpzg
	 Qhsbab02n5M9UtByIBQNQloXD4kqcdKtHiEAorY0aswcheSn+tDeuUvgTUkhMtb/uF
	 eQq8C4X2YmoQOHUpyfEwh0O5+rIdFx8aE1D3cZbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1075/1424] drm/sun4i: tcon: Drop remote endpoint reference
Date: Sat, 12 Sep 2026 08:58:27 +0200
Message-ID: <20260912065631.377384474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 901e84de5aef9..ab4409dcbf302 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -972,6 +972,7 @@ static int sun4i_tcon_of_get_id_from_port(struct device_node *port)
 			continue;
 
 		ret = of_property_read_u32(remote, "reg", &reg);
+		of_node_put(remote);
 		if (ret)
 			continue;
 
-- 
2.53.0



