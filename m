Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE8C78C9C;
	Sat, 12 Sep 2026 19:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243062; cv=none; b=ImtmKFYcICGCi3DK7CcMJKo8kmuUGmqWcPMHpRftBva4XUf/LVMnLIeOHa0Odtirm9kUxSEhSJKwmZf48PGtM4f/IOAFEkX/RjD//SF7taoSdm089yrTkdZfCM7Gxgg7lL8fGrwFIi8pUjhQtDoPYLGfGytUhTgjXXAVV8C5Ej0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243062; c=relaxed/simple;
	bh=AyHM10NSBzINcfdX8nFCvese451auwSl0Uub1m2/tso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDJWRTR5JfngSYcNSxcvzZdrrw7W9153YdsG18Y4bXyeyi8hs9i53iqqpnKaOT7CSovSvKrSlPsM3lU1Y+vaOQSV8SuQOwiiUBXZfcUISDsyaQais81Mm6GCxynziTwJMW2gJgFociNXS5QxrPMTxlwtfQbV0qhgsIDzMcsMIS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9HpG2kP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9HpG2kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1941F000FF;
	Sat, 12 Sep 2026 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243060;
	bh=ln0276NLsGJmh2OaA6MT/oI/6Jmx5dYFV+94KQDy76g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9HpG2kPKt8EbsUgWXE6Wu5YoQ19ntmywJWJroG5zjcDNuNX65QfFc4ass3CPge0q
	 E2sI62QxHA4E0gR+upqFXVadnLUQDM8gLx8L/Y3pmJNSykX9BhnvgL3Qy7Q14eFYuq
	 Ci7Fr0hZQxJApEpT6+CyZrUGyz4sYMsKRb5KWBYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 623/798] drm/sun4i: tcon: Drop remote endpoint reference
Date: Sat, 12 Sep 2026 09:04:11 +0200
Message-ID: <20260912065531.400114093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



