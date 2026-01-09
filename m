Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD41E2F12D4;
	Fri,  9 Jan 2026 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959823; cv=none; b=VcyjzkhgpQ1zE7D2Jt/wnt3sHEo0HiTsONHXTv4iufTrGOeBMBiQfN+JmVv9wGf8QBEXOc2JvBHV9PjdEQSgMdWLXvDNjEDRX9XBMmSK01+KnPQGrjpvDgN7adpTI02ZAo5e5hZ9gL30SLEldFeLlgYIB/nd5JqiGVQ5FHwY55o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959823; c=relaxed/simple;
	bh=Nc28Ap1UUHQyobY0VXOd0nSDczJQz6eg/98hToR9nfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vrv2o87OPy5H7jHEc0IKaOQdpYPGFFpJ0ZDMvEnDCZUD/cBeKO6ihgIjmcIcjAtV3FyubBiZSUjRjtpT7+V+7/EQ/6GStjYY16hbqbJt0Kj+8pmdhOyrCdeiy97y0MPOsA76zGVgLbfxomylM4+HOzrX16R4bQhnLTPZbq8MUJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUsiJvca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUsiJvca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B11DC4CEF1;
	Fri,  9 Jan 2026 11:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959823;
	bh=Nc28Ap1UUHQyobY0VXOd0nSDczJQz6eg/98hToR9nfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUsiJvcaVLkoo3/JEJ1XIe4+QZatkWaUNvSUlSYU1sPF3OkAY8ORLOGAX3/hQsZ+g
	 STiALSUt+HgNfpa0mR5J4twaBGnQ08iE8Rud+k1xCLm6qqaoLbeYfbhy/rHTqHP8+5
	 RnZQf2pgM6H7U9ZGE05xVoPacBt3T/imU5/x1o50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Yipeng <zhaoyipeng5@huawei.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/737] ima: Handle error code returned by ima_filter_rule_match()
Date: Fri,  9 Jan 2026 12:35:27 +0100
Message-ID: <20260109112141.067638363@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f3f46c6186c08..afbf963cb7483 100644
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



