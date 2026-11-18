Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031806;
	b=QXhJOk5dSKLsKv5YhkIKt5+RxEfgYDGmhByKxOHVc24Xl2so2K9ScYVn0b2xcPfuTf7O
	 q7aFRkXgVxAbsRcmNmnArld+4Zs9VQTl601ehDC3eOCOvSsYXr7qra1OTDPyjrq1yLZVB
	 3D67B3tQd5HpFlwatRUYWpJPnC5BWTV4xkYzPHpPpK8zxHjAjqBlq/kW8m6fMJOZwltAv
	 jP18/V2vwnLuvpO10gvRx2gv9vW+tVRgVtos372iZVHZ+1aGIW7wN9Ph7VoxFvOCxgiqm
	 zpbgSvgJ8uCnWlJrdSMBdqxF3On4vPokVT/9tmgo9H+7UjAOWYgivCOvutRINzFTGvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RoLcNO3kXXhIvHH2aBD9bD5Va63vWZCuh54P83tvALk=;
	b=zDkfLtALJdtOkD1X9Wk1ezGWLL8rYcq6w3gjsek8vLiQ4KxIr6TcerFsAhlLrX5/dTbR
	 Vo5sE6DA246263clh+no+j/gE5hewOG9//TWI5U0N1+QLVl//TXrO0nyq0bhRKz4qKWEB
	 8rRjR31cg+hsX6ZTgWgAq+hDcVz21LNWgIH0tsYLROomHHCuxopMJj5Vyukw88s3Dhtld
	 KyaPsUrXwc0xNLPg51Os/UH6vsAYi6iYdcVckaoZ4Z3vXQs0mOC9HBEdr3wNignukPy+y
	 VmXO9ANRKYqf+NmdUukP3dWwq9mPv9XaPY0GH+i3cBPq2by+3ge7g4Wsxe3NxSw9Xag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uli0w290;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCFF606A32A;
	Wed, 18 Nov 2026 19:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uli0w290
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A90E1F000C4;
	Wed, 18 Nov 2026 19:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031806;
	bh=RoLcNO3kXXhIvHH2aBD9bD5Va63vWZCuh54P83tvALk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uli0w290+bzWMJ2jlxlXEbJhePUbfpNrL2TuxjjPfeNYkjRWm7cq+PvkZJC0uTCMo
	 EzuVBdoU0XlZcNQ1NeQ6uwwxiaQPfE2XMt4p+cGkUsFDZ3rxJ/V5wyaD3uVo9P7+/r
	 irVjoI9TWlXatsATSHfXAOTw8DiiYZcWp3FJ01gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1186/1756] module: Fix uninitialized count read of unloaded taint tracking record
Date: Wed, 18 Nov 2026 15:55:13 +0100
Message-ID: <20261118150057.115403500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16742d1c630c6..244b4d7244736 100644
--- a/kernel/module/tracking.c
+++ b/kernel/module/tracking.c
@@ -40,8 +40,8 @@ int try_add_tainted_module(struct module *mod)
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



