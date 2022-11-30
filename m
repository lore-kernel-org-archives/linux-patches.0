Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0906FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C871EC433D6;
	Wed, 30 Nov 2022 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833078;
	bh=VsE/HWjQxRSXID5Fj3p9heuzQWh+w9K33zN3bgvPy6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inwFYzw0Vi0pmtbxRKXVgUs+Wm6eJAX1LF/+rN9K9OsnfG/t0PXH3C5+AJdp+nBhw
	 evipdNAHQJmVkjETWxRsiAj8rBTsMINi3AWxNvOGxmPDKJ9oyBCW8fUZ/oddPcJ6vj
	 53uqHcn0y6VtAvAKbpK37Q/ioD8vD1B428w3RR9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Mazovetskiy <glex.spb@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/162] tcp: configurable source port perturb table size
Date: Wed, 30 Nov 2022 19:23:44 +0100
Message-Id: <20221130180532.361159510@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gleb Mazovetskiy <glex.spb@gmail.com>

[ Upstream commit aeac4ec8f46d610a10adbaeff5e2edf6a88ffc62 ]

On embedded systems with little memory and no relevant
security concerns, it is beneficial to reduce the size
of the table.

Reducing the size from 2^16 to 2^8 saves 255 KiB
of kernel RAM.

Makes the table size configurable as an expert option.

The size was previously increased from 2^8 to 2^16
in commit 4c2c8f03a5ab ("tcp: increase source port perturb table to
2^16").

Signed-off-by: Gleb Mazovetskiy <glex.spb@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/Kconfig           | 10 ++++++++++
 net/ipv4/inet_hashtables.c | 10 +++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 87983e70f03f..23b06063e1a5 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -403,6 +403,16 @@ config INET_IPCOMP
 
 	  If unsure, say Y.
 
+config INET_TABLE_PERTURB_ORDER
+	int "INET: Source port perturbation table size (as power of 2)" if EXPERT
+	default 16
+	help
+	  Source port perturbation table size (as power of 2) for
+	  RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm.
+
+	  The default is almost always what you want.
+	  Only change this if you know what you are doing.
+
 config INET_XFRM_TUNNEL
 	tristate
 	select INET_TUNNEL
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index c0de655fffd7..c68a1dae25ca 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -721,13 +721,13 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
+ *
  * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
- * attacks were since demonstrated, thus we use 65536 instead to really
- * give more isolation and privacy, at the expense of 256kB of kernel
- * memory.
+ * attacks were since demonstrated, thus we use 65536 by default instead
+ * to really give more isolation and privacy, at the expense of 256kB
+ * of kernel memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 16
-#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
+#define INET_TABLE_PERTURB_SIZE (1 << CONFIG_INET_TABLE_PERTURB_ORDER)
 static u32 *table_perturb;
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-- 
2.35.1



