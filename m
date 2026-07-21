Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816F743935B;
	Tue, 21 Jul 2026 23:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674869; cv=none; b=b1wHgiMZooiYIgg9oSsb0dwpYapggw5YOrzXMRCnF/AZYUL8gXDAuI4o0J9htjiwh7WgkAQWb5rtn7oV9XCRIbpPXDOaXVsAZAJMeW/l4fSl6QkY9UeXQDUWChN17hh5iUtiKt7jHU3tsV4MTGiGEwQAVmEON3agVTT8LScqSJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674869; c=relaxed/simple;
	bh=04Vmik7iwWUjSKQ77ZT/aefIESv28lINcKp1U8kpDqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1LBlMifmUddFv+iC3cdAYKsHvzKycxR9VQHfYBUXMktjaSZ11qwJJeVcLxLNFwG1SPSqkdvBW50McGqYdVZ6o6XwvoF6l6l81DEhomromRzcPqw2CEEhw0fNIqgm5hJtI/cgXjEfEehixna74vxYl1s08QOA1q/FquCjy6m6CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4/koimK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4/koimK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43B31F000E9;
	Tue, 21 Jul 2026 23:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674868;
	bh=is9kPkCRQfyLPx//kPuuWzCf/PPf17sOrPCFviZ3fMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4/koimKUZsfeluTW7PKVKpyMNXHTKpP7PBeMmEdDiSgBiYTe/BWv4tMo1gNSGfOT
	 5hKA0+bxRLv2BmlmSun3kaLpckQb5u6HLmSMTVao1uf/rD1bXpRNc8ZVkIIbeH/QCo
	 he++rV9khMPRsB3FjCQky3o5WMUc9q4OBQ73QOdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 684/699] audit: fix potential integer overflow in audit_log_n_hex()
Date: Tue, 21 Jul 2026 17:27:23 +0200
Message-ID: <20260721152411.207219244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Robaina <rrobaina@redhat.com>

[ Upstream commit 65dfde57d1e29ce2b76fc23dd565eccd5c0bc0f0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -61,6 +61,7 @@
 #include <net/netns/generic.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <linux/overflow.h>
 
 #include "audit.h"
 
@@ -2034,7 +2035,8 @@ void audit_log_format(struct audit_buffe
 void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 		size_t len)
 {
-	int i, avail, new_len;
+	int avail;
+	size_t i, new_len;
 	unsigned char *ptr;
 	struct sk_buff *skb;
 
@@ -2044,7 +2046,12 @@ void audit_log_n_hex(struct audit_buffer
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


