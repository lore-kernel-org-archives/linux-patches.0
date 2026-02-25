Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4252A242D9B;
	Wed, 25 Feb 2026 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982831; cv=none; b=h/6PGfAGe1aV2ZYLIb46eH3hGS8vdL3k4cbIscj9wQmXph3pz4Q2YWfFvJTZ8lPHRM/CLkpMKQTmTzyusrRkuagrs+Z3mPi328q0A1O7JUig9NcfHiOv43sQEjqvaD5zrva/Tq2fyel+2tezOXHqZgfulYWOOy2mreWMr9Ak+gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982831; c=relaxed/simple;
	bh=5s/o2zL5tJYEPEL0Rlto7Ij6dzOofSLDHXqPr/Q1YFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKvaHKeSNpVoXxUfPqJkjinXHGysJg9WclQjO+VoNxKwc/bnc2Pg3rx1gEAg11FKFC5qjRXmqtGMoa3WRXCb9fCflLAf3Mn/teEiRwGokEohT+7BHmpGPJERvaEb4xG4i0/i7KC5l0M9UYnbY+RgaqKg1iE2S9aR7XMk7S5VH/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n95gbKDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n95gbKDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0EAC116D0;
	Wed, 25 Feb 2026 01:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982831;
	bh=5s/o2zL5tJYEPEL0Rlto7Ij6dzOofSLDHXqPr/Q1YFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n95gbKDD+jmqZDIVo3EDbO7bID7iKVQ2gXQvEREij0CXlYFa5OEnx5QWFAicc4hzM
	 Qfp93UBgzkkTY1oyoE+uqAH/IG75Qw6b9batvSC26RmVTqFII8xNuJmubTuK84DDvh
	 xdKC476XD8uUJdTVktkA08GWfnTFQhTCBG0I3lVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 009/781] i3c: Move device name assignment after i3c_bus_init
Date: Tue, 24 Feb 2026 17:11:58 -0800
Message-ID: <20260225012359.925747326@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 3502cea99c7ceb331458cbd34ef6792c83144687 ]

Move device name initialization to occur after i3c_bus_init()
so that i3cbus->id is guaranteed to be assigned before it is used.

Fixes: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260112-upstream_i3c_fix-v1-1-cbbf2cb71809@aspeedtech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 7f606c8716480..1bc3c90684028 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2881,7 +2881,6 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
 	device_initialize(&master->dev);
-	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
 	master->dev.dma_mask = parent->dma_mask;
 	master->dev.coherent_dma_mask = parent->coherent_dma_mask;
@@ -2891,6 +2890,8 @@ int i3c_master_register(struct i3c_master_controller *master,
 	if (ret)
 		goto err_put_dev;
 
+	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
+
 	ret = of_populate_i3c_bus(master);
 	if (ret)
 		goto err_put_dev;
-- 
2.51.0



