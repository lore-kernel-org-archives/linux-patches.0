Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB01227E9B;
	Mon,  2 Jun 2025 14:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874840; cv=none; b=mMHOz/O0XsEHAK0Yz4ye0proa+hOevWDk/uMJSA8tQBLBGMQD1RK6PnqrPlZpFXSuCB3L+iB5BfxHRIyZ5vo9Dr5/pEzjspK62AflPos/HKZBL3hR13RgUcAxtRJHjngqFRurnzFZ8ALYcPlK4hX+kcN3ob0bmJw+iNQ5Wd8JHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874840; c=relaxed/simple;
	bh=8U7ocd3ZVxduwDHstB9+54pXkMBgiZ+4FZq711ZkVOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0H5c1RD/PuAHnUmbTVMgzCwxOTk849qeVtpD1t3Kq7wgwtGVZD8hIFjvIY0kvWEuQi+2jJGwNYg4sD4saUfdNRt+M/P138QUyQlPdXbT5uHsF0ApGZaZQAOBHm7PFkP1ifIo7OGl3ZhuHe3bHb0jRKmZ4HY1HBp9r6DIlGMtK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ji2tIZ+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ji2tIZ+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35E4C4CEEE;
	Mon,  2 Jun 2025 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874840;
	bh=8U7ocd3ZVxduwDHstB9+54pXkMBgiZ+4FZq711ZkVOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ji2tIZ+2Dr9WdbHsbyQiXX1VPYKscIoD7frus1nFX9lHAtrTdkM3NNbU7aKC8JnJA
	 KxRjhybAZVYznTDEfpB4Q8ldUirxuBF3zDdgxqgF2QVvurpO/FscBFj7NFxCnzEZQK
	 1E+lOT1sAzgTgfW0qyQGBZTVKkKF680PrPLZA32A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 153/204] hwmon: (xgene-hwmon) use appropriate type for the latency value
Date: Mon,  2 Jun 2025 15:48:06 +0200
Message-ID: <20250602134301.661346584@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit 8df0f002827e18632dcd986f7546c1abf1953a6f ]

The expression PCC_NUM_RETRIES * pcc_chan->latency is currently being
evaluated using 32-bit arithmetic.

Since a value of type 'u64' is used to store the eventual result,
and this result is later sent to the function usecs_to_jiffies with
input parameter unsigned int, the current data type is too wide to
store the value of ctx->usecs_lat.

Change the data type of "usecs_lat" to a more suitable (narrower) type.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Link: https://lore.kernel.org/r/20250204095400.95013-1-a.vatoropin@crpt.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index 559a73bab51e8..15889bcc85875 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -110,7 +110,7 @@ struct xgene_hwmon_dev {
 
 	phys_addr_t		comm_base_addr;
 	void			*pcc_comm_addr;
-	u64			usecs_lat;
+	unsigned int		usecs_lat;
 };
 
 /*
-- 
2.39.5



