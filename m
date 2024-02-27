Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E400413B2B3;
	Tue, 27 Feb 2024 13:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041597; cv=none; b=FWznBXOc9HJnHS+4TIycfz5lNYYmQmL6BmJ4QnsN8/5W79J0oRP39wu6Gh2usG5OlIfn42309JPPRPxsZ2KFnSIsaH9bdqDLz5uiXmSCsq8qqJij0f60AbmiGftZd4Cz4reh2YAqxtKi9ncTjRwM/kqROwTxCnPoniUZqx/lPRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041597; c=relaxed/simple;
	bh=p34U8IJIGbXbJu+uA6C3v2mstGwEnDBhE8jVHtyRfz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hiy8OE4wD+HUfzHXN6Wj6fx8KBhFRpFuArtt9blvMkhyTmjiTXEbYhCYRCSdUKmYbE1fZzOfpBhekpN0jkXoM4gSg994o9gY+y5A1huLySM/ro7K5s2BsgxcQFwM+TSO5LxcMlH/falRPwP+VN3HAZCiuCiGRsmZZgUYB46T3/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nX2GiyGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nX2GiyGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B85C433F1;
	Tue, 27 Feb 2024 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041596;
	bh=p34U8IJIGbXbJu+uA6C3v2mstGwEnDBhE8jVHtyRfz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nX2GiyGhOH6lYpDpZqVUxLeZBpD7AvH26jKuxHl01Sq4WoWW2NmXtJdcYJZWnRZrW
	 UNW40Xn6RFZFP0GIUl6dkRdgiGWjMslXJ5o5ILJTovdesFfkf71LU0cltDQkIa0Hbj
	 GEVbl+2XetkHXJJ37L+8wrCLqrJh+q+Z+AlYgrv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/52] IB/hfi1: Fix a memleak in init_credit_return
Date: Tue, 27 Feb 2024 14:26:22 +0100
Message-ID: <20240227131549.685969024@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3fcbf56f8be23..c2a129ed17743 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -2118,7 +2118,7 @@ int init_credit_return(struct hfi1_devdata *dd)
 				   "Unable to allocate credit return DMA range for NUMA %d\n",
 				   i);
 			ret = -ENOMEM;
-			goto done;
+			goto free_cr_base;
 		}
 	}
 	set_dev_node(&dd->pcidev->dev, dd->node);
@@ -2126,6 +2126,10 @@ int init_credit_return(struct hfi1_devdata *dd)
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



