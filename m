Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208386;
	b=31mJHFIvx6HRJbEt2IbpwKpWt5Ad+EtNcvK72nZg/YKaPT9y0aj3BDfJuRPyzaJaKG99
	 LZzDjvziQYlJ7bbCeIkJRaFx5gPtoA6pB5iQBwDHYJSgkoV7R1DlnysWJKRhd/Z/XDjD5
	 Lh71AtvTe5GjZPxUODPFuX0A3D+jgwo/2PCaNNtatwpbtHHOHxo3IlwmGGQXoxY0A9RiJ
	 U7wxWnoXKmOqolv/Kom7WFwUdwEIqbPgzN4/26gL3ejTZIQ7pn0/kuSNi6YkYc1obxGGj
	 pTxPal6x/gn8qgilNKUPxSv9F/LfAhzTE9ApIVB0sgW7RdmJBmfJmv4qvAv2DMCkCbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QpEes12LQW9bJfpQWkPHqAimNC11wtqIVqOSsUjUujc=;
	b=G77PMGDAA+KcmQ3I2wnPQz+I5I6GbQE952JKYcEfvX0gb604VjF2wpbFPNHKOdf9EvYz
	 pEr0vODI2lzBPASQGLzWiQW50pPOTNO4HO8ACvfTnGjA3cT6P/I/H8VnGZzjPBJUWHn3F
	 gpEkvc3GVmcfty1ZtBC4hF4LPeQFoR6bKwB0meI4O18rLqXGjK776VIrHpSXYuKJNPg6k
	 q8Mq0DKB1TVUJHYOnabPy36+LORtILpo83KpYmKDdaL0YlPPxBniMw9B7p8uIlvj2ra+w
	 mVppLGF/SxAdIWurmv0O5OjdWC3pH7frBJuVkQ/EEHbTBMxxhq7jOZr23qdsAwrAAnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUhkcaGY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8CB606A320;
	Wed, 28 Oct 2026 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUhkcaGY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B341F01825;
	Wed, 28 Oct 2026 17:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208386;
	bh=QpEes12LQW9bJfpQWkPHqAimNC11wtqIVqOSsUjUujc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUhkcaGYyv8eK1Tad/oBKkmlxf3P8wiv2iMoGsX4bIwOhvFL9mb2x2pcwn1B0+r/x
	 J+3RJhl1VFVnN09VvP2ZYGaCvApFTNEzNil2xd4zvIhX75gEdpeRKATfdGLAOs0uMN
	 poL1/x96MWlSDcjXoC47dNGy+Jqncn5HBIMUk/6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/516] params: fix charp corruption on allocation failure
Date: Wed, 28 Oct 2026 17:53:30 +0100
Message-ID: <20261028170004.902836743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e6d96f84ac1b5..ca87641c289f1 100644
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



