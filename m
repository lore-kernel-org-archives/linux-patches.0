Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9911B222D4B;
	Thu, 12 Dec 2024 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023075; cv=none; b=OPXrYrcRUTD67cVx6DTUTbzszPo3ecf0ikumhlH4hvNz5GdZ6OA0352crY5wMWx5cl7tcbm6MzoCpie8fCC9rk2EMPCgIEZDaVRTRDQlfNCVYjH8Jn+pCthrL6/hYintL23/RjN+u8FVAZ8jJeWPvaBZPZyBlIQTj+EAtk8xIKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023075; c=relaxed/simple;
	bh=02wX2kPWbcLVzyF9k3tVNF67Qh5olNc1Ekbz8S5ZH58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t41i5e4JR0FL80fS7EtcnT3efeD8j2XJgCQnX+6rw0W+ccva3i1duPgEkbCIm5mlRolK4HeSvcGCJBbukoV+XRy2wMcSG8HjEDcJyxQralCIKra4sASNN9muEQWYJfRS1CtX+iKRzfkH36VVTPbUYK8Fc3cJZ7tzga+Mi7P/WQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKQ/fcdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKQ/fcdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D70C4CECE;
	Thu, 12 Dec 2024 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023075;
	bh=02wX2kPWbcLVzyF9k3tVNF67Qh5olNc1Ekbz8S5ZH58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKQ/fcdpRq6ZhH/5KXuXhwgiEcCj0E4snL67vHU70zrVk777IF25+UIJDVq0+P0EN
	 alWDP6Y4ovAC45P/wFOiRBMU/GMR5dIhdeG5iO4YXil0BA2bS2SeMNu73DLC6IbRaJ
	 I3xwd6A6E9pmJ50sYt3m7EsF0555y9Wqc7DwiuKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 386/565] i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()
Date: Thu, 12 Dec 2024 15:59:41 +0100
Message-ID: <20241212144326.896424219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 3082990592f7c6d7510a9133afa46e31bbe26533 upstream.

if (dev->boardinfo && dev->boardinfo->init_dyn_addr)
                                      ^^^ here check "init_dyn_addr"
	i3c_bus_set_addr_slot_status(&master->bus, dev->info.dyn_addr, ...)
						             ^^^^
							free "dyn_addr"
Fix copy/paste error "dyn_addr" by replacing it with "init_dyn_addr".

Cc: stable@kernel.org
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241001162608.224039-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1282,7 +1282,7 @@ static void i3c_master_put_i3c_addrs(str
 					     I3C_ADDR_SLOT_FREE);
 
 	if (dev->boardinfo && dev->boardinfo->init_dyn_addr)
-		i3c_bus_set_addr_slot_status(&master->bus, dev->info.dyn_addr,
+		i3c_bus_set_addr_slot_status(&master->bus, dev->boardinfo->init_dyn_addr,
 					     I3C_ADDR_SLOT_FREE);
 }
 


