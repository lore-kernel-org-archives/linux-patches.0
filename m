Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2CA23FC54;
	Fri, 31 Oct 2025 14:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919605; cv=none; b=sxQBzoLM2mDk/sPXA3KR3zvICNeWPMpoc4MJ3MT68sIGvwiDCO2d4myEHJnvDpJySmpwoHLiGU/ebLwjNyDJrD07Px7LXBT4XYsUvi4qj0Q5QB95DNFHS/l/30wD1Cdtg0EZ9UH2dRhFTOXweEnNQngA8xYzm1Az0mRBsMKxE/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919605; c=relaxed/simple;
	bh=PLjV7hIRpKROt7QCoHdq7S9hvGQHdVo5nn1Yq4WftcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCAxvzVn/AzvoGK0pyPcNFZk/NZY6+y9eBtWaE5v7TY/ifzHKI0m1UkagJ2d/W4twD9/waSUwsnz3xyk5wsjh3b56kHHH3zDplEJU7jaOkeBYQaAo+SL1Cs7OsBjgQkTdtDTjzFvAlHaNEBtXJT3KPgdxLyAJNjg4VLr+27wyks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVfDjz3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVfDjz3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3367EC4CEE7;
	Fri, 31 Oct 2025 14:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919605;
	bh=PLjV7hIRpKROt7QCoHdq7S9hvGQHdVo5nn1Yq4WftcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVfDjz3R7gHEyKVMCrXR9FU0ce3WQdxC5BVY5HYJxNTKQW23DEBijlLRxs+a1js4t
	 RMiH79he9uLauP+UrG8LO/QOjC3oWtYuF8qUmCdyLOz5fiqSItw8oOWh6E1s9FvBPk
	 d5xXIl1QJktnjd4Y6M/yEyU6A/+APA/oDN+DUixM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 07/35] genirq/chip: Add buslock back in to irq_set_handler()
Date: Fri, 31 Oct 2025 15:01:15 +0100
Message-ID: <20251031140043.737504060@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5d7e45dd670e42df4836afeaa9baf9d41ca4b434 ]

The locking was changed from a buslock to a plain lock, but the patch
description states there was no functional change. Assuming this was
accidental so reverting to using the buslock.

Fixes: 5cd05f3e2315 ("genirq/chip: Rework irq_set_handler() variants")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251023154901.1333755-2-ckeepax@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3ffa0d80ddd19..d1917b28761a3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -1030,7 +1030,7 @@ __irq_do_set_handler(struct irq_desc *desc, irq_flow_handler_t handle,
 void __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		       const char *name)
 {
-	scoped_irqdesc_get_and_lock(irq, 0)
+	scoped_irqdesc_get_and_buslock(irq, 0)
 		__irq_do_set_handler(scoped_irqdesc, handle, is_chained, name);
 }
 EXPORT_SYMBOL_GPL(__irq_set_handler);
-- 
2.51.0



