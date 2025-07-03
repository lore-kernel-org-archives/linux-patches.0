Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0312C3262;
	Thu,  3 Jul 2025 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555623; cv=none; b=VaEaLRDXFDpklPiBkm2qMV48yXWUIaG3umeJEAX/p9wRFJKLjVoBCIkiwJ2ydU07faMIT3XDZzgJKmLkjLF3eeRqKCKHg5R2Uy1JvDg8hYzy1T/Sll2gETQ7BGI+3ZmgX6mlRs9FexNtKObzuzv6i4H/7d4iiupkjm7fg1WOsoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555623; c=relaxed/simple;
	bh=B7YRNkfNWFVlXPAgUVmZvEkmojZh1IT6jU624HeQf3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVnW8eRt5SC5/I0o6fsxo3WryZGBEFsNODuOa+xfT9eRtIkq9X33yQEYN13cKeRA57BdtVYMX5qBJo0um9scXnmNbm/1yjC+c+H6lW0WtwHgoMuQp96odA4nRhH1xk2PwQS7rqs7IOAXSllkjkEzvmQdXQUQKOyKwwnah/QFIWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmJHOQDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmJHOQDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD708C4CEE3;
	Thu,  3 Jul 2025 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555623;
	bh=B7YRNkfNWFVlXPAgUVmZvEkmojZh1IT6jU624HeQf3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmJHOQDqVyAe3mFIfNyPBzaA3tILB+GV2POb6z1SUYAITvPXyvWJBoFXT+VUKjhho
	 wV8o6IeWoQyazAbUOAxfbxIxYP07smQcFPYV3lReebRUhFIiCzu0ale9h7srEj/0Vw
	 AAHYUeQxCDRRcGQ4NdaMF5Q2IL3l6PP4Fa1jcoSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/139] misc: tps6594-pfsm: Add NULL pointer check in tps6594_pfsm_probe()
Date: Thu,  3 Jul 2025 16:41:35 +0200
Message-ID: <20250703143942.440136535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit a99b598d836c9c6411110c70a2da134c78d96e67 ]

The returned value, pfsm->miscdev.name, from devm_kasprintf()
could be NULL.
A pointer check is added to prevent potential NULL pointer dereference.
This is similar to the fix in commit 3027e7b15b02
("ice: Fix some null pointer dereference issues in ice_ptp.c").

This issue is found by our static analysis tool.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250311010511.1028269-1-chenyuan0y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/tps6594-pfsm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/tps6594-pfsm.c b/drivers/misc/tps6594-pfsm.c
index 88dcac8148922..71fbe31542e56 100644
--- a/drivers/misc/tps6594-pfsm.c
+++ b/drivers/misc/tps6594-pfsm.c
@@ -260,6 +260,9 @@ static int tps6594_pfsm_probe(struct platform_device *pdev)
 	pfsm->miscdev.minor = MISC_DYNAMIC_MINOR;
 	pfsm->miscdev.name = devm_kasprintf(dev, GFP_KERNEL, "pfsm-%ld-0x%02x",
 					    tps->chip_id, tps->reg);
+	if (!pfsm->miscdev.name)
+		return -ENOMEM;
+
 	pfsm->miscdev.fops = &tps6594_pfsm_fops;
 	pfsm->miscdev.parent = dev->parent;
 
-- 
2.39.5



