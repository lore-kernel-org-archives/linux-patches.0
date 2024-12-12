Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7063237FEB;
	Thu, 12 Dec 2024 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020579; cv=none; b=Tw6qeldq0NZeb2nxW4s4DiIFT8UlodCQR+XG3oWN6V4IHEyVxNe04wilbghCB7xK45P5BVzWKNF8ClWGJsfr+BBl+4AeSeWMIzd9j0XCmnQaaHgH/gikoiLJTYs9hJ8Cdc2/UnDJqRwhqGzYsFzQCehvdVoVrHLzZTokBn+msUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020579; c=relaxed/simple;
	bh=wnWvpqogDTxshhgsr+KKqD6MKL9CQbrDL7RYUY3Jud4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFKDolheAT2cskeG6reIUelY15zMM3IaON85GX1z/hJkfyLakSPyPvbZklmo4vC57lC/WgsFKcyBAWnOxfl1sl0bKcmVr0CIXUKKdNbNT0BGLEdwuIBSYVUeXHghvi8a+rKnqs7nz7kVKekuIXXNfUDTLULKgiWaAPv2/Efr7wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hilkvj72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hilkvj72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C34C4CECE;
	Thu, 12 Dec 2024 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020578;
	bh=wnWvpqogDTxshhgsr+KKqD6MKL9CQbrDL7RYUY3Jud4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hilkvj724IyxyKEq9KcSFwL8qgH7p35atPi7C8WC+3ARRdN3cr2h4x4NE1jBVVbR+
	 p3EuleEJm3K8fXL92a/zjOVH8ZzbADI+kQJdKFBaT+BU6j1TjNU2e6sFQwpsWfxz/P
	 TVBfVyIilCMoXTfSsWjFeY3VO7l7V/C9bK+0i+WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 487/772] i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()
Date: Thu, 12 Dec 2024 15:57:12 +0100
Message-ID: <20241212144410.069004916@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1281,7 +1281,7 @@ static void i3c_master_put_i3c_addrs(str
 					     I3C_ADDR_SLOT_FREE);
 
 	if (dev->boardinfo && dev->boardinfo->init_dyn_addr)
-		i3c_bus_set_addr_slot_status(&master->bus, dev->info.dyn_addr,
+		i3c_bus_set_addr_slot_status(&master->bus, dev->boardinfo->init_dyn_addr,
 					     I3C_ADDR_SLOT_FREE);
 }
 


