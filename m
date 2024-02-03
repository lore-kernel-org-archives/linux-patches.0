Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F001B27A;
	Sat,  3 Feb 2024 04:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933724; cv=none; b=TC25T/+VzgAtwKIrWWascN9uFbj+MJ5EpafKS91EyVbUOZHpDdj0JxGIFwHhae2Vac3jH9x74+O1Ntr6Cb3bupZtO2KR+I4+gXRDDUKxcymG9YaQ6gFSStkWJ6tXztGpIV5pzX2SKCtnw8/BdeezPTxEecuQ4bXllU5YYdD1dg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933724; c=relaxed/simple;
	bh=7txGyNYNUylmJ6moM/36nopoAV58XXYo4u6XTcuMNJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJ3ZOiWu1bgudTzGOWj5PbcOPsi/O/IG5kAJiiOYoCHLCaOsmjb/5RrSlAP1bOSPzypoGgwdAIGTKvnANK7TznnsGScuykT1/rz4zacY+ecp8XW0jxZBOKCArd2vvBL7B4rsulBS419+dtSiKPyL5+yPo0fo5kAVqlky0jOipk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSj/QUZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSj/QUZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30275C43390;
	Sat,  3 Feb 2024 04:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933723;
	bh=7txGyNYNUylmJ6moM/36nopoAV58XXYo4u6XTcuMNJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSj/QUZB1NGhvbubP9PY5xRM7NzhsQ1wcjQEMm9ul73lhQjP1/g/mWi0Mxq/14VKg
	 u5EQGDRrIjEZxDx+uY89zfMlxbreUAToa/a8UiH7TZkDI7Af7pYtaHqAL2zSLHHht0
	 Fqm0VHKgosvu0lpth/eKkW+W6dYw0+H5r6gylq/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 316/322] arm64: irq: set the correct node for shadow call stack
Date: Fri,  2 Feb 2024 20:06:53 -0800
Message-ID: <20240203035409.244037050@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


