Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A8014A088;
	Tue,  3 Dec 2024 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242678; cv=none; b=YymFeias5+M7eQVA9nrRjCXAV3uRm6OhTuVTSKnvMn764+9ogO0cOc1oi7Wq3mbXYB7+fvbJN4bM9WdudmadNwI09vdXrVCFjECVvOFe5YrIpupIiKR8KjJ8zSPtO1KRrqohSrZTJMcQF8ZgSAmQtIgxV46w8p3dCP2ALKbr490=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242678; c=relaxed/simple;
	bh=61XCGufu5O6d81kVxa97J/xnoV3w8TjXyefDP3yq+h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7j1JgKj2NvALB2nWFTD+TcQyTP5odob97W3JFj6fTUhSYcq803HNvqGL2m+ScjnMkcRkUc+QJoSEMhGbKqKi4GtFp1tpmVDxz/jrQZX2IiMH2ZsTVeqD9zCUsC/yBbuPUaahlXF+gtYc52qTmhb/QiKx75a+dUNqKJ198Cn910=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QS1zi9FJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QS1zi9FJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97ACC4CECF;
	Tue,  3 Dec 2024 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242678;
	bh=61XCGufu5O6d81kVxa97J/xnoV3w8TjXyefDP3yq+h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QS1zi9FJiWOgHBfiTYXsmhyZAprooisU+gihMNJs4aFA8oVtgHv6Dk8R1YAmkHuTe
	 Q5nRYt7r7EIysua1+2/7P+8a2VMKv/t7Hq4gC11yXXAfSPwjCiuS+yfN+6ZpHn+bdi
	 3iyIWXFh4VpJLM6IPfNHZ11HxGcI2Y5o9xMVGY18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 776/826] um: Always dump trace for specified task in show_stack
Date: Tue,  3 Dec 2024 15:48:23 +0100
Message-ID: <20241203144814.037299187@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4bb8622dc5122..e3b6a2fd75d99 100644
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



