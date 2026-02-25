Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111881E2834;
	Wed, 25 Feb 2026 01:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983714; cv=none; b=kbYNs+lw8n5yS2Uf/7dqv7/z6amBJhZ8A5DvxmxUpNdqMJjt8kH2JeWetcplNmBgTz9rs0TX6WMRKMUZZJ28Pc+04ntj9axa/8yhEuzuVcRylnra14SOQM8Pg/BLkMJ9pSjdn1pzOAWX88mtOvlH6IujElQQfsKUXRGPV/h7RC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983714; c=relaxed/simple;
	bh=Ibp3cLrBtCZb0HCPfd8LhvNiQX+W6XMi4l918L/pO+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5dc8qlEzevmfvLI/k7LPPWalaGXW5TWr5/jYamrGdnlZEqADqiY81G9G24AhB77uiVFmmZdvlH9sGh/JVUs5zgxban9pek5galGTpUsXknsCO9Oly685v2wHhk1V+kfsqmEb2h/0oxTMOeZYrHODPnGUXjnZpSA0Dx9qhP0uBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hZg4xb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hZg4xb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF15AC116D0;
	Wed, 25 Feb 2026 01:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983714;
	bh=Ibp3cLrBtCZb0HCPfd8LhvNiQX+W6XMi4l918L/pO+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hZg4xb+b4BG/9QnOq9FCsjMd+xa2T2/+cFEfkOy1SLTvfF8TPKBye6Rr9kYddRUm
	 oj+fB21GK1orBDFR9VP2/HCMYMqShpiG+dkOLV96U7bCU4zsYdLvcwcgX13j3gdBQH
	 APtIsfcx7V/V3cEVZ3BPPiaAccoa39dkKB8P+js4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/641] i3c: master: Update hot-join flag only on success
Date: Tue, 24 Feb 2026 17:15:38 -0800
Message-ID: <20260225012349.240934403@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit f0775157b9f9a28ae3eabc8d05b0bc52e8056c80 ]

To prevent inconsistent state when an error occurs, ensure the hot-join
flag is updated only when enabling or disabling hot-join succeeds.

Fixes: 317bacf960a48 ("i3c: master: add enable(disable) hot join in sys entry")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index bc68a5e7455be..425e36b36009b 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -620,7 +620,8 @@ static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
 	else
 		ret = master->ops->disable_hotjoin(master);
 
-	master->hotjoin = enable;
+	if (!ret)
+		master->hotjoin = enable;
 
 	i3c_bus_normaluse_unlock(&master->bus);
 
-- 
2.51.0



