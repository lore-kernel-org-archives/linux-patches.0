Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920C63DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYCwX0ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8910C433C9;
	Wed, 15 Nov 2023 20:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078497;
	bh=7XGsnjSY278wxcCUFvzHBN2pozgKZMW1jzV7/OkJnmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYCwX0ZVtqhTJZwK+FVlxQPPSq6/VqpiJP66FwHD6L2zwlr5GcUK1NAyOVXB1BP7M
	 uscY7N2t7vvWlOArgEVKFj4DxZbvp+KHHHbZwzeD6Wa6OY5XRwa13kSke9raGMILXt
	 F8itPbMzjiSq+xmMose+Gs7/6t1xBqQOv3xQlUhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 333/379] Input: synaptics-rmi4 - fix use after free in rmi_unregister_function()
Date: Wed, 15 Nov 2023 14:26:48 -0500
Message-ID: <20231115192704.854957583@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit eb988e46da2e4eae89f5337e047ce372fe33d5b1 ]

The put_device() calls rmi_release_function() which frees "fn" so the
dereference on the next line "fn->num_of_irqs" is a use after free.
Move the put_device() to the end to fix this.

Fixes: 24d28e4f1271 ("Input: synaptics-rmi4 - convert irq distribution to irq_domain")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/706efd36-7561-42f3-adfa-dd1d0bd4f5a1@moroto.mountain
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/rmi4/rmi_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/rmi4/rmi_bus.c b/drivers/input/rmi4/rmi_bus.c
index 50a0134b6901b..e6557d5f50ce5 100644
--- a/drivers/input/rmi4/rmi_bus.c
+++ b/drivers/input/rmi4/rmi_bus.c
@@ -277,11 +277,11 @@ void rmi_unregister_function(struct rmi_function *fn)
 
 	device_del(&fn->dev);
 	of_node_put(fn->dev.of_node);
-	put_device(&fn->dev);
 
 	for (i = 0; i < fn->num_of_irqs; i++)
 		irq_dispose_mapping(fn->irq[i]);
 
+	put_device(&fn->dev);
 }
 
 /**
-- 
2.42.0



