Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CE676905;
	Wed, 21 Feb 2024 13:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522909; cv=none; b=nRiyLGPRW0czmbJGGkyLejYi2U1M41SKSMux/po8VRBRVLkL/LiBidmBciIhNJHYl0DPe/s7UQWnYvcD7u58YWLb/Do3YRSYgbJg00jA9ENainTfZAiCT9+40KDoOu9MlPIiwXzodC+wtrYcCtr6fzUwWvyEkPTMlmb1+5QtEKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522909; c=relaxed/simple;
	bh=Z1rhX9T7raWggexN+/+OhT93dsZzMQmOlb20ZPXk8KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxEGOl8ZMiUJYBdNQUPYcHtcxs4w50R2Ol1LXV/tENcmupScmCR6uGVBTE5A42ENNY5DYw2QSCs151d7XwS7cV6AUq0XaQ4WpllH4TtQ4e51s9Ao8p/qZdaD0INcH0RPsmAL9AhwAo/DUwnUGsDie3DWG5UVwgb4y4UaciaJMK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTFxVHX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTFxVHX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E60C433F1;
	Wed, 21 Feb 2024 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522909;
	bh=Z1rhX9T7raWggexN+/+OhT93dsZzMQmOlb20ZPXk8KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTFxVHX5fl1g2tbaxchfwFV4ezO+4b1I9fo2DcLhv2npbnrbzrO2gJRD2qKKdGm4e
	 FTNBZz94GkJ+Tn5+N1a4U/2IlEXfxNFZ33gG23aZctYyju6pDWXtHMnQEnudmI0V/O
	 Rwnipmrc6cRjAioIzyhmRZNctAneJqkfDY5q7Jio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 290/476] arm64: irq: set the correct node for shadow call stack
Date: Wed, 21 Feb 2024 14:05:41 +0100
Message-ID: <20240221130018.723245918@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,7 +45,7 @@ static void init_irq_scs(void)
 
 	for_each_possible_cpu(cpu)
 		per_cpu(irq_shadow_call_stack_ptr, cpu) =
-			scs_alloc(cpu_to_node(cpu));
+			scs_alloc(early_cpu_to_node(cpu));
 }
 
 #ifdef CONFIG_VMAP_STACK


