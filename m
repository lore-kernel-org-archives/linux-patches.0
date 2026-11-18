Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026591;
	b=onhEudANRYmrwvB+BDGSA/f60SRWxQ0N9h+ha9ada5QF9oJnZ8vryB8wXsd5Bmxb3xF6
	 hUesTs/WH4pa/Juj3f5F2wL9VJS8INmfPLr2b+JkHpZLW/g/EFKovGK6fqgYY0xI1T8hL
	 KpkAr4zoIxgjMeKn0g99G8CC8EP3SS+bUUdm6pTZeQ1i8wA576K5DGxSAFPGTS15N8jWj
	 LK7j02OImMyCOn25+m5HPVKZkz1TYMJkD2USgXYRzFkEH/+4dySMATISQeMyhMeeu1q+I
	 grA6rv0TI9WhqyQr9U5Hx4X4p/E/Lk5stqgw4Lf9w1gDpZdIOt4oSHA3oGPwScU/pJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lsPhl0FJ2+DflL9ywff2p4T8NIJ5BBD52c7djOxi+So=;
	b=GCvExMgl4CtZXlDXrGTXxlIFnnGWrOMVRdWGQE6NDzW8Z6BJSKH9gBAlwipr9tn67A3K
	 agxWeNBLhNxf01Wmn/yxkz+C3ny+mk39zRRBQliBBDjey0ei4wJD0i+Debcv4KIlzQkyp
	 sAung7ZEOD/YO38s+XmnBc/f8x3CkPKVKbADmvNzKAGClAkw2oHSocCx5UepakOr7bTxB
	 WayU43oyKyzcBhHh3FtIXO31h0PmWyHfguurf+68DWQ5TrhkdZ/tVVG+2u4qFmY85Yh3f
	 mm8cJYskaj4QI/CBhnGKEir0pUkhXJgUqV4xpqaPUZYY7/84fA/K/PnxSGw21Sy9Kpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtX4l18j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFA2606A320;
	Wed, 18 Nov 2026 18:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtX4l18j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB891F000C4;
	Wed, 18 Nov 2026 18:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026591;
	bh=lsPhl0FJ2+DflL9ywff2p4T8NIJ5BBD52c7djOxi+So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtX4l18j8zHc8LOjCyGOVBhR7LHD/Zmuna8k63wnKgji1dtFD8Osw43v/7bfnou5v
	 s5dSkDXo0ZVeKC+Onmswm1Qg2CDwGx1oQIZBOzEOKLj4OVPJwcVQ19jD9qbQPqrVVx
	 tHRDMwplzJDcLTeWTIFGEGCfLyAFH8kA7nwsWgEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1490/2151] module: Fix uninitialized count read of unloaded taint tracking record
Date: Wed, 18 Nov 2026 15:53:45 +0100
Message-ID: <20261118150216.158411984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4fefec5b683c6..7f468eea3cb9d 100644
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



