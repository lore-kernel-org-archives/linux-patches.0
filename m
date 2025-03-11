Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C347325D8FF;
	Tue, 11 Mar 2025 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706383; cv=none; b=l3Isc8TuCqomkIPHFtnoZvj9FyA+FDyjkGuHiulUxjzJ2O6CL8JmxNzYhkk8QDtn06eOTn7L9/fyAbaiJxMU/ANlSajkMuqK4JtEOSfNcSeDzx3L5N1F05TjOTfNA6Cqzhytq491ECtbvtrCdvBqGpXXLzmfGMpbfYnLNS4y3Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706383; c=relaxed/simple;
	bh=ffmAEfRxmeFo+XKH/yAR4uWIM9fkhQrne6ovEa0JrpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kej7XgXQ/JIn3aXmhHlPoFV8WaZs/65vyhbldm97p2NhbAnKLkFMFbExFTTef64SEuh7mtTlRldNM2eFhOBwHZFNNA8jFV/PRtdlwHavYEy/4/0+iyLHXmxN9P/8fvo9H4dyk1HgW+zkC7Ie/wqAtlhFSfuXmpPKhZJcnfZavMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkTbtTdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkTbtTdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E312C4CEE9;
	Tue, 11 Mar 2025 15:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706383;
	bh=ffmAEfRxmeFo+XKH/yAR4uWIM9fkhQrne6ovEa0JrpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkTbtTdj5PNQ+75h/TVkve3a1igu66P7yP22hAKdqIfX1Cagi/ReFRrR1yKClWxg8
	 gs4T2fas3QcbjI+gH1ZUxfTzxA+rXerhMPrZTc8qhhynRRr5zlMDTZUwZddBqohBVi
	 hBQd8LVxhlPHvxWe3tEpj2oFnqe1c/i4nwvW7kgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/462] leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_pdata()
Date: Tue, 11 Mar 2025 15:54:55 +0100
Message-ID: <20250311145759.504674889@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 68fbf0b66fadd..c2cc45e19c4b2 100644
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



