Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9630C2153EC;
	Thu, 12 Dec 2024 17:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025568; cv=none; b=iiNV2gJo3HY3G6MfsgW2ML2g87uwIB2r75u/Tf3GZpu4Q4JIiv9CYX7DSDJVLfx/E7r6pb01AEVpH8yrb5dqsYrxJek6aRMrTgIrEVIV1zLgrvXiPA9WbXU5rcD15G55ZAuQsEwPORsDpwBrT4w3xdCz08rxppFSowpBTB1b+pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025568; c=relaxed/simple;
	bh=AjVOy3Qtcs3W8BigIcFTdTw1JHSlfcBQ+jV+kcXqxV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rj2z7jf6JAZ7ji+j7Ov5IDg/zce3zVaEFFVpa4RGi49yJya1+DGnrQd8Dd9/tLvzAWGI2wc9bN7DH6y2+VFBM9uVYcVWYV+6lCi0YmUIXsDMpus7ZwsIaVmbI6VvWCNmaD3hk1izg+HFJsf5egWT/soelxUrSeBZW0mxpySN8uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEhWx/Hm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEhWx/Hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0647C4CECE;
	Thu, 12 Dec 2024 17:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025568;
	bh=AjVOy3Qtcs3W8BigIcFTdTw1JHSlfcBQ+jV+kcXqxV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEhWx/Hm4wYlGnJW3lDovWDzNLCsY9y7ubMSXYcrUKu99x7ReKCOo6V8k1NAhxBeg
	 kujPxlPn2gDN69cRoYj5IcSOFK8PHiWC2Z//N5DENul7BJV2p2E9yTjRPdvpHWd3UV
	 I3NOh8WPU9ITh2k5YYuxX41nKMCfLhvoG1yXdl7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/321] um: Clean up stacktrace dump
Date: Thu, 12 Dec 2024 16:01:40 +0100
Message-ID: <20241212144237.179967669@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 273fe1b676cb59d41e177980a981e27806872954 ]

We currently get a few stray newlines, due to the interaction
between printk() and the code here. Remove a few explicit
newline prints to neaten the output.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 0f659ff362ea ("um: Always dump trace for specified task in show_stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sysrq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 1b54b6431499b..47f20304af26a 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -47,14 +47,12 @@ void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk("%s\n", loglvl);
+			pr_cont("\n");
 		pr_cont(" %08lx", *stack++);
 	}
-	printk("%s\n", loglvl);
 
 	printk("%sCall Trace:\n", loglvl);
 	dump_trace(current, &stackops, (void *)loglvl);
-	printk("%s\n", loglvl);
 }
 
 void show_stack(struct task_struct *task, unsigned long *stack)
-- 
2.43.0



