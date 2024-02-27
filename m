Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459AB13B2A2;
	Tue, 27 Feb 2024 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041135; cv=none; b=Jg0jPAU+WktDAAZ7yEcFDYm96aq1LiskxSG9LVPlf1Zlb6jp+9LiJCcOR+m8K0CMK0aWbuAqFTwwIXDblaHU6DWJ2VTqwxxuCoTy0vsIDE1zgv6y6d9yXWzFUFB/OgBiW0cwjWAtIRnbBCEoAz+nzresaiLodwv5wVMCdHv/4uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041135; c=relaxed/simple;
	bh=6yfWwYH3UAoqopO5roxj/tzNQZckz6CV8UxQBC/3ay0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRB+nrO1tmd7RUkF6BKcDZIQuGexpvCuBZ7z72zY8+ttIKjOFh5qUTfOLeK2yp7ykiFtZzwC5BAiOmhajOIlzBLAOppU6IOT6ynGSjRcgKVGVU1Y0DbZxfpNRHvVG+6LHN/jeupOAsMWWV/jWyPsPSOOKXFJR0E/97ROo/yx6nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc8fYexy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc8fYexy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36EEC43390;
	Tue, 27 Feb 2024 13:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041135;
	bh=6yfWwYH3UAoqopO5roxj/tzNQZckz6CV8UxQBC/3ay0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tc8fYexyIsV+tREuJFAosr9saBMr56UI06hIanZEqDqtV8zzrAa9mWrViThxvTYxJ
	 VUvyXA+4LAK6PwRrwNVoLij3XIU7yYkZy/vzhGGbbnzn3dgGIV7aO5mt4sAJO8Qba8
	 s5edzpMTF1c1D1+H5rTyEg5BMXnoNYHZfs7IDYmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 232/334] IB/hfi1: Fix a memleak in init_credit_return
Date: Tue, 27 Feb 2024 14:21:30 +0100
Message-ID: <20240227131638.315878183@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 68c621ff59d03..5a91cbda4aee6 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -2086,7 +2086,7 @@ int init_credit_return(struct hfi1_devdata *dd)
 				   "Unable to allocate credit return DMA range for NUMA %d\n",
 				   i);
 			ret = -ENOMEM;
-			goto done;
+			goto free_cr_base;
 		}
 	}
 	set_dev_node(&dd->pcidev->dev, dd->node);
@@ -2094,6 +2094,10 @@ int init_credit_return(struct hfi1_devdata *dd)
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



