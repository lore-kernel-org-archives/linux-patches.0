Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2C03B42FC;
	Thu, 16 Jul 2026 13:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210031; cv=none; b=nBZQJXC6C5590CYWZlFdzaqQ+BSaJ0qjjz7EmLneahK5ST08WOroYuTxuYjLrGLY43yIxAzOhzeVRpAr5xYoeFfd81ku3j2UUTifh37/Sq8+tzSKY4DKdT9DAgqhdYb+2gAqF1aC9g26nds9fJlsVYAavbON99u0ExD/opsK48w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210031; c=relaxed/simple;
	bh=q4rR9W74a3R4+G1fYHzRZuGlfW+j/bCQFQEpndw9zqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LD5BAev4EFQjcgi8ie7Kx73rWSlLLcsSqHj9LuVeZG1eRC+HTKm3mi2Jf7pqHrcJ/jQpbdBYTP02X/YJ4or+V9b5mduvKl0BR8MVjDrrwVmgspT9N+j9uePpf80hidOiiF5UWCqrOk4eZ9xi286e7sRz5kQSyS9oYL4gUA0PbhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+wXrpPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+wXrpPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28621F000E9;
	Thu, 16 Jul 2026 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210030;
	bh=1/rqebuDLynXHVJto4iNpHLwLKpfgo+CvD6PUf/llBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+wXrpPLWgbM7pgKTFqxFSOuZzY4GieBED12gPrONJntM3XwS6lH+Cqt+wiwour4K
	 FU/9bk/2GXF5uEH4Mwkq1dh/Jps8uv+RKfRTxizzdpNX13RRbaEWxw/P1n8A06l7mQ
	 2ILRQ35GNVv5d9ByeeG5uNW5hTkhRZc2L3B9rbPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.1 412/518] audit: fix potential integer overflow in audit_log_n_hex()
Date: Thu, 16 Jul 2026 15:31:20 +0200
Message-ID: <20260716133056.849492384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Robaina <rrobaina@redhat.com>

commit 65dfde57d1e29ce2b76fc23dd565eccd5c0bc0f0 upstream.

The function calculates new_len as len << 1 for hex encoding. This
has two overflow risks: the shift itself can overflow when len is
large, and the result can be truncated when assigned to new_len
(declared as int) from the size_t calculation.

Fix by using check_shl_overflow() to catch shift overflow and
changing new_len and loop counter i to size_t to prevent truncation.

Cc: stable@vger.kernel.org
Fixes: 168b7173959f ("AUDIT: Clean up logging of untrusted strings")
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
[PM: remove vertical whitspace noise]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -62,6 +62,7 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <linux/sctp.h>
+#include <linux/overflow.h>
 
 #include "audit.h"
 
@@ -2080,7 +2081,8 @@ void audit_log_format(struct audit_buffe
 void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 		size_t len)
 {
-	int i, avail, new_len;
+	int avail;
+	size_t i, new_len;
 	unsigned char *ptr;
 	struct sk_buff *skb;
 
@@ -2090,7 +2092,12 @@ void audit_log_n_hex(struct audit_buffer
 	BUG_ON(!ab->skb);
 	skb = ab->skb;
 	avail = skb_tailroom(skb);
-	new_len = len<<1;
+
+	if (check_shl_overflow(len, 1, &new_len)) {
+		audit_log_format(ab, "?");
+		return;
+	}
+
 	if (new_len >= avail) {
 		/* Round the buffer request up to the next multiple */
 		new_len = AUDIT_BUFSIZ*(((new_len-avail)/AUDIT_BUFSIZ) + 1);


