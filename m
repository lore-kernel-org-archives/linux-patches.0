Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BD0223C57;
	Thu, 12 Dec 2024 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022981; cv=none; b=DF71vrIuWYV/oFAjRh1eUqzVqAUyFPd8gMjn+wYSbMBToDjlKDqJh5Pt0GA8/hwbW2NowHKGR6+tHf51jUbqkjvY/WO0IYrjTi5rcNgEDclbY74Q7LODCuGRJWd3hJJDwvfF1JnMMvcACsDese6xcnsBz7vEJMQu7cSta6b2924=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022981; c=relaxed/simple;
	bh=78VbEhM8h4v9IECgs1u4Sp0jO5BDTffrEBxRToMCuKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oit0h+ZK4ZRq9eYUmTrIeJ+IkBDOmGFserTZNB/slHap+y/2jNFYMxSvLkZFYClSa7JuS7g/UFl8UA+NFrnubzoroFus29P0eqGcFR5cHFVr/XZQ5xQSZNfRJvPUu8HOTyYysTA9cxLwV+GfT1MhwErczhjoUp+XVu+hwWHhies=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ny9zfWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ny9zfWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E92DC4CED3;
	Thu, 12 Dec 2024 17:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022980;
	bh=78VbEhM8h4v9IECgs1u4Sp0jO5BDTffrEBxRToMCuKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ny9zfWHZN6kdrFh6j3AKw3vmROkbr6ZrAy++OhAeVEpLFFo4e4BLhUrb9v86U5Ji
	 kQZz3KHes7akvgJC1croq/RL2LOKsajlwgdA/amiVtjC+ghO2L3bjnLa6r/RA5ACoL
	 lefj8+qVepHQ1CKnKDWj+uQV6bpwq8wBVwoE5YLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 356/565] um: Always dump trace for specified task in show_stack
Date: Thu, 12 Dec 2024 15:59:11 +0100
Message-ID: <20241212144325.676788608@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 7452f70d50d06..34edf6b8b69d5 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -52,5 +52,5 @@ void show_stack(struct task_struct *task, unsigned long *stack,
 	}
 
 	printk("%sCall Trace:\n", loglvl);
-	dump_trace(current, &stackops, (void *)loglvl);
+	dump_trace(task ?: current, &stackops, (void *)loglvl);
 }
-- 
2.43.0



