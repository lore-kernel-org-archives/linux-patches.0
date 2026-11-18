Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041549;
	b=jIEWW/iQb7+0O/SHsi6Hbqr9VkXAR7u+O2wvdTppO35ZZszeG5imik/i2A9gSM9kNfth
	 Rk1ft2xIU6S9o1WGfeviqOnT6Y2s4AA7ARgiHhzmybxwFufXUsZlmqzcCrpq5Q3q325xv
	 rWS8Lg11dbSepi+joxIBe74VYrm9AE5gD5xha2j3brjsh4cb8g1UdOryRH69QvIkbO4F2
	 qGRTXTJ5AWy++V8JFPQ/kFsUauOrmausbhBLneMfXuXHTdZHG7cJEnK8yJCBIl75e61OL
	 jcWT0SeHARu0ZR+3Dp9V+TXPlnEdeVgG4u9B65A3SdozrSkQM7ioZBQf0RKIH01+xaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LmrpO/o3h/8xsxGaGaBtAI3GTNsWOi5m+/YFz0/Q+yc=;
	b=xV9JezQ/d7kWbXqHWAbhHggku2VhPMCXgkeNtjuTXADQsfdH2vSlKwPvBpVD6ozBir+I
	 8Q2U8MPcACqFga4g9cuMbxtgjMan2RcveBvF6qrsp+zrfYdhXqRzYXGiIergESVDc3eKT
	 HirbKFBEp+gHOlSJ5dk4wUwewaabw0gZQ5Sh8cG9KjFOZCHFFSJ6FUWF5L5nb+hCqGGPT
	 bdO7on8WxNV9VNaXpTJzBUavR3Z5U5/OLU2XBTCJRGWGcl4eTua7D0T1ypR8Nj5feZwYG
	 fOd4izMuXPWIAcRIVRUt3VpRTjBZkqm6YnAbduVEnMuHjO1WIp1hjIpO8bNeH6JwA1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qaqoS4f9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D348606B600;
	Wed, 18 Nov 2026 22:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qaqoS4f9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA591F000C4;
	Wed, 18 Nov 2026 22:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041549;
	bh=LmrpO/o3h/8xsxGaGaBtAI3GTNsWOi5m+/YFz0/Q+yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qaqoS4f95AMwV7nbAlAd9WXU+Au5nLeL9E66DLQj3TnoWTbs05UBJ/BkmCnvKSnqu
	 PjiYer+obkIlnuqOrQNsqoA4YEsn/fyCbXddNWUhrsJqXkfVGEc7VoojQjMg130SIY
	 4YvtmyTb56sHGnf+xnCaUEyah8G+GACYbNaB7NXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2846/3318] module: Fix uninitialized count read of unloaded taint tracking record
Date: Wed, 18 Nov 2026 15:57:48 +0100
Message-ID: <20261118150445.988984949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



