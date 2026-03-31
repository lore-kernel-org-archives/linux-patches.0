Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2607B402BA9;
	Tue, 31 Mar 2026 16:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974887; cv=none; b=O4yOPb+imZ4DmqpvAQ1co8NuoYVdrTNEaKp7LUxNhT6tSsXlIGlH6iNBMqusfjflZOkpAxdzPRFTM4ULnJWGjKUNd0PjXeAhCNkDKf3N4OO8bXgfR30a6ca95dsUajmUYk7cTZzwy7KOLmI0txnq3vJgr2jhwuEpnGltWlv9Gy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974887; c=relaxed/simple;
	bh=BJBxyLU9C+gEphDjt9UsMs7M79Y7r7B1HT2En9OVhSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5o7qAZBvwexLKk9N1eEQqIUcvdPr9rQyuHp+6Vo7/7bVjxkEDINCmYq1eAu8w1CUGtMXPflAM2O3xoqSeeknNIPx4kMcehqi7KXL1xJ0wMqei5HmK4kuwxOCp3/T+jLboclJTQkdcPNiVYZ9YK2/uQppCnkbbTFgb0f3gwB2To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9tO9Ewd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9tO9Ewd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9749BC19423;
	Tue, 31 Mar 2026 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974886;
	bh=BJBxyLU9C+gEphDjt9UsMs7M79Y7r7B1HT2En9OVhSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9tO9EwdVlUGrGJMvD6azsuBPO30QtsDLLV8Wi8vIXc7EK+cSg8O71G7TVzpQNEI2
	 RfDRcV8yEOHAiLy92+sIFG9B5kL+2lyz/0QYxRToItXt99616lD0D2Hd7nXbnokOJa
	 Jy7cbsjV+PUGu5PEG6py59Ne5u/1xZDthfK6P35s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 082/342] pinctrl: renesas: rzt2h: Fix device node leak in rzt2h_gpio_register()
Date: Tue, 31 Mar 2026 18:18:35 +0200
Message-ID: <20260331161802.042887363@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit e825c79ef914bd55cf7c2476ddcfb2738eb689c3 ]

When calling of_parse_phandle_with_fixed_args(), the caller is
responsible for calling of_node_put() to release the device node
reference.

In rzt2h_gpio_register(), the driver fails to call of_node_put() to
release the reference in of_args.np, which causes a memory leak.

Add the missing of_node_put() call to fix the leak.

Fixes: 34d4d093077a ("pinctrl: renesas: Add support for RZ/T2H")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260127-rzt2h-v1-1-86472e7421b8@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzt2h.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzt2h.c b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
index 40df706210119..24b90c80f5131 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzt2h.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
@@ -648,6 +648,7 @@ static int rzt2h_gpio_register(struct rzt2h_pinctrl *pctrl)
 	if (ret)
 		return dev_err_probe(dev, ret, "Unable to parse gpio-ranges\n");
 
+	of_node_put(of_args.np);
 	if (of_args.args[0] != 0 || of_args.args[1] != 0 ||
 	    of_args.args[2] != pctrl->data->n_port_pins)
 		return dev_err_probe(dev, -EINVAL,
-- 
2.51.0



