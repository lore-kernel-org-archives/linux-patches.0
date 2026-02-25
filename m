Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EC52D248B;
	Wed, 25 Feb 2026 06:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002618; cv=none; b=MTXb9gigFAaYNinyz27wV3xWs6JmLcoxg22O3r5Xqtzz1I20er2fJcHdAWSgvoUbnvOAbLJ9et6Qr3aWELo7iszXL/JFZajgSLa7Y5xcREKUbJBNgqpIKx9V5fwYjKJDINbtKqwGurbUJK45liOVp6JQJ3vMeVRjR9JqdjP1LHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002618; c=relaxed/simple;
	bh=OcvkIayj6qyFSjWU3WCeRk8SCFnsWFVFzAGJKLE0+9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRIbge7hE348KYJJTwPeKRs/BMn9CpoF/QnkSdOD7B3olRUwZKXC9Fgc4lM9jvkt4/QwtxuU5VYfSXqJtQkFs0lee+XkqXUOt4LdaymXwleGHUMs4NvO55P851kLLguYKu84DyuVCfPSrHHUG9TNdqA72t+9uVcnR7rTlK+DbqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTisP8LD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTisP8LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8ABC116D0;
	Wed, 25 Feb 2026 06:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002618;
	bh=OcvkIayj6qyFSjWU3WCeRk8SCFnsWFVFzAGJKLE0+9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTisP8LDXsBWUxOJprxA3oeCLbqdwek/9lk74aPVf8L04ILOxEHW0wa4VG+Ip8lah
	 alSJweeNDRzyJbOtT+vLXO8t3MCsAd9Oyvq45CZekXjf9T46RxpMCIXP9uNDBf4ECx
	 L3JWwgf1eLDN9GBVbtNadxiU8seeJJLNgZ7DdVLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 372/641] mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()
Date: Tue, 24 Feb 2026 17:21:38 -0800
Message-ID: <20260225012357.619842976@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 980ce2b02dd06a4fdf5fee38b2e14becf9cf7b8b ]

The function mtd_parser_tplink_safeloader_parse() allocates buf via
mtd_parser_tplink_safeloader_read_table(). If the allocation for
parts[idx].name fails inside the loop, the code jumps to the err_free
label without freeing buf, leading to a memory leak.

Fix this by freeing the temporary buffer buf in the err_free label.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 00a3588084be ("mtd: parsers: add TP-Link SafeLoader partitions table parser")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/tplink_safeloader.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/parsers/tplink_safeloader.c b/drivers/mtd/parsers/tplink_safeloader.c
index e358a029dc70c..4fcaf92d22e4f 100644
--- a/drivers/mtd/parsers/tplink_safeloader.c
+++ b/drivers/mtd/parsers/tplink_safeloader.c
@@ -116,6 +116,7 @@ static int mtd_parser_tplink_safeloader_parse(struct mtd_info *mtd,
 	return idx;
 
 err_free:
+	kfree(buf);
 	for (idx -= 1; idx >= 0; idx--)
 		kfree(parts[idx].name);
 err_free_parts:
-- 
2.51.0



