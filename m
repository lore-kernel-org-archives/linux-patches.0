Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A49A1FF5EC;
	Wed,  7 May 2025 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643992; cv=none; b=P+B3JlG8fPqp6g3hjX7egSwpm4jLwAW6RIL9RZrwz3UWtySGc8zI2t9el/euQmWGQI0dgORYJwG1/iKcfdm+VRkL37hsOqLrCxGOB5R4CDzvLpu3WtmSPDAGS34ArotMNFnmJGO0lpj31bI1ZHuqkX/liqeMA1YA3eroYUYrrnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643992; c=relaxed/simple;
	bh=62sgjDuFORhnBSiv3adfWUEQPugu2Qm7W6dWxP39/a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzuYvFMYge1gFZItQIHq/+pTcwN/b8QYodZOLMwFUWLQvuoDGXCBbIT56W3nUe1es/jep+aqCrJ5SvH3/b9SgVfDriJcSeyadlT4wqKDNRXTSd7tjtFfA4w3hUNfRuffWOaUMLRTXH7A8vAFtlt/8DKwCAoymX0eBwKp5vP2lVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHd3RHJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHd3RHJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19935C4CEE2;
	Wed,  7 May 2025 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643992;
	bh=62sgjDuFORhnBSiv3adfWUEQPugu2Qm7W6dWxP39/a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHd3RHJk65RuRSuOPb9dxBWP+1c/KPJzVRvZ9184Rineh2CSadZL56lW5Gbh/c79x
	 WiHU3xMZn6qwlqJKSJ8NyORj4peeQePbUNu6a/5OlkSNQkM52ae+6OBf1xwe3nfQOk
	 OiFY7u3HYaN8V/xUFp0rL+L1JRWgojz0pK6tpRR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 055/183] pinctrl: imx: Return NULL if no group is matched and found
Date: Wed,  7 May 2025 20:38:20 +0200
Message-ID: <20250507183826.916207216@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit e64c0ff0d5d85791fbcd126ee558100a06a24a97 ]

Currently if no group is matched and found, this function will return
the last grp to the caller, this is not expected, it is supposed to
return NULL in this case.

Fixes: e566fc11ea76 ("pinctrl: imx: use generic pinctrl helpers for managing groups")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/20250327031600.99723-1-hui.wang@canonical.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-imx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx.c b/drivers/pinctrl/freescale/pinctrl-imx.c
index 842a1e6cbfc41..18de313285404 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx.c
@@ -37,16 +37,16 @@ static inline const struct group_desc *imx_pinctrl_find_group_by_name(
 				struct pinctrl_dev *pctldev,
 				const char *name)
 {
-	const struct group_desc *grp = NULL;
+	const struct group_desc *grp;
 	int i;
 
 	for (i = 0; i < pctldev->num_groups; i++) {
 		grp = pinctrl_generic_get_group(pctldev, i);
 		if (grp && !strcmp(grp->grp.name, name))
-			break;
+			return grp;
 	}
 
-	return grp;
+	return NULL;
 }
 
 static void imx_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
-- 
2.39.5



