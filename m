Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116862236F0;
	Thu, 12 Dec 2024 17:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025477; cv=none; b=QpKQuXPrIX0rVU28y4+niXFIBlt+d+dCOb7xAr2L6YKS+tkGlTJ5mg+G/rND42xDEzsxGw/5tJqzqYb5P3raK7BQ6P+pZVLyNg3MNBsj4hlFjrAMvRPxRi3NrKbvTgYbYX+xt19iCTFFmqU/rYvp+ox5wWguTmK6HUNGM7MVdK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025477; c=relaxed/simple;
	bh=VhR9US1kWbwC2JREwjwGV6wXhN4NFoIrzhVFZly66DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYieWzr5sOv/CV/TV21SqWv4KTHhSDYKJxKcMcw3lqq9/n9eYrOkca9SCCfeu9dMAE9Omg/0g3HFnA4sfSiAtEj9L48yRPImlO75zYerc0dta/TSOgkjWZToadivhw6DbmlY+fbkyVQfw+z/x+8PKSJloJ5DpIjJlUEozPVNO8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6xDp3x1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6xDp3x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474F0C4CECE;
	Thu, 12 Dec 2024 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025476;
	bh=VhR9US1kWbwC2JREwjwGV6wXhN4NFoIrzhVFZly66DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6xDp3x1myFd0Hz5S9h372TonP1OtAUhbX94LOWbpCPtxp2+pXjjaIKHx0k6JIclb
	 +mWbib+QMtYaSu0B9hZ0b4FlJVfeGkyKysNTqoJ2ULFj5Q4aAfPEQDDr9+/3nJhaPH
	 GNWAvqsbPXDOy/BoBv3V+76ddmFRDry35GdfGS/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/321] um: Always dump trace for specified task in show_stack
Date: Thu, 12 Dec 2024 16:01:41 +0100
Message-ID: <20241212144237.217467831@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 0f659ff362eac69777c4c191b7e5ccb19d76c67d ]

Currently, show_stack() always dumps the trace of the current task.
However, it should dump the trace of the specified task if one is
provided. Otherwise, things like running "echo t > sysrq-trigger"
won't work as expected.

Fixes: 970e51feaddb ("um: Add support for CONFIG_STACKTRACE")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241106103933.1132365-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sysrq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 47f20304af26a..c4667a94eefa3 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -52,7 +52,7 @@ void show_stack_loglvl(struct task_struct *task, unsigned long *stack,
 	}
 
 	printk("%sCall Trace:\n", loglvl);
-	dump_trace(current, &stackops, (void *)loglvl);
+	dump_trace(task ?: current, &stackops, (void *)loglvl);
 }
 
 void show_stack(struct task_struct *task, unsigned long *stack)
-- 
2.43.0



