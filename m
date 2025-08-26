Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AD929BDB6;
	Tue, 26 Aug 2025 13:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214638; cv=none; b=s2BM3k7oEQo+mBpySOAyEZ2VpTdf00+PDSNyQMo9Akfa7fz4nlXOhQdwKDAXiPkYZnWp39tVR5yQAI5sj6HuIpKZEARwp2ct6a+JGkibj+gMjmowZr6sC7KwnjWLCfSOujMMv1wEhsRwgXvBe5UDx/SLrHYBr2XMvDbe1Gp0MXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214638; c=relaxed/simple;
	bh=QNiDTCbGtTN5rXLTInfidh6NkY4KWxCA+/5ocNws2OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3RoiiDpInwG3XRyF1UN0qDgKd/DZXixlA+k9w2PVFUOYc77WpwxBEDLjX96cA/ErzvQ5F5YbBGdvGvot/hsu3TOV5hAUTwcQTUhGG/4bfbteX8xjjPO202sN4PfXot+G/+u0JvipDd0sIrIa2GKCAhRZE5FFo2z/+fWcapYHBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4XJZlax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4XJZlax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF4CC4CEF1;
	Tue, 26 Aug 2025 13:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214638;
	bh=QNiDTCbGtTN5rXLTInfidh6NkY4KWxCA+/5ocNws2OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4XJZlaxtRgNf++cwc4AryJbsMcw/eIjIJLw0AFntR2ZDhIMSMJNwsqLFF5ke39Be
	 VuCGGTdT0gR25BAhp7l4KtFUzVD/xcXd0cbOTRDj+2epGt0YfOT8qPR6ytSLw3N5cs
	 0lWFTW18ateY20h/t8cUVt5ZPXLszeAqo9XoxyZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/482] i3c: dont fail if GETHDRCAP is unsupported
Date: Tue, 26 Aug 2025 13:07:45 +0200
Message-ID: <20250826110936.015576089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 447270cdb41b1c8c3621bb14b93a6749f942556e ]

'I3C_BCR_HDR_CAP' is still spec v1.0 and has been renamed to 'advanced
capabilities' in v1.1 onwards. The ST pressure sensor LPS22DF does not
have HDR, but has the 'advanced cap' bit set. The core still wants to
get additional information using the CCC 'GETHDRCAP' (or GETCAPS in v1.1
onwards). Not all controllers support this CCC and will notify the upper
layers about it. For instantiating the device, we can ignore this
unsupported CCC as standard communication will work. Without this patch,
the device will not be instantiated at all.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250704204524.6124-1-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 18103c1e8d76..513c79e26d9a 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1386,7 +1386,7 @@ static int i3c_master_retrieve_dev_info(struct i3c_dev_desc *dev)
 
 	if (dev->info.bcr & I3C_BCR_HDR_CAP) {
 		ret = i3c_master_gethdrcap_locked(master, &dev->info);
-		if (ret)
+		if (ret && ret != -ENOTSUPP)
 			return ret;
 	}
 
-- 
2.39.5



