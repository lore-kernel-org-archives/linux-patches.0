Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25ED02C0303;
	Wed, 30 Sep 2026 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783817; cv=none; b=dzmsY3oX5Oawn51/wBdhVGvi8PnQt80Z9vRLQ4F0+oZS65ZKUkwmjmpfmhOWC83vaJdot4RjhcDVKQ2lYIDTnCG1cXxHlOZFvWvFJ/RtdF8GfzWnEv/Lj1zhMl1Y8wJpXuumI+a+DzlGOOvBxu9ziJka+JqVmy/tOBvtyOKSAKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783817; c=relaxed/simple;
	bh=KtQFzqahe01MLJ+C28RTmLIX3Sbzg8DPizujiTNIdRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+zSQCin916o9kU5GJx0aitASveou4yVnmF0n8llUC21x1t/Tvhh51/KGBuGZVJtxnM30xmE6sml7maxABmnKAdzIlspdLgXApd1rj1t92NYZruQ8ipPzRUizSYyddKacnHAq/PTR+OMJpwPzDpi0JA8VhSIFl0u9gJ3kRZ9nU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCN4xFX1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCN4xFX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B85D1F00898;
	Wed, 30 Sep 2026 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783812;
	bh=Hg2MPM8KSivBKd3BA3aL9ZX4zCTo70n2VOE/iQcU6sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCN4xFX1jcwXHk+mfydhk4MCI9g93WRdNg5cIzY4Cgpau3ZWRtH73JThrFFoGPSXG
	 pXPjzxtH9TcUVvmNBG923Uma6akA56L7DVxApuLZvhVXVZB90+XXDXSuX5Zy57M+eo
	 YQhcpZq41hAahg1n5WpHbwlasAIaaEdCQLG4MnVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1e3df0852e82c21ca418@syzkaller.appspotmail.com,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 530/595] nfc: llcp: fix slab-out-of-bounds reads when logging service names
Date: Wed, 30 Sep 2026 17:27:03 +0200
Message-ID: <20260930152359.104602516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Ömer Mete Kaya <omermetekaya0@gmail.com>

[ Upstream commit 7dcf371a35632f035baf77bcf2c129165f772ce4 ]

nfc_llcp_wks_sap() and nfc_llcp_build_sdreq_tlv() pass non-null-
terminated strings to pr_debug() using the %s format specifier.
The buffers are allocated via kmemdup() or come from netlink
attributes and are not guaranteed to be null-terminated, causing
__dynamic_pr_debug() to read beyond the allocated region:

  KASAN: slab-out-of-bounds Read in __dynamic_pr_debug

Fix both call sites by using %.*s with the explicit length to limit
the output to the actual length of the string.

Fixes: d9b8d8e19b07 ("NFC: llcp: Service Name Lookup netlink interface")
Reported-by: syzbot+1e3df0852e82c21ca418@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1e3df0852e82c21ca418
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
Link: https://patch.msgid.link/20260908161952.731468-1-omermetekaya0@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_commands.c | 2 +-
 net/nfc/llcp_core.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 48d02c9686017..52645afa3ac91 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -135,7 +135,7 @@ struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdreq_tlv(u8 tid, const char *uri,
 {
 	struct nfc_llcp_sdp_tlv *sdreq;
 
-	pr_debug("uri: %s, len: %zu\n", uri, uri_len);
+	pr_debug("uri: %.*s, len: %zu\n", (int)uri_len, uri, uri_len);
 
 	/* sdreq->tlv_len is u8, takes uri_len, + 3 for header, + 1 for NULL */
 	if (WARN_ON_ONCE(uri_len > U8_MAX - 4))
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index f4e58fd5cc1fa..859e342f9e8e3 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -358,7 +358,7 @@ static int nfc_llcp_wks_sap(const char *service_name, size_t service_name_len)
 {
 	int sap, num_wks;
 
-	pr_debug("%s\n", service_name);
+	pr_debug("%.*s\n", (int)service_name_len, service_name);
 
 	if (service_name == NULL)
 		return -EINVAL;
-- 
2.53.0



