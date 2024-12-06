Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EC2148832;
	Fri,  6 Dec 2024 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498641; cv=none; b=f2H/kQkFMUr12HzaDdx2oRVaqZ3f2qdx1HQRCuQo/qenC3we/58Ym21thbCng+Z67dt9JPvRmbBmwBuxKZDJeTQ0spVzwSunNlOg9xfIxUI8Rq/xtTGZcn/jWFPM4jDtEr702kPoXEimaTT2xoDTiUGXPzoBeC68XHCFKBYRBbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498641; c=relaxed/simple;
	bh=58zgequ2UmO4H/P/ZpFYNC0RWiVXcyFw3UDSMGsbcoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZh+5c/ichFXGm9dv5K7g6nZtRxiAF7zavrBemyI1l/2S1QZRBJi9Rc1JBg2H9Ux7ek8S8k5pFFB9fT/+8ztLnnpMSBQ6c0uaYtox5u4LRKIF6cqfxEZourLuOaswETodo8obb/LFVEEQPLk0yHsOiNPj3e8r3a0a6ff2VshETA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OKs0dId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OKs0dId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F2DC4CED1;
	Fri,  6 Dec 2024 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498640;
	bh=58zgequ2UmO4H/P/ZpFYNC0RWiVXcyFw3UDSMGsbcoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OKs0dIdDKR4qCUq3v2+asNdeoVGNnSlBRwulX8jL1nV2aJakcct1f73f/6tXugM2
	 YyCgL/IvYxPDsRFrx4PYN6pagPVtce1CRg8Ql1645Xxt8/IkGAXP8DjNpPzVLxDgoU
	 nKK0aY0CuU+Wbb0VeMSq/S9I+xCTpGSorIne6JN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 644/676] i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()
Date: Fri,  6 Dec 2024 15:37:43 +0100
Message-ID: <20241206143718.525054234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1293,7 +1293,7 @@ static void i3c_master_put_i3c_addrs(str
 					     I3C_ADDR_SLOT_FREE);
 
 	if (dev->boardinfo && dev->boardinfo->init_dyn_addr)
-		i3c_bus_set_addr_slot_status(&master->bus, dev->info.dyn_addr,
+		i3c_bus_set_addr_slot_status(&master->bus, dev->boardinfo->init_dyn_addr,
 					     I3C_ADDR_SLOT_FREE);
 }
 


