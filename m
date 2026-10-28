Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210544;
	b=3vl79Bw8ruLSbo4eBxU3w5B8NC0Z8RP7r6+08GpsFmP5F+gipf6pCmdy498o6VzGma7S
	 MQWnquTbSrhWhgmceIOa+6Qdhr+yxeU0+1CJE0cTtwLdBR/Pr/1vgO89qFu/qis94bH7s
	 ZxDgh9Fw2Et7WnEd2zzA0kxHBcy+GG+dVKUvI0CSq+VavdR4JSFkmRuYYFGa9r4v0k7Fj
	 psre4y8M6vTse00eMwtWalC9GlOAApsQpYz6Lbs3ARDyBzx+JMPfuTejBfYNQ6Hv5ATZc
	 q901n1+910Rx3hn72ZeVprnwB0KyP0ETQ3j9Dz7/oBnE1TIj1GfYJOwf+UHMgOK7fwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bUstvilXlPsiLsjQJvdblx6lpHkaH8/ziPWT8M3Dy7I=;
	b=eIM6GACUD7F1cE7qTKY/7mflPR78slA1pPlQZtb/psBAT/hEkxwqAWQbfaoq/V7sResw
	 8/nIKSaDPaAMhlU2ihmlsLjTU7hEMctTxXcLsP3L4EG4uQQS2pX7wszPAB1BUAmBeZNml
	 fsKQ+FGtmD5oIv0ZVTG9PRN/HPWRrfopGd7MBCtx3l7J+Ao1sL30La7oxpasW7FkhQDOM
	 1h31wdoFmKFxpRHQjX0Ib6Bq37JXKo8hrEL/EdQ8PFfpJ6aud3kBdrlMcqw59a5hG9NFl
	 2WlR4UjW0m/bJZ9f3HnrLy8HlUh4KhWLdsQ/81S5zKMj/CDUOrUx/ONXXx1TuDCQYUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d6fY/Va3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0396606A31D;
	Wed, 28 Oct 2026 18:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d6fY/Va3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0D81F01825;
	Wed, 28 Oct 2026 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210543;
	bh=bUstvilXlPsiLsjQJvdblx6lpHkaH8/ziPWT8M3Dy7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6fY/Va3CCo5ndi9PfqwJnE1X80NSDmQ36f/C9D1rT631mDFIFiLmcE1qSr+fSe7g
	 hJzTM/OI47+aYHg3ZXUbGqZ3s9OApQl3iekKaXRo1RyIIrEN/vXuLIDl5skzwUkcIh
	 +00lzB+VV78+WlSBNKwqeSTSbztSIA7aj9Q8i8aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/571] params: fix charp corruption on allocation failure
Date: Wed, 28 Oct 2026 17:53:29 +0100
Message-ID: <20261028170009.498217439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Yu <yujiacheng3@huawei.com>

[ Upstream commit 3dfaae04243cde460d82dfc2a7dd0bb6664d20ae ]

param_set_charp() stores charp parameters in allocated memory after slab is
available, and releases the previous value when the parameter is updated.

The previous value is released before the replacement allocation succeeds.
If kmalloc_parameter() fails, the setter returns -ENOMEM with the parameter
left as NULL.

Failing zswap's compressor update before zswap is initialized can later
trigger:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:strcmp+0x10/0x30
  Call Trace:
    zswap_setup+0x3b1/0x490
    zswap_enabled_param_set+0x5b/0xa0
    param_attr_store+0x93/0xe0
    module_attr_store+0x1c/0x30
    kernfs_fop_write_iter+0x116/0x1f0

Allocate and copy the replacement first, then replace the parameter value
only after allocation succeeds.

Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index e1eba5b8230c1..32682334ca7ff 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -265,6 +265,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
+	char *tmp;
 	size_t len, maxlen = 1024;
 
 	len = strnlen(val, maxlen + 1);
@@ -273,19 +274,20 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 		return -ENOSPC;
 	}
 
-	maybe_kfree_parameter(*(char **)kp->arg);
-
 	/*
 	 * This is a hack. We can't kmalloc() in early boot, and we
 	 * don't need to; this mangled commandline is preserved.
 	 */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(len + 1);
-		if (!*(char **)kp->arg)
+		tmp = kmalloc_parameter(len + 1);
+		if (!tmp)
 			return -ENOMEM;
-		strcpy(*(char **)kp->arg, val);
+		memcpy(tmp, val, len + 1);
 	} else
-		*(const char **)kp->arg = val;
+		tmp = (char *)val;
+
+	maybe_kfree_parameter(*(char **)kp->arg);
+	*(char **)kp->arg = tmp;
 
 	return 0;
 }
-- 
2.53.0



