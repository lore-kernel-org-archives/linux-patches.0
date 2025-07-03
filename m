Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556AB2E7F1A;
	Thu,  3 Jul 2025 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554721; cv=none; b=uLMw/ylGsXeJ53585fCULNMXYuezxlmaLRuerZ5IN7X++CHDgRszIJ8/+dcuU4kr1CsJ2lNX2I+AT7sYv5RNXGLOPJRW0eKpMEbrTogFn0bhdKuFLS+6G90Bjg6CIlA2jh3rsYcO0t70nx1wlV1TWn5ENCDer/x1Ja1Oz+dPQY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554721; c=relaxed/simple;
	bh=hQBiNbQ3znnqDMQHdr05F4+5oO0ncKBpc6lYaRZOtHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhStDT2OfgN23I5C/ZFct0igX4NJxrdGT/j72XfoLEGvS+Qdk88zJqys7FnWATbs1x12y+xRQn1vKRYu0B7XxiDQSLf74obHIOF6qTYhU4a2ENlX5yiAHY43rHB53vFY4tpWVbla9A5OGkySa+b4Y0v87FNMZdDVKG9RU0MSm+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWAdgkeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWAdgkeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA448C4CEE3;
	Thu,  3 Jul 2025 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554721;
	bh=hQBiNbQ3znnqDMQHdr05F4+5oO0ncKBpc6lYaRZOtHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWAdgkeF2Ba8oSsWHaQQSDKry5uSiYehHAfS8x3bC+85GuXP+SSgjEc1T/jBw8aDJ
	 6KaISM5y/9ygNv4KzNu+z3RHHYuLauyQQyPKKJpLhsLXYcnHbX7tiOo/Kv8xsokG9G
	 gUDHHJJKzTwROKXNgI8n5DKZvm9WGn+2maPApMZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 056/263] misc: tps6594-pfsm: Add NULL pointer check in tps6594_pfsm_probe()
Date: Thu,  3 Jul 2025 16:39:36 +0200
Message-ID: <20250703144006.559881066@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a24ce44cc37c..6db1c9d48f8fc 100644
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



