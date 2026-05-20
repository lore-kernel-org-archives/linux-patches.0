Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191373BD63C;
	Wed, 20 May 2026 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294517; cv=none; b=IMgwF+EQxoYTTsJfOPQ+Qwzaej880iQaklabpdaKRvuqfn9JpnuG5p160X8NOlAQrmAu9XnPbNGbhYlIYaUIxjTi+Ct+6xdsMjLWhT2t7d+ZUPGgViuCnLQN/tR8Zb3XyDCQbYgdh1B3Z4DPI/HGrBORne49tCNUGUpy40u4onQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294517; c=relaxed/simple;
	bh=P4ipq9KwyI3ftrqpXMtR8L2ora8bXi9nI6i8UUM60RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2e9uGKPNY77cAKiQjN5kCs48q+ZYmauE1taeW0O8M16gyjys858OxaIrvsw5ZCsPvdoCaeeWHM64B9FAuRF/LjM4lDdttc7Bosrr9IUDnCyolQIjxTK/AqD7DeHLyfd4C4QLSqlM0+/aitcSfCTTJZLCYc3UNCP/ts4XJubAnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm5pgXKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm5pgXKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E3B1F00893;
	Wed, 20 May 2026 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294513;
	bh=9nITG6apeLaqtzi3kSp7n2M/wjJhRSCpk4sXtPTo8Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gm5pgXKDs3Y57Tju6hKcn5Pa8EjJle1SagUUEd+AeRURwLmq++pGX3CvrVr3peLUT
	 B0ttEaoEACpJk3So0DpA/7J88MvF4Vlo0BXCn+VyyRfNvo+3bB9UchCZ6pDqj7s4Ww
	 kz6rG7er17PT3MSWGyzPEBqomdjTRHKyGVUCTZws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Babu Moger <babu.moger@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0067/1146] fs/resctrl: Report invalid domain ID when parsing io_alloc_cbm
Date: Wed, 20 May 2026 18:05:17 +0200
Message-ID: <20260520162149.877457923@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit d06b8e7c97c3290e61006e30b32beb9e715fab82 ]

The last_cmd_status file is intended to report details about the most recent
resctrl filesystem operation, specifically to aid in diagnosing failures.

However, when parsing io_alloc_cbm, if a user provides a domain ID that does
not exist in the resource, the operation fails with -EINVAL without updating
last_cmd_status. This results in inconsistent behaviour where the system call
returns an error, but last_cmd_status misleadingly reports "ok", leaving the
user unaware that the failure was caused by an invalid domain ID.

Write an error message to last_cmd_status when the target domain ID cannot
be found.

Fixes: 28fa2cce7a83 ("fs/resctrl: Introduce interface to modify io_alloc capacity bitmasks")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Link: https://patch.msgid.link/20260325001159.447075-2-atomlin@atomlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/resctrl/ctrlmondata.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index cc4237c57cbe4..2ef53161ce119 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -992,6 +992,7 @@ static int resctrl_io_alloc_parse_line(char *line,  struct rdt_resource *r,
 		}
 	}
 
+	rdt_last_cmd_printf("Invalid domain %lu\n", dom_id);
 	return -EINVAL;
 }
 
-- 
2.53.0



