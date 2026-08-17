Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4C623BCEE;
	Mon, 17 Aug 2026 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976323; cv=none; b=JjWFu2u1N/nxwyPj6JhyXqzA8wtQN+KngA54qnasm/LkLNwKzHqb4htzCLffHH+qs0BPkh8rdn9saSq8cgbP8HRltRIvXvFzXsYC5zs0KeoyWeqojpaoGSLMvpMCOTUEQdqZa1h2LxXUpD2jVJjXsUhhe5FmFY6xs2n/1KIwuRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976323; c=relaxed/simple;
	bh=1TI24cVjhdX86VyXWju6KyB5Hv2fVbfbWr/X9rjBIOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2Y8+5DAmUZ13C0ZvbwLXz3C7KTL7DTd6cUQk1SYEP9yBfCJl7Pr1DbcfGjRwm8D/c3egAh0pI0xWeu+gYeX6ly8xMkKcqUcI0l1RmL700knN+tuFaPLql/VRpBjmZGovKijtr/T4zmmBExMAHw1EQYiPjk8TrDPouJ2FOMJ1OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeyv6zdR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeyv6zdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26321F000E9;
	Mon, 17 Aug 2026 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976322;
	bh=S3z03v+6Hteb/7NoUzan9AUmk3/A7HYA+dd+nv519aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeyv6zdRFk82TTzlpktUVrDfV5SFiS05QoORXgXbXmWrcI01E/UD0PvNTpnY+6v8h
	 +d0C2eMOhXKn92f7zVrkMAjl256GOeiV2XjcTkDejFVsg7umLL8K1Q9QJOF6hcph1g
	 QJjHCoP5TILJjS6ef5lc27KJ2tJxiOEUJ2D3lCX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/389] net: qrtr: ns: Raise lookup limit to 128
Date: Mon, 17 Aug 2026 15:32:53 +0200
Message-ID: <20260817132551.897228473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Patron <priv.luk@gmail.com>

[ Upstream commit 7fc1c937b6b37c77df4ba374c37435ab06a2e945 ]

Current limit of 64 is not enough for Sony Xperia 10 VII (SM6475).

After merging v6.6.142 into a downstream AOSP device, it's stuck on
boot animation and following log spam can be observed in dmesg:

E qrtr    : ctrl_cmd_new_lookup(): QRTR client node exceeds max lookup limit!
E qrtr    : qrtr_ns_worker(): failed while handling packet from 1:16600

No idea why it needs more than 64 client lookups, but it appears to
work fine with 128 as it did when there were no limits.

I don't really have a good way to investigate what it needs all
these lookups for as most of the userspace is closed source.

Fixes: 5640227d9a21 ("net: qrtr: ns: Limit the maximum number of lookups")
Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
Link: https://patch.msgid.link/20260804201919.1148015-1-priv.luk@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 3ebb5d39e153f..4246d21da5d14 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -77,7 +77,7 @@ struct qrtr_node {
  */
 #define QRTR_NS_MAX_NODES   512
 #define QRTR_NS_MAX_SERVERS 256
-#define QRTR_NS_MAX_LOOKUPS 64
+#define QRTR_NS_MAX_LOOKUPS 128
 
 static u16 node_count;
 
-- 
2.53.0



