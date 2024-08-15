Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F21263D5;
	Thu, 15 Aug 2024 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733002; cv=none; b=eDX9bU3/YOSaHUvnqASDDFve40d/t6KZKAVlQsAiCIxEw9H/AJqaFSyXmV3kPz+9f5Me4p845ovGNfoSRr1acsPCNIXjzIMytkwPRUWQc35Zj5pXzjuR6KPAp4TaAKkrRuOXoSWvxbkqZPkaOQiCQlXbQq3aU8hj7A0WOSSCp/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733002; c=relaxed/simple;
	bh=6lBCwVj4KSOj+nkv4ehHepwqgFePscE9BobynrW/tEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+ZIdxsBLdsKpz1hRHI7WPJBXL4820OVDKGcvaOa9wLIFv/FjrQuG04x/fMFg/E9pQVJg3XSfTWYT+H0Ai5FlKRrr3H4iPlPDKZxtLwzF3KgJrQUf1DRGXZ4Lh3KDZbxnXew0IZjHl1pj55wNemHMwojYG35Ak2tT2YHx3FAQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/nBkDJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/nBkDJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68BFC32786;
	Thu, 15 Aug 2024 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723733002;
	bh=6lBCwVj4KSOj+nkv4ehHepwqgFePscE9BobynrW/tEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/nBkDJy8bnzv3ImJ3nsQkfouaGK9LbfXS/+j8u5OQXUHaRmqHm9e3vAnS9Y0aU2D
	 wPQWCJk33rVakZjLKijM+uGRMnre1IVhsGf86aslDVDOCU+iEDSj6Z/g+DlPUP7yYa
	 E6bcExV6zZiXcYQRY/T+k3U+BvX0xPZNf8kPT22s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 320/352] genirq/irqdesc: Honor caller provided affinity in alloc_desc()
Date: Thu, 15 Aug 2024 15:26:26 +0200
Message-ID: <20240815131931.823969563@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

commit edbbaae42a56f9a2b39c52ef2504dfb3fb0a7858 upstream.

Currently, whenever a caller is providing an affinity hint for an
interrupt, the allocation code uses it to calculate the node and copies the
cpumask into irq_desc::affinity.

If the affinity for the interrupt is not marked 'managed' then the startup
of the interrupt ignores irq_desc::affinity and uses the system default
affinity mask.

Prevent this by setting the IRQD_AFFINITY_SET flag for the interrupt in the
allocator, which causes irq_setup_affinity() to use irq_desc::affinity on
interrupt startup if the mask contains an online CPU.

[ tglx: Massaged changelog ]

Fixes: 45ddcecbfa94 ("genirq: Use affinity hint in irqdesc allocation")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/20240806072044.837827-1-shayd@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdesc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -491,6 +491,7 @@ static int alloc_descs(unsigned int star
 				flags = IRQD_AFFINITY_MANAGED |
 					IRQD_MANAGED_SHUTDOWN;
 			}
+			flags |= IRQD_AFFINITY_SET;
 			mask = &affinity->mask;
 			node = cpu_to_node(cpumask_first(mask));
 			affinity++;


