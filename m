Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213C830EF80;
	Tue, 16 Dec 2025 11:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884467; cv=none; b=WUoYmywQBeem3/hFLmrBnyErtCxds4/ODUCnDGbFSoOTKxg9ANYvBGuyt9UrBjyVfL5O6zkwtdkTgLxr8HdTqZH0IKUES1kBdy+2DMxj4v83opc0X7PTz9Z5NHV+wa5vLjO/1QsoDZ23deVZwzRR3oZpxIZX3BM6FGLXHEP2Jrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884467; c=relaxed/simple;
	bh=BR11ZeyCzyaFTlj+0u6DyCnWt6Y0Jl/KXKXrBlT8NUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq7EYBgbUt873khYTi42YGq8k+1dT/hdulpQ5UFLk6M25YNe4VSsI6dZfCHhnm+Bd7H/2OEfKTQz9UY3fXHEeeTGFQ7drMp0db/mcOF2nxVQBhaOBTnVMbBtoSMrqf6+FVoVislEyeAMBUCyScoF7F6oa6LgQ9/kPQcznMDQOgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/YqDeMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/YqDeMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B3C16AAE;
	Tue, 16 Dec 2025 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884467;
	bh=BR11ZeyCzyaFTlj+0u6DyCnWt6Y0Jl/KXKXrBlT8NUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/YqDeMxgwP3yW3g8ji9Lx3Wju7zreFIfhoRbY09+dtZ9OjJU0JYWkGm5aJToQpNM
	 D2b5lZkNjfsIysIaVrYP/z4yANaOyrK3Rul7jbic5iaXTvoEpSAzXFLxdV2f2lO0Zf
	 fT7eLsYXhk4pAHuT3MLPUve36AStqGaumRLo/ieg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Yipeng <zhaoyipeng5@huawei.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/354] ima: Handle error code returned by ima_filter_rule_match()
Date: Tue, 16 Dec 2025 12:12:48 +0100
Message-ID: <20251216111328.201012868@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Yipeng <zhaoyipeng5@huawei.com>

[ Upstream commit 738c9738e690f5cea24a3ad6fd2d9a323cf614f6 ]

In ima_match_rules(), if ima_filter_rule_match() returns -ENOENT due to
the rule being NULL, the function incorrectly skips the 'if (!rc)' check
and sets 'result = true'. The LSM rule is considered a match, causing
extra files to be measured by IMA.

This issue can be reproduced in the following scenario:
After unloading the SELinux policy module via 'semodule -d', if an IMA
measurement is triggered before ima_lsm_rules is updated,
in ima_match_rules(), the first call to ima_filter_rule_match() returns
-ESTALE. This causes the code to enter the 'if (rc == -ESTALE &&
!rule_reinitialized)' block, perform ima_lsm_copy_rule() and retry. In
ima_lsm_copy_rule(), since the SELinux module has been removed, the rule
becomes NULL, and the second call to ima_filter_rule_match() returns
-ENOENT. This bypasses the 'if (!rc)' check and results in a false match.

Call trace:
  selinux_audit_rule_match+0x310/0x3b8
  security_audit_rule_match+0x60/0xa0
  ima_match_rules+0x2e4/0x4a0
  ima_match_policy+0x9c/0x1e8
  ima_get_action+0x48/0x60
  process_measurement+0xf8/0xa98
  ima_bprm_check+0x98/0xd8
  security_bprm_check+0x5c/0x78
  search_binary_handler+0x6c/0x318
  exec_binprm+0x58/0x1b8
  bprm_execve+0xb8/0x130
  do_execveat_common.isra.0+0x1a8/0x258
  __arm64_sys_execve+0x48/0x68
  invoke_syscall+0x50/0x128
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x44/0x200
  el0t_64_sync_handler+0x100/0x130
  el0t_64_sync+0x3c8/0x3d0

Fix this by changing 'if (!rc)' to 'if (rc <= 0)' to ensure that error
codes like -ENOENT do not bypass the check and accidentally result in a
successful match.

Fixes: 4af4662fa4a9d ("integrity: IMA policy")
Signed-off-by: Zhao Yipeng <zhaoyipeng5@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 09da8e6392395..11b3ea1099ba3 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -672,7 +672,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 				goto retry;
 			}
 		}
-		if (!rc) {
+		if (rc <= 0) {
 			result = false;
 			goto out;
 		}
-- 
2.51.0



