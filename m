Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356A2244679;
	Tue, 29 Apr 2025 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945335; cv=none; b=TI8NRSsX9DYjqz1HVFgkJXiE1d533wcoWI9Y6b2RuqOlHclafIKPKx75ZJ9WXM2ZuluAKA6Foem0pX8xA7fgk2TEjzH1tox3aUq8dUpaKkqAScZlxWh2hl0BqFLMceMNQeePRskCmM188F1s3XaAYI97IBGx/cHOP9In+q5jKmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945335; c=relaxed/simple;
	bh=8Z6SxilebrmauUxcwKsU0vEUUEPeCNUj8Tn2wSrOGvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4WzhD0YpGWWrHyO0I4NqI746acGc+BxHJrhsrueT5OurBN/Od9v9duvvciy2OB/PWnNiHT//GxfmPmo6DYKPWxCwRQOmf1kJ89XYPYDXEeAy+z3epOktad+HBTRNx546gz/5nI+3OfWU8FdGJppjx5cb3EsXmAV7UAF8F7zWHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoNQxbou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoNQxbou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35459C4CEE3;
	Tue, 29 Apr 2025 16:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945334;
	bh=8Z6SxilebrmauUxcwKsU0vEUUEPeCNUj8Tn2wSrOGvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoNQxbouCqVO1zuyioXkzAPDNJWfVPyuj/6aeYJ7N4JrASRjhHXJtT1XiaecBWvIY
	 m1rv38ip9x7gikhgYEXMxqG8EG4qA13dgSUxkIYtGdKiCvDIduMQ8Oz7WDl2UMAtVT
	 YXntiW2nQDHBu1FcyJBf0XLSbaiXBwvfUBlbYIDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 077/179] of/irq: Fix device node refcount leakages in of_irq_init()
Date: Tue, 29 Apr 2025 18:40:18 +0200
Message-ID: <20250429161052.528026267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -555,6 +555,8 @@ void __init of_irq_init(const struct of_
 						desc->interrupt_parent);
 			if (ret) {
 				of_node_clear_flag(desc->dev, OF_POPULATED);
+				of_node_put(desc->interrupt_parent);
+				of_node_put(desc->dev);
 				kfree(desc);
 				continue;
 			}
@@ -585,6 +587,7 @@ void __init of_irq_init(const struct of_
 err:
 	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
 		list_del(&desc->list);
+		of_node_put(desc->interrupt_parent);
 		of_node_put(desc->dev);
 		kfree(desc);
 	}


