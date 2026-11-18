Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020124;
	b=gtAkWVrtWeks8mSTk+Yhgvf6f2GOfPM2iwVRp5WQL5iT5D6dZf/rTrN9RVnIO9A7mBTZ
	 unulHyoW7lMya0s+GjfZZLedZK95eBXAKq39eRY+FPY0daD+uPnHDWhqrWs0ZuL4piePH
	 kWNSc/q4h60yUqVQxwZxGHeV+2s5/An9hS0ICOMHc6Qvx9wECuyX33tHEDxKYt4fQeoLK
	 sijLtx2VGk+2nm2DWWWgLWiXtaJBsBy4XkFaFvpZ3ogOZdcJiVZljeh7IWsdDkdTZCmY/
	 +hxsi3YTqFkDRRiciYnpCjImHr/ZDUszo/W9r+9Dynean+rSH1+JquycdEOJCiq8RRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vgo88AKPLhIKUvSqGh9tbCBYOUKFtE4z81PxKapZ1kw=;
	b=kjlVgMxzTQjkWTjVXXUMc8RzpdD2i1GR2r2G0bTNgPktRxHyTO4mURDzKypVUo8g0uPM
	 IJmwAFCmGyBJyk3R8CXD142SSUz5x5HXePixyYXRmiVSRCiLq1X8yzGBVZ30G94lR1zFx
	 U8C8awLQdCm8pVhntU/8BLDvnBIPluvHDUeiW6CPH2u9V6w+IyLft0jdCGhQhiqZ97ujy
	 abAq9TR634IMwzostfLvMElgtuNKGSEU3VWtBL29cYJAUmBrSKKhDd+MOxExxFH+5ydq3
	 7u4vqnu3loikcnHyIeMyDyNRUhAgBUqnVQnCvsUG1hEMbvEJOySKtHG+nJi6naI9q2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCQzKJ3c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6698060A2602;
	Wed, 18 Nov 2026 16:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCQzKJ3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C8E1F000C4;
	Wed, 18 Nov 2026 16:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020123;
	bh=vgo88AKPLhIKUvSqGh9tbCBYOUKFtE4z81PxKapZ1kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCQzKJ3c6lQwIT814iVk7nHnYpMbynXOGj/oaLNoJgLEjhH/uNS7biptAYzZcevvf
	 7hQ8V7NBGXpP3LMd4PQt+am26JDFaln6oQwJHDP6+4c46x4ASx4wvLTDcEmHNDVdkd
	 9X61VhCIcrGRfld/72Xo62tNkLlHvK6Tg/NDzuDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1833/2651] module: Fix uninitialized count read of unloaded taint tracking record
Date: Wed, 18 Nov 2026 15:51:13 +0100
Message-ID: <20261118150353.103886207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9033ff54c4e27..9e8902600c326 100644
--- a/kernel/module/tracking.c
+++ b/kernel/module/tracking.c
@@ -38,8 +38,8 @@ int try_add_tainted_module(struct module *mod)
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



