Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FED013C9C4;
	Wed,  5 Feb 2025 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763518; cv=none; b=BW7vjMUvtcfqYmtYQcU+oEIzLZqW8RqvMY5aNBfimFtXkiEA3F8kREvFPww7Ik/AFqvDASST5tBcc1MUah1G5+E00PJdEd/CJhkGfJNhjXvqYzdAe8nRYXnnJQVYM28+jA/p/JW+5QfEyk5hJJkq2qafdNKUy24Lvf895IoZmxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763518; c=relaxed/simple;
	bh=zg2srEBM+hXIEwlllUMPQu9M6dOmwPdE4LXg+eeCiyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WU0vEwFh+q/JtbkleauUjFuyKTKsLQvtAPKu2WGrEb62VOcTEWVHU8dTUOEzQvBlEKT6WqGTIJkVLnqASc3WAM4kN69NuulbXLuM9ncMIHkblwAIh+NABKSUYdJAjDezFMEFFkZS56+PdAFJE0vbKLYldQJ1veU0LPY099BizWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpQ3WUM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpQ3WUM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA73C4CED1;
	Wed,  5 Feb 2025 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763517;
	bh=zg2srEBM+hXIEwlllUMPQu9M6dOmwPdE4LXg+eeCiyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpQ3WUM8i9MsQoq3OHFtzF+EdR8ER0UcFA5avrAEXl7b2Mz973zacotnyTaPeQdfr
	 itTtAC1jwmmczcfFq0pG/29MzyeCJaJPkbCPW9Y9ghqdjeoEAyKK0J1OakBrcK3qOP
	 34nCg21CuAaqwTxLFj4/rDBELYLfDArTn4NAPUQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/393] leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_pdata()
Date: Wed,  5 Feb 2025 14:39:55 +0100
Message-ID: <20250205134423.201228539@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 0508316be63bb735f59bdc8fe4527cadb62210ca ]

netxbig_leds_get_of_pdata() does not release the OF node obtained by
of_parse_phandle() when of_find_device_by_node() fails. Add an
of_node_put() call to fix the leak.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 9af512e81964 ("leds: netxbig: Convert to use GPIO descriptors")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/20241216074923.628509-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-netxbig.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index 77213b79f84d9..6692de0af68f1 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -440,6 +440,7 @@ static int netxbig_leds_get_of_pdata(struct device *dev,
 	}
 	gpio_ext_pdev = of_find_device_by_node(gpio_ext_np);
 	if (!gpio_ext_pdev) {
+		of_node_put(gpio_ext_np);
 		dev_err(dev, "Failed to find platform device for gpio-ext\n");
 		return -ENODEV;
 	}
-- 
2.39.5



