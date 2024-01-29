Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453B41586C5;
	Mon, 29 Jan 2024 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548362; cv=none; b=QUaG/41J7euvK/aIxAIKKQpWK7MIAy6FwMQR/Nw0EA7N62Sf8+wpUjE06h+W828t/CZ+RILwjW1hg3ygHK+CCsv8omsXWJfEYs1wz1WwfIc64fHkfEffF0hDvq0ooLcsccdSow4/jZiSpZ+J6Vq1l5cA0I/aZM6bsZayDpePCRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548362; c=relaxed/simple;
	bh=R778/iumBAfDnTstV9hHY7M9Vqz6GVLAenVPQ4dCIKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlG+uq1hF7nI9LL1fY2nJYNnZYe2NaYCWYp2eN/CPXy/ya5jCb9so8Y2We4ipNBaJI/KnfWNrRqKCigkIoP52yK2qUcL5BXGm0QOoEvMQZdoBy4ux+Mm045NedI4mQ2unA368jSq0qqKJJlSRQI+gVEdM5byzZA2cGhL00V0iR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdsgRPUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdsgRPUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC64C43394;
	Mon, 29 Jan 2024 17:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548362;
	bh=R778/iumBAfDnTstV9hHY7M9Vqz6GVLAenVPQ4dCIKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdsgRPUfUDCS/bARSRHi3YDkABxKCr5e8nMrT6fgEb/a5jFOkzN8G7ja0sdww1Stg
	 G1T+ldrMV189SxNgNtWWk3luzCAU4dKv+mC6v0PK22V7oOVX2Mw+BmHP8wHRlbygGM
	 oSPU2gtcCcXW76xqXsZN6/lAiP3Zu5+Oza7AVNQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <dawei.li@shingroup.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.7 343/346] genirq: Initialize resend_node hlist for all interrupt descriptors
Date: Mon, 29 Jan 2024 09:06:14 -0800
Message-ID: <20240129170026.603457020@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Dawei Li <dawei.li@shingroup.cn>

commit b184c8c2889ceef0a137c7d0567ef9fe3d92276e upstream.

For a CONFIG_SPARSE_IRQ=n kernel, early_irq_init() is supposed to
initialize all interrupt descriptors.

It does except for irq_desc::resend_node, which ia only initialized for the
first descriptor.

Use the indexed decriptor and not the base pointer to address that.

Fixes: bc06a9e08742 ("genirq: Use hlist for managing resend handlers")
Signed-off-by: Dawei Li <dawei.li@shingroup.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240122085716.2999875-5-dawei.li@shingroup.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdesc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -600,7 +600,7 @@ int __init early_irq_init(void)
 		mutex_init(&desc[i].request_mutex);
 		init_waitqueue_head(&desc[i].wait_for_threads);
 		desc_set_defaults(i, &desc[i], node, NULL, NULL);
-		irq_resend_init(desc);
+		irq_resend_init(&desc[i]);
 	}
 	return arch_early_irq_init();
 }


