Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB4055E5E;
	Sat,  3 Feb 2024 04:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933975; cv=none; b=fNNiWZqF5Za4dZ2oZi0CmlLqXMEns4tZE3CybyKmYPdLghVuGvSXbm2TpraquEor6nJmP/D7GNWNUzp0qeuEIIvkq1V9Xz9T9LTX1dkXObzNznyQS9iifAbLGfG3QNAs0EFHz2b8zD39ipFKnJTQq6LGKrgQ6bPyKtRM/1ejHF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933975; c=relaxed/simple;
	bh=GNgKjad9pMU34k6Rc3x6NTdVAkRRbLAMX1uRBqJ+Nwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv+EG+tKoC6HFVxgiBPMektrZcVFtWSscsWrjq81dhYYqQWhriK7bswXAklhkls6ixkzW6pBDsS2cV/emtuPfhUOXs3/ElqPs1RdabfqVLM/6MYb8jb7vFZkH/TYrWglyDRO7Wkr7PDCfE0Sza6jebZKz5UlFe2l/lqZDZMMF2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kb59quA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kb59quA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75CEC433C7;
	Sat,  3 Feb 2024 04:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933974;
	bh=GNgKjad9pMU34k6Rc3x6NTdVAkRRbLAMX1uRBqJ+Nwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kb59quA6ZJa5kdmt3anjdhTyDtuOTpmUuXqmJTDTBUv1fTSqfMDlqid1CRw4KhCxe
	 Icu3jLCkf3ktIrlQnO0niDcS9NcxQzCYTWVSM+LflXbUG5FWGwT9eQ8LXJeJmGv08s
	 P4IQk7sZz+ZA+7juMKqsoJkcaZBxZp6gsg+XTta8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.7 348/353] arm64: irq: set the correct node for shadow call stack
Date: Fri,  2 Feb 2024 20:07:46 -0800
Message-ID: <20240203035414.759201856@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Huang Shijie <shijie@os.amperecomputing.com>

commit 7b1a09e44dc64f4f5930659b6d14a27183c00705 upstream.

The init_irq_stacks() has been changed to use the correct node:
https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?id=75b5e0bf90bf

The init_irq_scs() has the same issue with init_irq_stacks():
	cpu_to_node() is not initialized yet, it does not work.

This patch uses early_cpu_to_node() to set the init_irq_scs()
with the correct node.

Signed-off-by: Huang Shijie <shijie@os.amperecomputing.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20231213012046.12014-1-shijie@os.amperecomputing.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -48,7 +48,7 @@ static void init_irq_scs(void)
 
 	for_each_possible_cpu(cpu)
 		per_cpu(irq_shadow_call_stack_ptr, cpu) =
-			scs_alloc(cpu_to_node(cpu));
+			scs_alloc(early_cpu_to_node(cpu));
 }
 
 #ifdef CONFIG_VMAP_STACK


