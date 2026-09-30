Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A9D3C455C;
	Wed, 30 Sep 2026 19:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796685; cv=none; b=J0csMlFFNWmZKUZZmenuNpCvdy2JLbJF6DeOMin5l3b/oxwRn8q9pRONFoW7lxMV3cS5CfKnvc0Tq3FkNOlppfDSaNWoauu8blo3B+ASvO8uIsrohKnVd1DOn+nlVM7jHqvXfGc8qP/J2iO05m9LLz8zERL3lOehri9H3qEWGJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796685; c=relaxed/simple;
	bh=MOOY2liQ9oGdPo1+JdWh0H3UfTqWB/17bq0cj7bneQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLKBh9IH0vpj9mXbUqRWA5OTcHAozz808LZowypSEcoog9xXes4k/jws/coW0J/Bc8VhNEoIRs6u0unxiB7ewGW6dqOj7ZRk1jJmuwJ4IpXcxlNIpCbDBuxPY0S+WzAg781FRtOPKIGQTQYv5aW530TUnTRVyeoVN1nvIGYeCiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIiofAZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIiofAZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C041F000FF;
	Wed, 30 Sep 2026 19:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796684;
	bh=A5ARaIIM7ggqEP5wNuH1EwBsHeYh73Cs4NoSEjSG9RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIiofAZ/zAwY4vz6qpwFrbIeHhdD4g/mT6cn79M07WcP0P4yH7Q40SYrQ7x+mnBEF
	 ulbc73kiz2pxzXuZK53vJmj76ilyc/mTXg+gT7aV8Gypv7OIFWGUtXJRp/JY1qoxkv
	 5/GWxjxGyrSJ8shYGVhm6pyWldiIwUFmU1FCOE2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0955/1193] apparmor: Fix 8-byte alignment for initial dfa blob streams
Date: Wed, 30 Sep 2026 17:27:19 +0200
Message-ID: <20260930152455.458564420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit c567de2c4f5fe6e079672e074e1bc6122bf7e444 ]

The dfa blob stream for the aa_dfa_unpack() function is expected to be aligned
on a 8 byte boundary.

The static nulldfa_src[] and stacksplitdfa_src[] arrays store the initial
apparmor dfa blob streams, but since they are declared as an array-of-chars
the compiler and linker will only ensure a "char" (1-byte) alignment.

Add an __aligned(8) annotation to the arrays to tell the linker to always
align them on a 8-byte boundary. This avoids runtime warnings at startup on
alignment-sensitive platforms like parisc such as:

 Kernel: unaligned access to 0x7f2a584a in aa_dfa_unpack+0x124/0x788 (iir 0xca0109f)
 Kernel: unaligned access to 0x7f2a584e in aa_dfa_unpack+0x210/0x788 (iir 0xca8109c)
 Kernel: unaligned access to 0x7f2a586a in aa_dfa_unpack+0x278/0x788 (iir 0xcb01090)

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Fixes: 98b824ff8984 ("apparmor: refcount the pdb")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 7daf142b99de0..22f4f6bf5c99b 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1905,12 +1905,12 @@ static int __init apparmor_nf_ip_init(void)
 __initcall(apparmor_nf_ip_init);
 #endif
 
-static char nulldfa_src[] = {
+static char nulldfa_src[] __aligned(8) = {
 	#include "nulldfa.in"
 };
 struct aa_dfa *nulldfa;
 
-static char stacksplitdfa_src[] = {
+static char stacksplitdfa_src[] __aligned(8) = {
 	#include "stacksplitdfa.in"
 };
 struct aa_dfa *stacksplitdfa;
-- 
2.53.0



