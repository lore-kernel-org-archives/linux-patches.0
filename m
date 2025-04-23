Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D7229AAF7;
	Wed, 23 Apr 2025 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421797; cv=none; b=oPatoASzydRSWxC+sPjLtE2DzEWWLbNXkSaX5N7x390JHFpv1HbatLOoOnV3h5iXY1TNHg+e3DyVv0lLux4kXDQP4ZPaZirccVqtMscB7ieTeWr+dZ47PAlAhW5Ye4j3MCifR941MZVP6IqL5boa2urpF6K+ZaiEuM9wIKutfuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421797; c=relaxed/simple;
	bh=ZDmMc9hOeo8D6x84tLoABV4gDez8zA9QwcDKAfIiPzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fM5V5aW4vvn9GdcPr0DfjnFxtctKar06X2V/YDT+aVAzE2KRH3QbWUP5CRWfOFBXZxfuzoNZ9YVkWGOAEHvqFpJVmEDFgKwPfadQe1IOmeerII5xsvtZFnFfN607ph4upxxszWPvbUY1IccRddFBJpGnZ5oLIJwnaExVyTfitck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0QZyQi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0QZyQi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA95C4CEE3;
	Wed, 23 Apr 2025 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421797;
	bh=ZDmMc9hOeo8D6x84tLoABV4gDez8zA9QwcDKAfIiPzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0QZyQi5jdwuX8JZ2QA6WYA2pSz6tv0IxGox2Jre+cA+NzXWgIu5CbrDFWnrnof7t
	 Fui8iQKb1/+3nsAdc/aREzIubMIYBDcFLHUFg+Ip1TZsj0eorlbibEhALQT/z6QtBB
	 ZOfWc1CkP2GBKIeZhUu44yNd+luvy6xd9viKU4eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 225/393] of/irq: Fix device node refcount leakages in of_irq_init()
Date: Wed, 23 Apr 2025 16:42:01 +0200
Message-ID: <20250423142652.685504875@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 708124d9e6e7ac5ebf927830760679136b23fdf0 upstream.

of_irq_init() will leak interrupt controller device node refcounts
in two places as explained below:

1) Leak refcounts of both @desc->dev and @desc->interrupt_parent when
   suffers @desc->irq_init_cb() failure.
2) Leak refcount of @desc->interrupt_parent when cleans up list
   @intc_desc_list in the end.

Refcounts of both @desc->dev and @desc->interrupt_parent were got in
the first loop, but of_irq_init() does not put them before kfree(@desc)
in places mentioned above, so causes refcount leakages.

Fix by putting refcounts involved before kfree(@desc).

Fixes: 8363ccb917c6 ("of/irq: add missing of_node_put")
Fixes: c71a54b08201 ("of/irq: introduce of_irq_init")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-7-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -633,6 +633,8 @@ void __init of_irq_init(const struct of_
 				       __func__, desc->dev, desc->dev,
 				       desc->interrupt_parent);
 				of_node_clear_flag(desc->dev, OF_POPULATED);
+				of_node_put(desc->interrupt_parent);
+				of_node_put(desc->dev);
 				kfree(desc);
 				continue;
 			}
@@ -663,6 +665,7 @@ void __init of_irq_init(const struct of_
 err:
 	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
 		list_del(&desc->list);
+		of_node_put(desc->interrupt_parent);
 		of_node_put(desc->dev);
 		kfree(desc);
 	}


