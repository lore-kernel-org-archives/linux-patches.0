Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A161B6D08;
	Mon, 29 Dec 2025 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025515; cv=none; b=B49CBL66cLY4hfwQszu64ZB3DWPMVtwLUhYXTymLld+/a8iIlicnjxb+I5p+XAxpdvAny8WqWq9pIk+2NbzBo1nGgcEXZRn3AQM1E06dD6Ep+M5eDXrsLB+1rEAp6LNg/+EjCSc73ve6yHSsDaIO1/SUM8aT34iPHBCmZ50TKpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025515; c=relaxed/simple;
	bh=vJHf1559DCgqP0SFzRg5wp+Cfock54JLl184doyW8VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfJYohMZisWK3Nof74BqoZNYPtvOT/AyEHqWtxeq5MXwcENllz118mWArtkS/kmPq1qwkWvY0ugpHdgYvllzbeZGBCFR2D/94STHZIXgx3d39onAYbcjNMaMrtII/eUSxYxpcGHSttEz36Mt/e6t8ejNM4yjd9cHNVF4g3s2dIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGT/MNkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGT/MNkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7D5C4CEF7;
	Mon, 29 Dec 2025 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025514;
	bh=vJHf1559DCgqP0SFzRg5wp+Cfock54JLl184doyW8VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGT/MNkIIIuRdStvcARjyaPDj+rR2vaKJ6dbmgdiZSur4E/dy1EZuZzZDJ8sJgDqw
	 dIWWY9tBtYegFV2L7YrrHMGwdCczuheqvHBUnCfKet8H8PPOZj9O1/YKdSnxl39NXX
	 Cziz9RKmRAEn6d9uOkbXIC39zOKUCCKbsj874ZmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/430] hwmon: (emc2305) fix device node refcount leak in error path
Date: Mon, 29 Dec 2025 17:10:10 +0100
Message-ID: <20251229160732.008157800@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 4910da6b36b122db50a27fabf6ab7f8611b60bf8 ]

The for_each_child_of_node() macro automatically manages device node
reference counts during normal iteration. However, when breaking out
of the loop early with return, the current iteration's node is not
automatically released, leading to a reference count leak.

Fix this by adding of_node_put(child) before returning from the loop
when emc2305_set_single_tz() fails.

This issue could lead to memory leaks over multiple probe cycles.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/tencent_5CDC08544C901D5ECA270573D5AEE3117108@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc2305.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/emc2305.c b/drivers/hwmon/emc2305.c
index 60809289f816..84cb9b72cb6c 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -685,8 +685,10 @@ static int emc2305_probe(struct i2c_client *client)
 			i = 0;
 			for_each_child_of_node(dev->of_node, child) {
 				ret = emc2305_set_single_tz(dev, child, i);
-				if (ret != 0)
+				if (ret != 0) {
+					of_node_put(child);
 					return ret;
+				}
 				i++;
 			}
 		} else {
-- 
2.51.0



