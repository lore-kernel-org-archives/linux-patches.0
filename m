Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59633A0E9A;
	Thu, 15 Jan 2026 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499096; cv=none; b=lZ7R7NH6siU2EEsYito3X8pBkiHJTw1qTWIb1930KHiUTyUlZlo84jRKA03PtWPSXGFELy8f/GXkmZ4hp7RwyUPzXBtVSapYOSgVbAqUPualgAc9jUVcQJfussh28S2uum60WK11bD8WofQ7WV7Ei11HyniyBo7Dksi84hIrA7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499096; c=relaxed/simple;
	bh=GY/Ub4hnpRGj7pi0DU/VzlrIEENkR8+hdUYGE+lZ7XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPTpoSMwEJ2sdMvDPfsWidPqq6cxLE/sLIXoox0f6kVwQCjrdlxWqrnn6Xl/NJpLbMnif+BWn2Vib/Dm0jmHofWZRjXk7iEtaIcWbKFZNTVsncKFti3zSj5LDWlRXyA9VR/6Db52MEYtmFLKm0yS1yv6b0El0fqOYmYRdYbvGrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDl4p0V5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDl4p0V5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709AEC116D0;
	Thu, 15 Jan 2026 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499095;
	bh=GY/Ub4hnpRGj7pi0DU/VzlrIEENkR8+hdUYGE+lZ7XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDl4p0V52KeIJ78mbpcCVwej+1SghIwOmYn/Yyt6WKuSb+3e96Z5FMKTcrwrrcWgT
	 3Mkl81xpIyfH1TXTDzUt6cR41a0XomBjdMh1aXN1xUP6vvCWQelQGtI68vXDFW2ZmO
	 fvjy9KIYT/3KJRkKuEDO/2ApQ8NWiembPVm9+fE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Yipeng <zhaoyipeng5@huawei.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/451] ima: Handle error code returned by ima_filter_rule_match()
Date: Thu, 15 Jan 2026 17:44:50 +0100
Message-ID: <20260115164234.138316622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8d69b2e27936a..540c1ec9fe729 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -581,7 +581,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
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



