Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CA92F83A2;
	Tue, 16 Dec 2025 11:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885985; cv=none; b=iFwXRNMfmw1VQU4Imyxr/ck7G/cj4sKvIbYAHjThSe9tQr18fWpCpKtXJgHhSKp9a40u8+XOq0Pw+XH2pLXVubtLTqKjGJI/1gVzjHcTBeWytg19HhT4LEtYdu4EV0FiVM0gXMGUuCNuKfk6UqKJ+05fSUhf4c36PHWGLo6BEbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885985; c=relaxed/simple;
	bh=mB0m+/KZuuDLY9oErLzJsA/CG1qFBRNNdYZ+yQky3cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbayTIXGoK3bNSUlJ/AkinzCtT3ZBcGvnmutGDAm7QHlXVUu6OcNlpYThVWKnG+b6RTFVR85Kxsl2BeV5h2zsCe4DY21vl9q6sWZareywFKE7M93fj1K2vJikeFlyZ7EEiEqxUWh0+8GBL1J/WR3lYW/Ov1aCjk/uYsknVSJs7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2e2EFYal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2e2EFYal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B5AC16AAE;
	Tue, 16 Dec 2025 11:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885985;
	bh=mB0m+/KZuuDLY9oErLzJsA/CG1qFBRNNdYZ+yQky3cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2e2EFYaldSKI/e4ZtcQBrgyQz6RNC7RrLjM1RNUEDk6RN26Fim+592uU+EaHhBH+t
	 /TWmW2Q6kVjWeS7JR4bOhKkVlDTG/QmT40L1GprNKvVYMs1Gkxcut9rBTgo+9RIrXw
	 BWj3nCSSgzQH071jhoWgcRrowgfzJUL7v0RZbZcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Yipeng <zhaoyipeng5@huawei.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 303/507] ima: Handle error code returned by ima_filter_rule_match()
Date: Tue, 16 Dec 2025 12:12:24 +0100
Message-ID: <20251216111356.450622800@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index 128fab8979308..db6d55af5a80b 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -674,7 +674,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
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



