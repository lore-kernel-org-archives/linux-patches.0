Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD611FDA6D;
	Wed,  5 Feb 2025 14:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766928; cv=none; b=eTC3mcvJ18G5avZ1OD0+ddDX3FX69GnVO9PjtdoAw29zPzO2tVYjkxv1Ydd52Jxts8UbvneLmLN5derxUuUWfqUSdk61RKbjRIYKp9BJJSDgAfN4beZevPEUqyTQjICHfAx7MPW+5sUlbqXN65kguUikMFXQDvF+XfuK38L4x0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766928; c=relaxed/simple;
	bh=Es8TYW47Ym2Na4nxQ5jOVO+m8mQv/hdTRu4NGgBmYmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muJtFlpXdFCgS/T9Yi1t3MMEzr8YdaWpUhFrD28ukRdYEZzgHq+aP8krKdHFKw6zvJMkiEuH37zrxGYPV8iINDdAazbKyRngTMJ6x8heKkuqlxSDq+0imlJbW/e/o3KETo33CuVMA/i8HXPGv3bDg088orE9K5f942kXyy8xY+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQjZOiNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQjZOiNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78248C4CEDD;
	Wed,  5 Feb 2025 14:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766928;
	bh=Es8TYW47Ym2Na4nxQ5jOVO+m8mQv/hdTRu4NGgBmYmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQjZOiNbmTyrrEgKiJTv4JgBtWPU66TbQdkRQ5bR9E/T+28Z2uYXb567AlMRF94Fw
	 OUE85XFO6t2jSPjcg/4sYzD9S+WRJwXO+66DNTgbMo0cD06ZnymzEk8v9FM77jH2VZ
	 eM6VP46RdimnlLToXFll6H2pR7m+R1k5+kCbCU7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 330/623] soc: atmel: fix device_node release in atmel_soc_device_init()
Date: Wed,  5 Feb 2025 14:41:12 +0100
Message-ID: <20250205134508.848383180@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d3455ab798100f40af77123e7c2443ec979c546b ]

A device_node acquired via of_find_node_by_path() requires explicit
calls to of_node_put() when it is no longer needed to avoid leaking the
resource.

Instead of adding the missing calls to of_node_put() in all execution
paths, use the cleanup attribute for 'np' by means of the __free()
macro, which automatically calls of_node_put() when the variable goes
out of scope.

Fixes: 960ddf70cc11 ("drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241031-soc-atmel-soc-cleanup-v2-1-73f2d235fd98@gmail.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/atmel/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/atmel/soc.c b/drivers/soc/atmel/soc.c
index 2a42b28931c96..298b542dd1c06 100644
--- a/drivers/soc/atmel/soc.c
+++ b/drivers/soc/atmel/soc.c
@@ -399,7 +399,7 @@ static const struct of_device_id at91_soc_allowed_list[] __initconst = {
 
 static int __init atmel_soc_device_init(void)
 {
-	struct device_node *np = of_find_node_by_path("/");
+	struct device_node *np __free(device_node) = of_find_node_by_path("/");
 
 	if (!of_match_node(at91_soc_allowed_list, np))
 		return 0;
-- 
2.39.5



