Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049744;
	b=fJ6WEWIktRjVlOHr6UpjIl3Iy6mwWJyjxTEy1Joc2ehtmdq35pozHAilnNHT8ApXRvwd
	 Il8xAs2KkjxvqTbsKPstEIJRoOUIx8+mT7tGUVks6VTH/LdDockL2Q5le6ceXQDWb3scU
	 xZ+5xBlZTLv4DDgA7JPN6ElZYftytMeQ6pKLO+c4jH9CVqSGiPlA7LYOsJi+lv+JZCK0K
	 /NHHrBk6jR8BdoUabXaVJIUxsGFCcwJZkWfMaj+q9ThI94Oz60vHVu5qICopexun59aJn
	 0qxN6xbo7B3cdfIxdAg/dVAofVcRoYqw1eV5SAO6Nu7ZPA3/oq6679K1uznh3uZq5Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bE8aLN61hDYEqqFeVOzb93hG2L0CzN4DuehcLfV/6tg=;
	b=eCcT/Jgnf8JQlsH4xHvCViWqOXEw19NKwSux6k20CDhpM9K5/4lmLoYAZG5lESojQZ/8
	 bDjS/ZLbSq+3QDPkAkAFIXozu52uGqS5iNLcq/Ba/HwsA1ROG8fU+xb1n0K7kpJlBV2cV
	 aTyx2v5Dp2bBNWDsZi9EOWnAMvX2Qa4PV0xynjAa8baWDl+0UxtjB6dCs7ZP6hPV3lNth
	 VubDZHrugfl4ljiuMOZu2rqGHuX8icASMhr06n+D2aCblUtjCroKZ6RpIDO3QPFwRAVFt
	 isv0OnbY1M1rhvx7jXnv1hWz0FjRwYH6anDJPVsQs+Jcwl0Q32lM3SgzYddQ+5mQIvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJSOXXQ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B6E606A31C;
	Thu, 19 Nov 2026 00:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJSOXXQ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7682D1F000C4;
	Thu, 19 Nov 2026 00:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049744;
	bh=bE8aLN61hDYEqqFeVOzb93hG2L0CzN4DuehcLfV/6tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJSOXXQ3iodNPKOo4BblR3VJahsjJc3gnRWO5A0dhVfub9/yiJPMKM/8sFKYtXlEG
	 dzijtDxspORcQ/XPfDSDuOlCeLlJe6LX69M/n258TyiYekoY9w0PvYgyoxp/fNCJdM
	 s2L47HzqPskeoFkxhRgEUzl0mWq0U0cVQuBpte24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2462/2857] module: Fix uninitialized count read of unloaded taint tracking record
Date: Wed, 18 Nov 2026 15:58:16 +0100
Message-ID: <20261118150330.214622673@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit 7a5c13cfdfcb1871050fdbe00ac223993f8925fa ]

try_add_tainted_module() allocates the tracking record without zeroing
it and initializes the fields in this order:

	mod_taint = kmalloc_obj(*mod_taint);
	strscpy(mod_taint->name, mod->name, MODULE_NAME_LEN);
	mod_taint->taints = mod->taints;
	list_add_rcu(&mod_taint->list, &unloaded_tainted_modules);
	mod_taint->count = 1;

The record is published by list_add_rcu() before the count field is
written.  The readers, unloaded_tainted_modules_seq_show() (debugfs,
under rcu_read_lock()) and print_unloaded_tainted_modules() (panic
path, under guard(rcu)), traverse the list under RCU and read
mod_taint->count.  module_mutex, which the writer holds, does not
exclude RCU readers.

A reader that observes the new node between the list_add_rcu() and
the count store reads an uninitialized u64 left over from previous
slab use.  This is a data race and leaks kernel heap residue through
the debugfs file and the panic message.

The race window is two adjacent instructions; it is reachable when a
tainted module is unloaded (rmmod) concurrently with a read of
/sys/kernel/debug/module/unloaded_tainted, or with the module list
printout of an oops on another CPU.

Fix this by initializing count before the record is published.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 99bd9956551b ("module: Introduce module unload taint tracking")
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/tracking.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module/tracking.c b/kernel/module/tracking.c
index 26d812e076152..39dd42c72b6d8 100644
--- a/kernel/module/tracking.c
+++ b/kernel/module/tracking.c
@@ -39,8 +39,8 @@ int try_add_tainted_module(struct module *mod)
 		return -ENOMEM;
 	strscpy(mod_taint->name, mod->name, MODULE_NAME_LEN);
 	mod_taint->taints = mod->taints;
-	list_add_rcu(&mod_taint->list, &unloaded_tainted_modules);
 	mod_taint->count = 1;
+	list_add_rcu(&mod_taint->list, &unloaded_tainted_modules);
 out:
 	return 0;
 }
-- 
2.53.0



