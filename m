Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996BE4418CB;
	Mon, 17 Aug 2026 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980449; cv=none; b=FXPvBdK29DNPGRqgSfnQbuQfhsPpnGiFih7+TPcombVRsvwcaV63hEISWOfgOXPMXg6B3zXE/9ZvWPWBFjtZEZG0wItlgXr4IOegDvJ2FTD0c4tw5qgPIzucNUxwsMhFVjENiZhL3JFyGpKmkSz0n+BOyXs3ByDMP7mZb9Uwutw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980449; c=relaxed/simple;
	bh=bLrNwCqPhupVAKZPATuXU0y4afEv1NWXfi6bl3nJMxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lrnt2fS0obXZdAjjuxbeGJ3CLpVccqVsaztaO6lflDey7aJtkt0Mj5jvlD4LTOn0ClIEKU8yG9nR2YkU+Z2KDvwNEsooy/I1xq22B8HsHAPHTZy8oKlmBxe2irAT4cp3Sriu7OIfKjZHNLKv2QIqz22L/pBOoYuY6wSzdNQi6VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuD85C8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuD85C8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FA21F00A3A;
	Mon, 17 Aug 2026 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980447;
	bh=6bndXQtboKleKIM+dgOV2XvC1XWc2Nn9BiAFVhqHFH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cuD85C8+qEi+sAQRmnh/Zs2kUJJ3WBT8yl018hnGgVKhle9bzNjMq6nEIdn5wumsE
	 63BhsAK+/3jY12Fb6wJpbIXr9ykuXlO2R2pWUpRLRYf/g2z3klxYJU7vbq2NAn5REu
	 rPlE7d2x4cjCtcwCFICFYYkzT9ms5kP2VXsqpZAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 526/609] net: qrtr: ns: Raise lookup limit to 128
Date: Mon, 17 Aug 2026 15:33:42 +0200
Message-ID: <20260817132601.408254428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5220529a4c62d..4df5f0a9b7419 100644
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



