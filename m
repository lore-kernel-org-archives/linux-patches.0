Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09660190498;
	Thu,  3 Jul 2025 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553970; cv=none; b=PjdpxiYYH0PPlXMd935TioqPOznLdG0U4visbK31BZUh3p3EhX1dE1cn6HDwmiDYnfsAS+Hk8RGs4D+GfqYRjf4WreCjG1qFCvb3/6zuHg1bKfln6/SY2j0+d/qOxPUQTTbHs+CF0SpCp7qLEB4HQhxQxCbVu3UELgS83dJ8rSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553970; c=relaxed/simple;
	bh=yiqT8a8cUMB1jn+jKINq1CddapWB4hAf1pjG7EmP0AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWFtBHMEqQ0mtJRiWQEUhYwlVlOh1eVL6gRWDC8tWoGCYTJlW32nzI2eJOc5A3pj+s1RCmIB6dYyWxJ4sCaNssC6vnoSyJQdJSSJd/3GTDwELp0GhdHelkO70u+lgvdc40T6hP+DnDtm6ntWD3VpMUFEsW5tH9uAX82/nUoKTlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jz2FNptH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jz2FNptH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D740C4CEE3;
	Thu,  3 Jul 2025 14:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553969;
	bh=yiqT8a8cUMB1jn+jKINq1CddapWB4hAf1pjG7EmP0AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz2FNptH60yLIS58DNY6jU1ovGSdRlX250jku/VPKGUS+gUbrpsfeRD3/OEp3taKk
	 ya0H5PUK7xcVUHnQIJVepaNdFss1/L7lvQhI0glFt0Zk+AIIYSZyYrleEfp8tEa44m
	 u1k/rH6W5CO3Suot+/TR0lYBJdW1jnbB7lrTfRdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/218] misc: tps6594-pfsm: Add NULL pointer check in tps6594_pfsm_probe()
Date: Thu,  3 Jul 2025 16:39:48 +0200
Message-ID: <20250703143957.547708072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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
index 9bcca1856bfee..db3d6a21a2122 100644
--- a/drivers/misc/tps6594-pfsm.c
+++ b/drivers/misc/tps6594-pfsm.c
@@ -281,6 +281,9 @@ static int tps6594_pfsm_probe(struct platform_device *pdev)
 	pfsm->miscdev.minor = MISC_DYNAMIC_MINOR;
 	pfsm->miscdev.name = devm_kasprintf(dev, GFP_KERNEL, "pfsm-%ld-0x%02x",
 					    tps->chip_id, tps->reg);
+	if (!pfsm->miscdev.name)
+		return -ENOMEM;
+
 	pfsm->miscdev.fops = &tps6594_pfsm_fops;
 	pfsm->miscdev.parent = dev->parent;
 	pfsm->chip_id = tps->chip_id;
-- 
2.39.5



