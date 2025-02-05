Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6D01519BF;
	Wed,  5 Feb 2025 14:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767359; cv=none; b=L6+O05ATcrdjV3wCDYCoHT6ijcKEXPjmJD6eymsuSxl/U6lFwNhPv2CceHCz9/EvQ2PbXxLKNn2F2JLQLfS0hhPHX82WfnaGxseIJbOTM8xhLhjElf/sLdCOHpL88Q2dX8az8U7lHNtTKEZqgSV4Z9/LAHcEc5sP8FubcQk9ml4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767359; c=relaxed/simple;
	bh=8O2BGOf+sz8ABVWIfTYVTfc6aMNSQj0KgN7IiJItq4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9x/tTV7+NJjdWfNwLGYs9gIjNBKNpUBPnNNQvvdl4nloIpopkfbbMQzYQc1XR3GuJssZ1MlUIOL4yUHcVnBEbNpGPWZa0j2sgH+3H6gvf/4DlfBMsmFCwFY78cAEsbo7oVGduLvhs1fc1yKOVrEBhXIdaZsBgYxFJV5TtZw6yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6NONmxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6NONmxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F0AC4CED1;
	Wed,  5 Feb 2025 14:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767359;
	bh=8O2BGOf+sz8ABVWIfTYVTfc6aMNSQj0KgN7IiJItq4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6NONmxrUS9Bx3PUomx43bzfwRYF/28gbxWG5Xekx8V01jJxmYrUhPfOz2yeX8aXE
	 EX9/NTT94rLajpG3FrahZ9jyfVnHzAD+ZKUTN4Yr5frYse/gNSESuXNyGR+lyZ1gBg
	 Vi9AbLJsrWXd21L/LyjHo0PxtFLtc4AygsCLv/XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 421/590] watchdog: rti_wdt: Fix an OF node leak in rti_wdt_probe()
Date: Wed,  5 Feb 2025 14:42:56 +0100
Message-ID: <20250205134511.373722070@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 143981aa63f33d469a55a55fd9fb81cd90109672 ]

rti_wdt_probe() does not release the OF node reference obtained by
of_parse_phandle(). Add a of_node_put() call.

This was found by an experimental verification tool that I am
developing. Due to the lack of the actual device, no runtime test was
able to be performed.

Fixes: f20ca595ae23 ("watchdog:rit_wdt: Add support for WDIOF_CARDRESET")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250105111718.4184192-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rti_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/rti_wdt.c b/drivers/watchdog/rti_wdt.c
index 563d842014dfb..cc239251e1938 100644
--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -301,6 +301,7 @@ static int rti_wdt_probe(struct platform_device *pdev)
 	node = of_parse_phandle(pdev->dev.of_node, "memory-region", 0);
 	if (node) {
 		ret = of_address_to_resource(node, 0, &res);
+		of_node_put(node);
 		if (ret) {
 			dev_err(dev, "No memory address assigned to the region.\n");
 			goto err_iomap;
-- 
2.39.5



