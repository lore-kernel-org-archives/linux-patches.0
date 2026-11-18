Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056955;
	b=vnY6Zvvmz+zSVEFHhO3ljn7uA+o8nmUc6pQGxf/KNnuJDXTCw3VsUM06N8nLZzd42F7+
	 o2bJZ9NoV0+warmC4VK4+3oXsX2fOqS+vqCiLuWYrAhzrSFQNj+lqwXlfjtMotU/shSEQ
	 erGElN04C+Qv5jRpjiVpzTOiJll8N4CrLfTIQJArZ0S2x/DJTj3IIOYzkc660j3f0xp1X
	 HKuwJmdc/ExxiCMfy4VEZSeDZGvn+aKcp3uY0TxDBwYYaCo3QWl3qxGHP0tR/sZoy7ShE
	 tGlC5P+XUf/zObqFz34YcwGOMM4FGq/PKaD+Zmqy5E+uDhjjKqNT4mmGq71hwwnWP2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j4hcUSGTZA6jJaqzT4eUp8HocKIbVx3Q6X6GdRR0Oa8=;
	b=f2UHDL58V2Wc1D8O+zk2fxW4kvQCHS1RtJfYHUJEZYR2PIvG7fA2eSDLZ44IaSm1Msj0
	 XSG37YwG0OmuqBO5yosgAjnpad+c+iD51vqB160kAHytPW2eYw64QGSruzmGUqWa2s7kd
	 EPDUYUYWM07RFr6T28bKQru9eq5rzkwucWKeqMZb9nvuQ/m0PWLpRpS7Cwml5zcjGEOfO
	 KfvABAljrB8R1bYftbtV4d37qvEUOAEXj53L0X/mdPBgmujoipNhxzo/ICQUFeLN34vdC
	 WnZi3SJgIfNsnos3KYSogIdvV3XQzln2XAHOdVUhZYF+Y7+7Vss/OhZd2dahppe9oyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9zIKTwI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F277606A31C;
	Thu, 19 Nov 2026 02:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9zIKTwI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D761F000C4;
	Thu, 19 Nov 2026 02:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056955;
	bh=j4hcUSGTZA6jJaqzT4eUp8HocKIbVx3Q6X6GdRR0Oa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9zIKTwITHVyZRhUrx68QJ9SSWuLZ3ysG1kM/n+QtlhahHaA88oJHpSXovH8bEjAc
	 95Ggl0Od0/BqgCZ+CQrDgyTkPf4Scy9tpAEqg9Nce7If/rnhcEN0D8/srxoXCX9svf
	 r8j+9VYZSEUwCCw02Ai+6K1kbMFOq7FDDmdY5eyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2121/2214] profiling: fix sampling step on 64-bit big-endian systems
Date: Wed, 18 Nov 2026 16:03:17 +0100
Message-ID: <20261118150135.421661504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit b1d68946a08313895f352af5336623d29739c299 ]

read_profile() stores the sampling step in an unsigned long but copies
only four bytes to userspace.  On 64-bit big-endian systems (not common
obviously), this copies the upper 32 bits and discards the rest, causing
/proc/profile to report zero for normal shift values.

Cast to unsigned int so we get the correct 4 bytes, while keeping the
shift calculation in unsigned long.

A small C reproducer under qemu-s390x reproduced this and proved the fix
works for prof_shift=2.

Link: https://lore.kernel.org/20261020101225.917959-1-thnkslprpt@gmail.com
Fixes: 2d186afd04d6 ("profiling: fix shift-out-of-bounds bugs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/profile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index e9a1efe18caf1..671475fbbce88 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -462,7 +462,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned long sample_step = 1UL << prof_shift;
+	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
 
 	profile_flip_buffers();
 	if (p >= (prof_len+1)*sizeof(unsigned int))
-- 
2.53.0



