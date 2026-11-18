Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047536;
	b=eMvTurmX2VBbSI3xEdXDt19JumUM1eheJBefgWqMkSUMfuWMZKj5xgZefppL0gwLX+G0
	 3LVNcZ2GRWfgyiiZXBaRcRO2rxUo2VK9SZWClvmqhiGC01Xn6NAHZqekGQx1Z/3Mi1+P9
	 iVpSIUQI8urSM/yvPaRaTSlLsinkCJZbyNhbWJBpF1en41jmtqGPAEoCiMKYkTEVWJ7cj
	 4CaoLykHj/atLAA+tkYy2HfsB8l1wC0Jv2S5/n6oYEOsWV52aO2qRmZwSp5suq/CuRuqa
	 BO7w1muAmrnvyW8QyC7vpPF0lpYm48aZR/gq/fiVY8TN7c+3rE6hp+JtrHz2DkE9yVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3lFOrEWulP9ZwT57BXJIpke4tKuMVk9IpE59t1TCMY8=;
	b=w83XQWmixy/R3CF+icm1DvFv2tQvzd/V5wLJJ8lt8uTCVEyQcXDxg/bpaF5R5UgyoIq5
	 DH5ueGLd8FPHBXSSUndo5XZ49Ks8p8SCofVy9ff9P27YSyhmOnxk/umlIXEZQMYIX3h+F
	 vV0mDEAOOhK9hiT53mlww2B6n6mWnrdbhm+rnMx/nYrBTekOKBIZXDbgzk4dzVcyU7sJz
	 lr312cOzpBh4PotvUJBwJPm4okrjJ5eUVOsbDx6+S805IQF874dU8XVEvVPoUcyKLOTLn
	 tRKQjuhEY3bmo1pPWRRMHfiTg9ROj0eoqnFPozlujDMxqh6rFeWpjfyJDExq2mf5osw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bd9wKOIq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0074606A31C;
	Thu, 19 Nov 2026 00:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bd9wKOIq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344821F000C4;
	Thu, 19 Nov 2026 00:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047536;
	bh=3lFOrEWulP9ZwT57BXJIpke4tKuMVk9IpE59t1TCMY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bd9wKOIqNvIulZTzS5j1MoLk5kehHLEEV8Du8n+LL7g48NDgaGS5d4yRY/xwM4BBH
	 Fh9j90kLEsaRDYlio7EmPTM+H6lVJBTjfU3RhDlVzz0XhmRBtEDfoXOEwuG7lDUaII
	 tu+R6YWcunvjvuZdUJnXXPkmPfXCmNKJFs0MnJMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1673/2857] mm/vma: dont leak the charge for stack growth
Date: Wed, 18 Nov 2026 15:45:07 +0100
Message-ID: <20261118150301.564596017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit b1ee87802111156e27557e82acc31fa7dfc76e2a ]

acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
This can happen for read-only or MAP_NORESERVE mappings created with
MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
Committed_AS.

Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
Unaccounted growth skips the overcommit check while remaining subject
to the other stack-growth limits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-44-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced vma_test(vma, VMA_ACCOUNT_BIT) with a direct vma->vm_flags & VM_ACCOUNT check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 471dbff3e11de..4138cc91827c2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1974,7 +1974,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if ((vma->vm_flags & VM_ACCOUNT) &&
+	    security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	return 0;
-- 
2.53.0



