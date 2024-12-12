Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD2D221D93;
	Thu, 12 Dec 2024 17:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024596; cv=none; b=aMZtrAaUDhr2eGrcbzvp17XIbZq227mxDfhyTZVYHO0iiGUBD4mWVXqgFFtKHNyKdXS6WL7mDJYdu2MLlDw33wFRzoEn2DgMRa2W1gLfSDsXUSLH1oYcGcN2/XQN5uqB4EEnbcelechz0r4NbZ6xCvWsIJhYzLU1k4UvCAtSihc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024596; c=relaxed/simple;
	bh=DIUdQ2cX/DSvB0Ng1j1dBhtxeuYzkYfEPTKchwRoLnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zdm+WNMEL3FrQmH3rB2ZJZT1ndRhv0u55INhzfKJCzwpiNqEb0THgRUS1XJjFJyvHtcKHfkRWGMoeyH41kOQ+h+Xh9KOLOr+Ic7troF+Ltq+0mN0c0IeSttbh7KcbXDP02YKb/N+VDbkYlosumlXnYyIaAmfKC/0rO4BnKZP+i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d28ZiawZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d28ZiawZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81445C4CECE;
	Thu, 12 Dec 2024 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024595;
	bh=DIUdQ2cX/DSvB0Ng1j1dBhtxeuYzkYfEPTKchwRoLnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d28ZiawZIH4lKoHHfABAeDUiKbcyJvTU0rQDAs5QnJ8jBRyhiu76IpXI2Y/Hh6q+J
	 cS7ua2cMxoOap/xqimytGDBrUBfqnByzmCZ4to81gT3Js9eXop8b7TLc9W2hmhshrM
	 4ksg9/zgr5FcjR2Sz8aeLxvcqmwoB8njFWCHhU7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 318/459] i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()
Date: Thu, 12 Dec 2024 16:00:56 +0100
Message-ID: <20241212144306.216291603@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1285,7 +1285,7 @@ static void i3c_master_put_i3c_addrs(str
 					     I3C_ADDR_SLOT_FREE);
 
 	if (dev->boardinfo && dev->boardinfo->init_dyn_addr)
-		i3c_bus_set_addr_slot_status(&master->bus, dev->info.dyn_addr,
+		i3c_bus_set_addr_slot_status(&master->bus, dev->boardinfo->init_dyn_addr,
 					     I3C_ADDR_SLOT_FREE);
 }
 


