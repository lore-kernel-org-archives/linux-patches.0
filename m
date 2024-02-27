Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7225145B14;
	Tue, 27 Feb 2024 14:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044195; cv=none; b=XMRTbn/yTxCgPS/wBms0gn1CFZS/iwG/suoMZpRAhJeZu26zXV7vH81NX+IYSsaqEO41WpjNMJIDdSWJCohdHN92pZew8wmPnnb7clsyVG0LpLjxsvzkdu1mOJuqZGc+4M86i8ehu9TDLQgNVyVyLL+QszIrmQpv6ySOsglkxvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044195; c=relaxed/simple;
	bh=iq+BY2Bryyljm99zozJ1TV8mL2aoXregJqWaUHf3/SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0rodBU+DhY4xkx/FKbANO9q3br2tknjFERdD59Ur+MUjKdQJnWpD1vpw972RZTCwOC8uIVU08LhMzUdSGJ9ML4t50SrUp4YLuAybsWT8BUOwxbIRIBoKLeCLdFnM7d9KI0UxFeOryQOJljW4Hxus55SOvT4q181gxZoa/kNYTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJcnQUHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJcnQUHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73864C433C7;
	Tue, 27 Feb 2024 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044194;
	bh=iq+BY2Bryyljm99zozJ1TV8mL2aoXregJqWaUHf3/SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJcnQUHgG7cgcGOfBy+UIR4B6ezGBvWpY2IneXMEV7bpU/Wdazla8twfhSBxaun4Y
	 +8DaudyLIsBZBo9X0k9yugrObi3VsayWmduC8CbV0vWmkKWv+NFXwVyCuoyXk2T7WH
	 5lQEKNCV0/OoMuKM+tg2uhh9eGvlo7ndYeUemSeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/122] IB/hfi1: Fix a memleak in init_credit_return
Date: Tue, 27 Feb 2024 14:27:37 +0100
Message-ID: <20240227131601.844289647@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 809aa64ebff51eb170ee31a95f83b2d21efa32e2 ]

When dma_alloc_coherent fails to allocate dd->cr_base[i].va,
init_credit_return should deallocate dd->cr_base and
dd->cr_base[i] that allocated before. Or those resources
would be never freed and a memleak is triggered.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Link: https://lore.kernel.org/r/20240112085523.3731720-1-alexious@zju.edu.cn
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/pio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 60eb3a64518f3..969004258692b 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -2131,7 +2131,7 @@ int init_credit_return(struct hfi1_devdata *dd)
 				   "Unable to allocate credit return DMA range for NUMA %d\n",
 				   i);
 			ret = -ENOMEM;
-			goto done;
+			goto free_cr_base;
 		}
 	}
 	set_dev_node(&dd->pcidev->dev, dd->node);
@@ -2139,6 +2139,10 @@ int init_credit_return(struct hfi1_devdata *dd)
 	ret = 0;
 done:
 	return ret;
+
+free_cr_base:
+	free_credit_return(dd);
+	goto done;
 }
 
 void free_credit_return(struct hfi1_devdata *dd)
-- 
2.43.0



